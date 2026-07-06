import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

import '../../transactions/domain/entities/transaction.dart';

/// Read-only access to an owner's transactions for report aggregation.
abstract interface class FirestoreReportDataSource {
  Stream<List<Transaction>> watchTransactionsForProfile({
    required String userId,
    required String profileId,
  });
}

class FirestoreReportDataSourceImpl implements FirestoreReportDataSource {
  FirestoreReportDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<List<Transaction>> watchTransactionsForProfile({
    required String userId,
    required String profileId,
  }) {
    return _firestore
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('profileId', isEqualTo: profileId)
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Transaction.fromJson(d.data())).toList(),
        );
  }
}
