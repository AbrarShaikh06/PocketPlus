import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/presentation/home_providers.dart';
import '../../../transactions/transactions_providers.dart';
import '../../budgets_providers.dart';
import '../../domain/entities/budget.dart';
import '../services/budget_notification_service.dart';

final budgetsStreamProvider = StreamProvider.autoDispose<List<Budget>>((ref) {
  final currentProfile = ref.watch(currentProfileProvider);
  final userId = ref.watch(currentBookUserIdProvider);
  if (userId == null || currentProfile == null) {
    return const Stream.empty();
  }
  return ref.watch(budgetRepositoryProvider).watchBudgets(
        userId: userId,
        profileId: currentProfile.id,
      );
});

final calculatedBudgetsProvider = Provider.autoDispose<List<Budget>>((ref) {
  final budgetsAsync = ref.watch(budgetsStreamProvider);
  final transactionsAsync = ref.watch(allTransactionsStreamProvider);
  final budgets = budgetsAsync.value ?? [];
  final transactions = transactionsAsync.value ?? [];
  final calculator = ref.watch(budgetCalculatorProvider);
  final result =
      calculator.calculate(budgets: budgets, transactions: transactions);
  ref.read(budgetNotificationServiceProvider).checkAndNotify(budgets: result);
  return result;
});

final activeBudgetsProvider = Provider.autoDispose<List<Budget>>((ref) {
  final budgets = ref.watch(calculatedBudgetsProvider);
  return budgets.where((b) => !b.isPaused && !b.isDeleted).toList();
});

final pausedBudgetsProvider = Provider.autoDispose<List<Budget>>((ref) {
  final budgetsAsync = ref.watch(budgetsStreamProvider);
  final budgets = budgetsAsync.value ?? [];
  return budgets.where((b) => b.isPaused).toList();
});

final topBudgetsProvider = Provider.autoDispose<List<Budget>>((ref) {
  final budgets = ref.watch(calculatedBudgetsProvider);
  return budgets.take(3).toList();
});

final budgetByIdProvider =
    Provider.autoDispose.family<Budget?, String>((ref, id) {
  final budgets = ref.watch(calculatedBudgetsProvider);
  for (final b in budgets) {
    if (b.id == id) return b;
  }
  return null;
});

final budgetVsActualProvider = Provider.autoDispose
    .family<({int budgetAmount, int spentAmount, double percentage})?, String>(
  (ref, budgetId) {
    final budget = ref.watch(budgetByIdProvider(budgetId));
    if (budget == null) return null;
    return (
      budgetAmount: budget.amount,
      spentAmount: budget.spentAmount,
      percentage: ref
          .watch(budgetCalculatorProvider)
          .computePercentage(budget)
          .toDouble(),
    );
  },
);
