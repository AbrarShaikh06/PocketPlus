import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../domain/savings_entry.dart';
import '../domain/savings_goal.dart';

abstract interface class FirestoreSavingsDataSource {
  Stream<List<SavingsGoal>> watchGoals({
    required String userId,
    required String profileId,
  });
  Stream<List<SavingsEntry>> watchEntries({required String goalId});
  Future<SavingsGoal> createGoal(SavingsGoal goal);
  Future<void> updateGoal(SavingsGoal goal);
  Future<void> addEntry(SavingsEntry entry);
  Future<void> softDeleteGoal(String goalId);
  Future<void> restoreGoal(String goalId);
}

class FirestoreSavingsDataSourceImpl implements FirestoreSavingsDataSource {
  FirestoreSavingsDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;
  static const _uuid = Uuid();

  CollectionReference<Map<String, dynamic>> get _goals =>
      _firestore.collection('savings_goals');
  CollectionReference<Map<String, dynamic>> get _entries =>
      _firestore.collection('savings_entries');

  @override
  Stream<List<SavingsGoal>> watchGoals({
    required String userId,
    required String profileId,
  }) {
    // deletedAt is filtered client-side (savings_providers) to match the
    // existing userId+profileId index.
    return _goals
        .where('userId', isEqualTo: userId)
        .where('profileId', isEqualTo: profileId)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => SavingsGoal.fromJson(d.data())).toList(),
        );
  }

  @override
  Stream<List<SavingsEntry>> watchEntries({required String goalId}) {
    return _entries.where('goalId', isEqualTo: goalId).snapshots().map((snap) {
      final list =
          snap.docs.map((d) => SavingsEntry.fromJson(d.data())).toList();
      list.sort((a, b) => b.entryDate.compareTo(a.entryDate));
      return list;
    });
  }

  @override
  Future<SavingsGoal> createGoal(SavingsGoal goal) async {
    final id = goal.id.isEmpty ? _uuid.v4() : goal.id;
    final now = DateTime.now();
    final toCreate = goal.copyWith(id: id, createdAt: now, updatedAt: now);
    await _goals.doc(id).set(toCreate.toJson());
    return toCreate;
  }

  @override
  Future<void> updateGoal(SavingsGoal goal) async {
    await _goals
        .doc(goal.id)
        .set(goal.copyWith(updatedAt: DateTime.now()).toJson());
  }

  @override
  Future<void> addEntry(SavingsEntry entry) async {
    final id = entry.id.isEmpty ? _uuid.v4() : entry.id;
    final goalRef = _goals.doc(entry.goalId);
    await _firestore.runTransaction((txn) async {
      final snap = await txn.get(goalRef);
      if (!snap.exists) {
        throw StateError('Savings goal ${entry.goalId} not found');
      }
      final goal = SavingsGoal.fromJson(snap.data()!);
      final newSaved = goal.savedAmount + entry.amount;
      final achieved = newSaved >= goal.targetAmount;
      final now = DateTime.now();

      txn.set(
        _entries.doc(id),
        entry.copyWith(id: id, createdAt: now).toJson(),
      );
      txn.update(goalRef, {
        'savedAmount': newSaved,
        'isAchieved': achieved,
        if (achieved && !goal.isAchieved) 'achievedAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });
    });
  }

  @override
  Future<void> softDeleteGoal(String goalId) async {
    await _goals.doc(goalId).update({
      'deletedAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  @override
  Future<void> restoreGoal(String goalId) async {
    await _goals.doc(goalId).update({
      'deletedAt': null,
      'updatedAt': Timestamp.now(),
    });
  }
}
