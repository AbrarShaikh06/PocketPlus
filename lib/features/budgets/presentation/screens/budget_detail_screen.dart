import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/transaction_list_tile.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../home/presentation/home_providers.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/transactions_providers.dart';
import '../../../../shared/models/transaction_type.dart';
import '../../domain/budget_calculator.dart';
import '../../domain/entities/budget.dart';
import '../budget_helpers.dart';
import '../budget_view_model.dart';
import '../providers/budget_providers.dart';
import '../widgets/budget_forecast_card.dart';
import '../widgets/budget_insight_card.dart';
import '../widgets/budget_progress_bar.dart';
import '../widgets/budget_status_chip.dart';
import '../widgets/circular_budget_indicator.dart';

class BudgetDetailScreen extends ConsumerWidget {
  const BudgetDetailScreen({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(budgetByIdProvider(budgetId));
    if (budget == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(AppLocalizations.of(context)!.budgetNotFound),
        ),
      );
    }

    final calculator = BudgetCalculator();
    final forecast = calculator.computeForecast(budget);
    final dailyAvg = calculator.computeDailyAverage(budget);
    final weeklyAvg = calculator.computeWeeklyAverage(budget);
    final daysElapsed = calculator.computeDaysElapsed(budget);
    final totalDays = calculator.computeTotalDays(budget);
    final transactions = ref.watch(allTransactionsStreamProvider).value ?? [];

    // Filter transactions contributing to this budget
    final contributingTxns =
        _filterContributingTransactions(budget, transactions, calculator);

    // Find largest expense and most frequent merchant
    final largestExpense = contributingTxns.isNotEmpty
        ? contributingTxns.reduce((a, b) => a.amount > b.amount ? a : b)
        : null;
    final merchantGroups = <String, int>{};
    for (final t in contributingTxns) {
      if (t.merchantName != null) {
        merchantGroups[t.merchantName!] =
            (merchantGroups[t.merchantName!] ?? 0) + 1;
      }
    }
    final mostFrequentMerchant = merchantGroups.entries.isEmpty
        ? null
        : merchantGroups.entries.reduce((a, b) => a.value > b.value ? a : b);

    final categories = ref.watch(categoriesProvider).value ?? [];
    final categoryMap = {for (final c in categories) c.id: c};

