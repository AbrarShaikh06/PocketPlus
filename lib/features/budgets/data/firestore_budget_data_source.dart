import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

import '../domain/entities/budget.dart';

abstract interface class FirestoreBudgetDataSource {
  Stream<List<Budget>> watchBudgets(
      {required String userId, required String profileId});
  Future<Budget> createBudget(Budget budget);
  Future<Budget> updateBudget(Budget budget);
  Future<void> softDeleteBudget(String budgetId);
  Future<void> togglePauseBudget(String budgetId, bool isPaused);
  Future<List<Budget>> getBudgetsFromCache(
      {required String userId, required String profileId});
}

class FirestoreBudgetDataSourceImpl implements FirestoreBudgetDataSource {
  FirestoreBudgetDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('budgets');

  Query<Map<String, dynamic>> _scoped(String userId, String profileId) => _col
      .where('userId', isEqualTo: userId)
      .where('profileId', isEqualTo: profileId)
      .where('isDeleted', isEqualTo: false);

  @override
  Stream<List<Budget>> watchBudgets(
      {required String userId, required String profileId}) {
    return _scoped(userId, profileId).snapshots().map((snap) {
      final list = snap.docs.map((d) => Budget.fromJson(d.data())).toList();
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return list;
    });
  }

  @override
  Future<Budget> createBudget(Budget budget) async {
    await _col.doc(budget.id).set(budget.toJson());
    return budget;
  }

  @override
  Future<Budget> updateBudget(Budget budget) async {
    final now = DateTime.now();
    final toUpdate = budget.copyWith(updatedAt: now);
    await _col.doc(budget.id).set(toUpdate.toJson());
    return toUpdate;
  }

  @override
  Future<void> softDeleteBudget(String budgetId) async {
    await _col.doc(budgetId).update({
      'isDeleted': true,
      'deletedAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  @override
  Future<void> togglePauseBudget(String budgetId, bool isPaused) async {
    await _col.doc(budgetId).update({
      'isPaused': isPaused,
      'updatedAt': Timestamp.now(),
    });
  }

  @override
  Future<List<Budget>> getBudgetsFromCache(
      {required String userId, required String profileId}) async {
    final snap = await _scoped(userId, profileId)
        .get(const GetOptions(source: Source.cache));
    return snap.docs.map((d) => Budget.fromJson(d.data())).toList();
  }
}
