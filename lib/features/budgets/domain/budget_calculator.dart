import '../../transactions/domain/entities/transaction.dart';
import '../../../shared/models/transaction_type.dart';
import 'entities/budget.dart';

class BudgetCalculator {
  List<Budget> calculate({
    required List<Budget> budgets,
    required List<Transaction> transactions,
  }) {
    return budgets.map((budget) {
      if (budget.isPaused || budget.isDeleted) return budget;

      final periodRange = getPeriodRange(budget);
      final relevantTxns = transactions.where((t) {
        if (t.isDeleted) return false;
        if (t.type != TransactionType.expense) return false;
        if (t.transactionDate.isBefore(periodRange.start)) return false;
        if (budget.endDate != null &&
            t.transactionDate.isAfter(budget.endDate!)) {
          return false;
        }
        if (budget.endDate == null &&
            t.transactionDate.isAfter(periodRange.end)) {
          return false;
        }
        return true;
      });

      final filtered = _filterByBudgetType(budget, relevantTxns);
      final spentAmount = filtered.fold(0, (sum, t) => sum + t.amount);
      final remainingAmount =
          (budget.amount - spentAmount).clamp(0, budget.amount);

      return budget.copyWith(
        spentAmount: spentAmount,
        remainingAmount: remainingAmount,
      );
    }).toList();
  }

  List<Transaction> _filterByBudgetType(
    Budget budget,
    Iterable<Transaction> transactions,
  ) {
    switch (budget.budgetType) {
      case BudgetType.overall:
        return transactions.toList();
      case BudgetType.category:
        final catId =
            budget.categoryIds.isNotEmpty ? budget.categoryIds.first : null;
        if (catId == null) return [];
        return transactions.where((t) => t.categoryId == catId).toList();
      case BudgetType.custom:
        if (budget.categoryIds.isEmpty) return [];
        return transactions
            .where((t) =>
                t.categoryId != null &&
                budget.categoryIds.contains(t.categoryId))
            .toList();
    }
  }

  ({DateTime start, DateTime end}) getPeriodRange(Budget budget) {
    final now = DateTime.now();
    switch (budget.period) {
      case BudgetPeriod.weekly:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return (
          start: DateTime(weekStart.year, weekStart.month, weekStart.day),
          end: DateTime(weekStart.year, weekStart.month, weekStart.day + 7),
        );
      case BudgetPeriod.monthly:
        final monthStart = DateTime(now.year, now.month, 1);
        final monthEnd = DateTime(now.year, now.month + 1, 1);
        return (start: monthStart, end: monthEnd);
      case BudgetPeriod.yearly:
        return (
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year + 1, 1, 1),
        );
    }
  }

  int computeDaysElapsed(Budget budget) {
    final range = getPeriodRange(budget);
    final start =
        budget.startDate.isAfter(range.start) ? budget.startDate : range.start;
    final end = budget.endDate ?? range.end;
    final now = DateTime.now();
    if (now.isBefore(start)) return 0;
    if (now.isAfter(end)) return end.difference(start).inDays;
    return now.difference(start).inDays;
  }

  int computeTotalDays(Budget budget) {
    final range = getPeriodRange(budget);
    final start =
        budget.startDate.isAfter(range.start) ? budget.startDate : range.start;
    final end = budget.endDate ?? range.end;
    return end.difference(start).inDays;
  }

  int computeForecast(Budget budget) {
    final daysElapsed = computeDaysElapsed(budget);
    if (daysElapsed <= 0) return 0;
    final totalDays = computeTotalDays(budget);
    if (totalDays <= 0) return budget.spentAmount;
    final dailyAvg = budget.spentAmount / daysElapsed;
    return (dailyAvg * totalDays).round();
  }

  int computeDailyAverage(Budget budget) {
    final daysElapsed = computeDaysElapsed(budget);
    if (daysElapsed <= 0) return 0;
    return (budget.spentAmount / daysElapsed).round();
  }

  int computeWeeklyAverage(Budget budget) {
    final daysElapsed = computeDaysElapsed(budget);
    if (daysElapsed <= 0) return 0;
    final weeks = (daysElapsed / 7).clamp(1, double.infinity);
    return (budget.spentAmount / weeks).round();
  }

  int computeRemainingDailyAllowance(Budget budget) {
    final daysElapsed = computeDaysElapsed(budget);
    final totalDays = computeTotalDays(budget);
    final remainingDays = totalDays - daysElapsed;
    if (remainingDays <= 0 || budget.remainingAmount <= 0) return 0;
    return (budget.remainingAmount / remainingDays).round();
  }

  BudgetStatus computeStatus(Budget budget) {
    if (budget.amount <= 0) return BudgetStatus.safe;
    final percentage = (budget.spentAmount / budget.amount) * 100;
    if (percentage >= 100) return BudgetStatus.exceeded;
    if (percentage >= 90) return BudgetStatus.critical;
    if (percentage >= 70) return BudgetStatus.warning;
    return BudgetStatus.safe;
  }

  int computePercentage(Budget budget) {
    if (budget.amount <= 0) return 0;
    return ((budget.spentAmount / budget.amount) * 100).round().clamp(0, 999);
  }
}