    return Scaffold(
      appBar: AppBar(
        title: Text(budget.name),
        actions: [
          PopupMenuButton<BudgetAction>(
            onSelected: (action) => _handleAction(context, ref, action, budget),
            itemBuilder: (context) {
              final l = AppLocalizations.of(context)!;
              return [
                if (!budget.isPaused)
                  PopupMenuItem(
                      value: BudgetAction.pause, child: Text(l.pause)),
                if (budget.isPaused)
                  PopupMenuItem(
                      value: BudgetAction.resume, child: Text(l.resume)),
                PopupMenuItem(value: BudgetAction.edit, child: Text(l.edit)),
                PopupMenuItem(
                    value: BudgetAction.duplicate, child: Text(l.duplicate)),
                PopupMenuItem(
                    value: BudgetAction.delete, child: Text(l.delete)),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircularBudgetIndicator(budget: budget, size: 80),
                const SizedBox(width: AppSizes.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BudgetStatusChip(budget: budget),
                      const SizedBox(height: AppSizes.spacing8),
                      Text(
                        '${CurrencyFormatter.format(budget.spentAmount)} of ${CurrencyFormatter.format(budget.amount)}',
                        style: AppTextStyles.bodyMedium(context),
                      ),
                      Text(
                        '$daysElapsed of $totalDays days elapsed',
                        style: AppTextStyles.labelSmall(context,
                            color: AppColors.onSurfaceMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing16),
            BudgetProgressBar(budget: budget, height: 16),
            const SizedBox(height: AppSizes.spacing24),
            // Stats cards
            Row(
              children: [
                Expanded(
                    child: _statCard(
                        context,
                        AppLocalizations.of(context)!.dailyAvg,
                        CurrencyFormatter.format(dailyAvg))),
                const SizedBox(width: AppSizes.spacing8),
                Expanded(
                    child: _statCard(
                        context,
                        AppLocalizations.of(context)!.weeklyAvg,
                        CurrencyFormatter.format(weeklyAvg))),
                const SizedBox(width: AppSizes.spacing8),
                Expanded(
                    child: _statCard(
                        context,
                        AppLocalizations.of(context)!.forecast,
                        CurrencyFormatter.format(forecast))),
              ],
            ),
            const SizedBox(height: AppSizes.spacing16),
            BudgetForecastCard(budget: budget),
            const SizedBox(height: AppSizes.spacing24),
            // Insights
            Text(AppLocalizations.of(context)!.insights,
                style: AppTextStyles.titleMedium(context)),
            const SizedBox(height: AppSizes.spacing12),
            ..._generateInsights(
                context, budget, calculator, contributingTxns, categories),
            const SizedBox(height: AppSizes.spacing24),
            // Category breakdown
            if (budget.budgetType == BudgetType.custom ||
                budget.budgetType == BudgetType.category)
              _categoryBreakdown(
                  context, budget, contributingTxns, categoryMap),
            const SizedBox(height: AppSizes.spacing24),
            // Largest expense
            if (largestExpense != null) ...[
              Text(AppLocalizations.of(context)!.largestExpense,
                  style: AppTextStyles.titleMedium(context)),
              const SizedBox(height: AppSizes.spacing8),
              _expenseTile(context, largestExpense,
                  categoryMap[largestExpense.categoryId]),
              const SizedBox(height: AppSizes.spacing24),
            ],
            // Most frequent merchant
            if (mostFrequentMerchant != null) ...[
              BudgetInsightCard(
                icon: Icons.store,
                title: AppLocalizations.of(context)!.mostFrequent,
                subtitle:
                    '${mostFrequentMerchant.key} · ${mostFrequentMerchant.value} transactions',
                color: AppColors.blue,
              ),
              const SizedBox(height: AppSizes.spacing24),
            ],
            // Transactions
            Text(
                AppLocalizations.of(context)!
                    .transactionsCount(contributingTxns.length),
                style: AppTextStyles.titleMedium(context)),
            const SizedBox(height: AppSizes.spacing8),
            if (contributingTxns.isEmpty)
              EmptyState(
                  message:
                      AppLocalizations.of(context)!.noTransactionsYetBudget)
            else
              ...contributingTxns.take(20).map(
                    (txn) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.spacing8),
                      child: TransactionListTile(
                        transaction: txn,
                        category: categoryMap[txn.categoryId] ??
                            Category(
                              id: 'unknown',
                              name: 'Unknown',
                              icon: 'receipt_long',
                              type: txn.type,
                            ),
                        onTap: () => context.push('/transaction/${txn.id}'),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(BuildContext context, String label, String value) {
    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacing12),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: 2),
          Text(label,
              style: AppTextStyles.labelSmall(context,
                  color: AppColors.onSurfaceMuted)),
        ],
      ),
    );
  }

  Widget _expenseTile(
      BuildContext context, Transaction txn, Category? category) {
    return InkWell(
      onTap: () => context.push('/transaction/${txn.id}'),
      child: AppCard(
        padding: const EdgeInsets.all(AppSizes.spacing12),
        child: Row(
          children: [
            if (category != null)
              CircleAvatar(
                backgroundColor:
                    BudgetHelpers.parseBudgetColor(category.colorHex ?? '')
                        .withValues(alpha: 0.15),
                child: Icon(BudgetHelpers.budgetIconData(category.icon),
                    size: 20,
                    color: BudgetHelpers.parseBudgetColor(
                        category.colorHex ?? '')),
              ),
            const SizedBox(width: AppSizes.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(txn.merchantName ?? category?.name ?? 'Unknown',
                      style: AppTextStyles.bodyMedium(context)),
                  Text(
                    '${txn.transactionDate.day}/${txn.transactionDate.month}/${txn.transactionDate.year}',
                    style: AppTextStyles.labelSmall(context,
                        color: AppColors.onSurfaceMuted),
                  ),
                ],
              ),
            ),
            Text(
              CurrencyFormatter.format(txn.amount),
              style:
                  AppTextStyles.bodyMedium(context, color: AppColors.expense),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryBreakdown(BuildContext context, Budget budget,
      List<Transaction> txns, Map<String, Category> categoryMap) {
    final perCategory = <String, int>{};
    for (final t in txns) {
      final catId = t.categoryId ?? 'uncategorized';
      perCategory[catId] = (perCategory[catId] ?? 0) + t.amount;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.categoryBreakdown,
            style: AppTextStyles.titleMedium(context)),
        const SizedBox(height: AppSizes.spacing8),
        ...perCategory.entries.map((e) {
          final cat = categoryMap[e.key];
          final percentage =
              budget.amount > 0 ? (e.value / budget.amount * 100).round() : 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spacing8),
            child: Row(
              children: [
                Expanded(
                  child: Text(cat?.name ?? e.key,
                      style: AppTextStyles.bodyMedium(context)),
                ),
                Text(
                  '${CurrencyFormatter.format(e.value)} ($percentage%)',
                  style: AppTextStyles.labelSmall(context,
                      color: AppColors.onSurfaceMuted),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  List<BudgetInsightCard> _generateInsights(
      BuildContext context,
      Budget budget,
      BudgetCalculator calculator,
      List<Transaction> txns,
      List<Category> categories) {
    final insights = <BudgetInsightCard>[];
    if (txns.isEmpty) return insights;

    // Most expensive day of week
    final dayTotals = <int, int>{};
    for (final t in txns) {
      final day = t.transactionDate.weekday;
      dayTotals[day] = (dayTotals[day] ?? 0) + t.amount;
    }
    if (dayTotals.isNotEmpty) {
      final mostExpensiveDay =
          dayTotals.entries.reduce((a, b) => a.value > b.value ? a : b);
      final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      insights.add(
        BudgetInsightCard(
          icon: Icons.calendar_view_week,
          title: AppLocalizations.of(context)!.mostExpensiveDay,
          subtitle:
              '${dayNames[mostExpensiveDay.key - 1]} · ${CurrencyFormatter.format(mostExpensiveDay.value)}',
          color: AppColors.orange,
        ),
      );
    }

    // Daily average
    final daysElapsed = calculator.computeDaysElapsed(budget);
    if (daysElapsed > 0) {
      insights.add(
        BudgetInsightCard(
          icon: Icons.trending_up,
          title: AppLocalizations.of(context)!.averageDailySpending,
          subtitle:
              CurrencyFormatter.format(calculator.computeDailyAverage(budget)),
          color: AppColors.blue,
        ),
      );
    }

    return insights;
  }

  List<Transaction> _filterContributingTransactions(
      Budget budget, List<Transaction> allTxns, BudgetCalculator calculator) {
    final range = calculator.getPeriodRange(budget);
    return allTxns.where((t) {
      if (t.isDeleted) return false;
      if (t.type == TransactionType.income) return false;
      if (t.transactionDate.isBefore(range.start)) return false;
      if (budget.endDate != null &&
          t.transactionDate.isAfter(budget.endDate!)) {
        return false;
      }
      if (budget.endDate == null && t.transactionDate.isAfter(range.end)) {
        return false;
      }
      switch (budget.budgetType) {
        case BudgetType.overall:
          return true;
        case BudgetType.category:
          return budget.categoryIds.isNotEmpty &&
              t.categoryId == budget.categoryIds.first;
        case BudgetType.custom:
          return t.categoryId != null &&
              budget.categoryIds.contains(t.categoryId);
      }
    }).toList()
      ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
  }

  void _handleAction(
      BuildContext context, WidgetRef ref, BudgetAction action, Budget budget) {
    switch (action) {
      case BudgetAction.edit:
        context.push('/budgets/edit/${budget.id}');
      case BudgetAction.delete:
        _confirmDelete(context, ref, budget.id);
      case BudgetAction.pause:
        ref
            .read(budgetDetailActionProvider.notifier)
            .togglePause(budget.id, true);
      case BudgetAction.resume:
        ref
            .read(budgetDetailActionProvider.notifier)
            .togglePause(budget.id, false);
      case BudgetAction.duplicate:
        ref
            .read(budgetDetailActionProvider.notifier)
            .duplicate(budget, context);
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String budgetId) {
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteBudget),
        content: Text(l.areYouSureUndone),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(budgetDetailActionProvider.notifier).delete(budgetId);
              context.pop();
            },
            child:
                Text(l.delete, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
