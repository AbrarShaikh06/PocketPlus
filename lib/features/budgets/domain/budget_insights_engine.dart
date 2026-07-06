import 'package:flutter/material.dart';
import 'package:pocket_plus/core/utils/currency_formatter.dart';

import '../../transactions/domain/entities/transaction.dart';
import 'entities/budget.dart';

class BudgetInsight {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? color;

  const BudgetInsight({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.color,
  });
}

class BudgetInsightsEngine {
  List<BudgetInsight> generate({
    required Budget budget,
    required List<Transaction> transactions,
    required List<Transaction> previousPeriodTransactions,
  }) {
    final insights = <BudgetInsight>[];
    if (transactions.isEmpty) return insights;

    final currentTotal = transactions.fold(0, (sum, t) => sum + t.amount);
    final previousTotal =
        previousPeriodTransactions.fold(0, (sum, t) => sum + t.amount);
    if (previousTotal > 0) {
      final change =
          ((currentTotal - previousTotal) / previousTotal * 100).round();
      insights.add(
        BudgetInsight(
          title:
              'Spending ${change > 0 ? 'increased' : 'decreased'} ${change.abs()}%',
          subtitle: 'Compared to last ${budget.period.name}',
          icon: change > 0 ? Icons.trending_up : Icons.trending_down,
          color: change > 0 ? Colors.red : Colors.green,
        ),
      );
    }

    final dayTotals = <int, int>{};
    for (final t in transactions) {
      dayTotals[t.transactionDate.weekday] =
          (dayTotals[t.transactionDate.weekday] ?? 0) + t.amount;
    }
    if (dayTotals.isNotEmpty) {
      final maxDay =
          dayTotals.entries.reduce((a, b) => a.value > b.value ? a : b);
      const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      insights.add(
        BudgetInsight(
          title: 'Most expensive: ${dayNames[maxDay.key - 1]}',
          subtitle:
              '${CurrencyFormatter.format(maxDay.value)} spent on this day',
          icon: Icons.calendar_view_week,
          color: Colors.orange,
        ),
      );
    }

    if (transactions.isNotEmpty) {
      final maxTxn = transactions.reduce((a, b) => a.amount > b.amount ? a : b);
      insights.add(
        BudgetInsight(
          title: 'Highest expense: ${maxTxn.merchantName ?? "Unknown"}',
          subtitle: CurrencyFormatter.format(maxTxn.amount),
          icon: Icons.arrow_upward,
          color: Colors.red,
        ),
      );
    }

    return insights;
  }
}
