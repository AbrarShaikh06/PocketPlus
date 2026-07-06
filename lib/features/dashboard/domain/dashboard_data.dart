import 'package:freezed_annotation/freezed_annotation.dart';

import '../../transactions/domain/entities/transaction.dart';

part 'dashboard_data.freezed.dart';

@freezed
abstract class DashboardData with _$DashboardData {
  const factory DashboardData({
    required int netProfit,
    required int totalIncome,
    required int totalExpense,
    required int transactionCount,
    required List<Transaction> recentTransactions,
    required DateTime month,
  }) = _DashboardData;

  const DashboardData._();

  bool get hasData => recentTransactions.isNotEmpty || transactionCount > 0;
}
