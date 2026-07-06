import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

import '../domain/entities/transaction.dart';

/// Firestore access for the `transactions` collection.
///
/// Every query is scoped by userId + profileId and excludes soft-deleted
/// records (CLAUDE.md: never show `isDeleted == true`).
abstract interface class FirestoreTransactionDataSource {
  Stream<List<Transaction>> watchTransactions({
    required String userId,
    required String profileId,
  });
  Future<Transaction> createTransaction(Transaction transaction);
  Future<Transaction> updateTransaction(Transaction transaction);
  Future<void> softDeleteTransaction(String transactionId);
  Future<void> restoreTransaction(String transactionId);
  Future<List<Transaction>> getTransactionsFromCache({
    required String userId,
    required String profileId,
  });
}

class FirestoreTransactionDataSourceImpl
    implements FirestoreTransactionDataSource {
  FirestoreTransactionDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('transactions');

  Query<Map<String, dynamic>> _scoped(String userId, String profileId) => _col
      .where('userId', isEqualTo: userId)
      .where('profileId', isEqualTo: profileId)
      .where('isDeleted', isEqualTo: false);

  // Sorted client-side (newest first) to avoid an extra composite index on
  // transactionDate beyond the existing userId+profileId+isDeleted index.
  List<Transaction> _map(QuerySnapshot<Map<String, dynamic>> snap) {
    final list = snap.docs.map((d) => Transaction.fromJson(d.data())).toList();
    list.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    return list;
  }

  @override
  Stream<List<Transaction>> watchTransactions({
    required String userId,
    required String profileId,
  }) {
    return _scoped(userId, profileId).snapshots().map(_map);
  }

  @override
  Future<Transaction> createTransaction(Transaction transaction) async {
    await _col.doc(transaction.id).set(transaction.toJson());
    return transaction;
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    await _col.doc(transaction.id).set(transaction.toJson());
    return transaction;
  }

  @override
  Future<void> softDeleteTransaction(String transactionId) async {
    await _col.doc(transactionId).update({
      'isDeleted': true,
      'deletedAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  @override
  Future<void> restoreTransaction(String transactionId) async {
    await _col.doc(transactionId).update({
      'isDeleted': false,
      'deletedAt': null,
      'updatedAt': Timestamp.now(),
    });
  }

  @override
  Future<List<Transaction>> getTransactionsFromCache({
    required String userId,
    required String profileId,
  }) async {
    final snap = await _scoped(userId, profileId)
        .get(const GetOptions(source: Source.cache));
    return _map(snap);
  }
}
