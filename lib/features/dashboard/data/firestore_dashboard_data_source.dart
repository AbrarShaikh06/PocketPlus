import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;

import '../../transactions/domain/entities/transaction.dart';
import '../../../shared/models/models.dart';
import '../domain/dashboard_data.dart';

abstract interface class FirestoreDashboardDataSource {
  Stream<DashboardData> watchDashboardData({
    required String userId,
    required String profileId,
  });
}

class FirestoreDashboardDataSourceImpl implements FirestoreDashboardDataSource {
  FirestoreDashboardDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('transactions');

  Query<Map<String, dynamic>> _scoped(String userId, String profileId) => _col
      .where('userId', isEqualTo: userId)
      .where('profileId', isEqualTo: profileId)
      .where('isDeleted', isEqualTo: false);

  @override
  Stream<DashboardData> watchDashboardData({
    required String userId,
    required String profileId,
  }) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startOfNextMonth = now.month < 12
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);

    return _scoped(userId, profileId).snapshots().map((snap) {
      final all = snap.docs.map((d) => Transaction.fromJson(d.data())).toList();
      all.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

      final monthTxns = all.where(
        (t) =>
            t.transactionDate
                .isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
            t.transactionDate.isBefore(startOfNextMonth),
      );

      int income = 0;
      int expense = 0;
      for (final t in monthTxns) {
        if (t.type == TransactionType.income) {
          income += t.amount;
        } else {
          expense += t.amount;
        }
      }

      return DashboardData(
        netProfit: income - expense,
        totalIncome: income,
        totalExpense: expense,
        transactionCount: monthTxns.length,
        recentTransactions: all.take(5).toList(),
        month: startOfMonth,
      );
    });
  }
}
