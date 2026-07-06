import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';

import '../../../core/router/route_names.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../budgets/presentation/providers/budget_providers.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/widgets.dart';
import '../../home/presentation/home_providers.dart';
import '../../profiles/profiles_providers.dart';
import '../../categories/domain/entities/category.dart';
import '../../transactions/domain/entities/transaction.dart';
import '../domain/entities/report_summary.dart';
import 'reports_view_model.dart';

Color parseColor(String? hex) {
  if (hex == null) return AppColors.primary;
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

IconData getIconData(String iconName) {
  switch (iconName) {
    case 'local_gas_station':
      return Icons.local_gas_station;
    case 'restaurant':
      return Icons.restaurant;
    case 'work':
      return Icons.work;
    case 'home':
      return Icons.home;
    case 'inventory':
      return Icons.inventory_2;
    case 'bolt':
      return Icons.bolt;
    case 'directions_bus':
      return Icons.directions_bus;
    case 'medical_services':
      return Icons.medical_services;
    case 'people':
      return Icons.people;
    case 'monetization_on':
      return Icons.monetization_on;
    case 'add_circle':
      return Icons.add_circle;
    case 'remove_circle':
      return Icons.remove_circle;
    default:
      return Icons.receipt_long;
  }
}

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key, this.initialMonth});

  final DateTime? initialMonth;

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.initialMonth != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final now = DateTime.now();
        final target = widget.initialMonth!;
        final start = DateTime(target.year, target.month, 1);
        final end = DateTime(
          target.year,
          target.month,
          target.month == now.month
              ? now.day
              : _daysInMonth(target.year, target.month),
          23,
          59,
          59,
          999,
        );
        ref
            .read(reportsViewModelProvider.notifier)
            .selectCustomRange(DateTimeRange(start: start, end: end));
      });
    }
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  Future<void> _selectCustomRange() async {
    final state = ref.read(reportsViewModelProvider);
    final range = await showDateRangePicker(
      context: context,
      initialDateRange: state.dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (range != null) {
      ref.read(reportsViewModelProvider.notifier).selectCustomRange(range);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reportsViewModelProvider);
    final notifier = ref.read(reportsViewModelProvider.notifier);

    final summaryAsync =
        ref.watch(periodReportSummaryProvider(state.dateRange));
    final txnsAsync = ref.watch(periodTransactionsProvider(state.dateRange));
    final categoriesAsync = ref.watch(categoriesProvider);
    final userPlanAsync = ref.watch(userPlanProvider);

    final isLoading = summaryAsync.isLoading ||
        txnsAsync.isLoading ||
        categoriesAsync.isLoading ||
        userPlanAsync.isLoading;

    final summary = summaryAsync.asData?.value;
    final txns = txnsAsync.asData?.value ?? [];
    final categories = categoriesAsync.asData?.value ?? [];

    // Most recent transactions in the selected period (newest first).
    final recentTxns = [...txns]
      ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    final recentVisible = recentTxns.take(4).toList();

    final displayRangeStr =
        _formatPeriodLabel(state.dateRange, state.periodType);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Reports',
          style:
              AppTextStyles.titleMedium(context, color: Colors.white).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing16,
          vertical: AppSizes.spacing24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Period Selector
            _PeriodSelector(
              selectedPeriod: state.periodType,
              onPeriodSelected: (type) => notifier.selectPeriod(type),
              dateRangeStr: displayRangeStr,
              onCustomRangeSelected: _selectCustomRange,
            ),
            const SizedBox(height: AppSizes.spacing24),

            // Budget Overview Card
            Consumer(
              builder: (context, ref, child) {
                final budgets = ref.watch(activeBudgetsProvider);
                if (budgets.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spacing24),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budget Overview',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        ...budgets.map(
                          (b) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: parseColor(b.colorHex),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    b.name,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Text(
                                  '${CurrencyFormatter.format(b.spentAmount)} / ${CurrencyFormatter.format(b.amount)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            if (isLoading) ...[
              LoadingShimmer.card(height: 120),
              const SizedBox(height: AppSizes.spacing24),
              const LoadingShimmerList(itemCount: 4),
            ] else if (txns.isEmpty) ...[
              const EmptyState(
                message: 'No transactions exist for selected period',
                illustration: Icon(
                  Icons.receipt_long_outlined,
                  size: 48,
                  color: AppColors.onSurfaceMuted,
                ),
              ),
            ] else ...[
              // Net Profit Hero Card
              _NetProfitHero(summary: summary),
              const SizedBox(height: AppSizes.spacing16),

              // Income/Expense Split Row
              _IncomeExpenseSplitRow(summary: summary),
              const SizedBox(height: AppSizes.spacing24),

              // Recent Transactions Card (replaces the old category breakdown)
              _RecentTransactionsCard(
                transactions: recentVisible,
                categories: categories,
                onViewAll: () => context.push(RouteNames.history),
              ),
              const SizedBox(height: AppSizes.spacing24),

              // Action Buttons Layout
              AppButton(
                label: state.isExporting ? 'Exporting...' : 'Export PDF',
                icon: state.isExporting ? null : Icons.picture_as_pdf,
                onPressed: state.isExporting
                    ? null
                    : () => notifier.exportPDF(context),
                isLoading: state.isExporting,
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: AnimatedFab(
        onPressed: () {
          HapticFeedback.mediumImpact();
          context.push(RouteNames.addTransaction);
        },
      ),
    );
  }

  String _formatPeriodLabel(DateTimeRange range, PeriodType periodType) {
    if (periodType == PeriodType.all) return AppLocalizations.of(context)!.all;
    final df = DateFormat('d MMM yyyy');
    return '${df.format(range.start)} – ${df.format(range.end)}';
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.selectedPeriod,
    required this.onPeriodSelected,
    required this.dateRangeStr,
    required this.onCustomRangeSelected,
  });

  final PeriodType selectedPeriod;
  final ValueChanged<PeriodType> onPeriodSelected;
  final String dateRangeStr;
  final VoidCallback onCustomRangeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSizes.radius12),
            border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.all(AppSizes.spacing4),
          child: Row(
            children: [
              _buildTab(
                context,
                PeriodType.week,
                AppLocalizations.of(context)!.thisWeek,
              ),
              _buildTab(
                context,
                PeriodType.month,
                AppLocalizations.of(context)!.thisMonth,
              ),
              _buildTab(
                context,
                PeriodType.all,
                AppLocalizations.of(context)!.all,
              ),
              _buildTab(
                context,
                PeriodType.custom,
                AppLocalizations.of(context)!.custom,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spacing12),
        Text(
          dateRangeStr,
          style: AppTextStyles.labelSmall(context).copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTab(BuildContext context, PeriodType type, String label) {
    final bool isSelected = selectedPeriod == type;
    return Expanded(
      child: InkWell(
        onTap: () {
          if (type == PeriodType.custom) {
            onCustomRangeSelected();
          } else {
            onPeriodSelected(type);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelLarge(
              context,
              color: isSelected ? AppColors.onPrimary : AppColors.secondary,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _NetProfitHero extends StatelessWidget {
  const _NetProfitHero({required this.summary});

  final ReportSummary? summary;

  @override
  Widget build(BuildContext context) {
    final profit = summary?.netProfit ?? 0;
    final change = summary?.changePercent ?? 0.0;
    final sign = change >= 0 ? '+' : '';
    final trendText = '$sign${change.toStringAsFixed(0)}% vs last month';
    final isPositive = profit >= 0;
    final heroColor = isPositive ? AppColors.primary : AppColors.expense;

    return Container(
      decoration: BoxDecoration(
        color: heroColor,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Net Profit',
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: Colors.white.withValues(alpha: 0.7),
                  ).copyWith(fontWeight: FontWeight.w600),
                ),
                Icon(
                  profit >= 0 ? Icons.trending_up : Icons.trending_down,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing8),
            Text(
              CurrencyFormatter.formatRupees(profit),
              style: AppTextStyles.displayLarge(
                context,
                color: Colors.white,
              ).copyWith(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.spacing4),
            Text(
              trendText,
              style: AppTextStyles.labelSmall(
                context,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomeExpenseSplitRow extends StatelessWidget {
  const _IncomeExpenseSplitRow({required this.summary});

  final ReportSummary? summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            title: 'Income',
            amount: summary?.totalIncome ?? 0,
            accentColor: AppColors.income,
            backgroundColor: AppColors.primary,
            icon: Icons.arrow_downward,
          ),
        ),
        const SizedBox(width: AppSizes.spacing16),
        Expanded(
          child: _StatTile(
            title: 'Expenses',
            amount: summary?.totalExpense ?? 0,
            accentColor: AppColors.expense,
            backgroundColor: AppColors.expense,
            icon: Icons.arrow_upward,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.title,
    required this.amount,
    required this.accentColor,
    required this.backgroundColor,
    required this.icon,
  });

  final String title;
  final int amount;
  final Color accentColor;
  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.7)),
              const SizedBox(width: AppSizes.spacing8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelLarge(
                    context,
                    color: Colors.white.withValues(alpha: 0.7),
                  ).copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing12),
          Text(
            CurrencyFormatter.formatRupees(amount),
            style: AppTextStyles.titleLarge(
              context,
              color: Colors.white,
            ).copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _RecentTransactionsCard extends StatelessWidget {
  const _RecentTransactionsCard({
    required this.transactions,
    required this.categories,
    required this.onViewAll,
  });

  final List<Transaction> transactions;
  final List<Category> categories;
  final VoidCallback onViewAll;

  Category _resolveCategory(String? categoryId) {
    if (categoryId != null && categoryId.startsWith('sys_unaccounted')) {
      return Category(
        id: categoryId,
        name: 'Unaccounted',
        icon: 'help_outline',
        colorHex: '#9E9E9E',
        type: TransactionType.expense,
      );
    }
    return categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => const Category(
        id: 'unknown',
        name: 'Unknown',
        icon: 'receipt_long',
        colorHex: '#607D8B',
        type: TransactionType.expense,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        side: BorderSide(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Transactions',
              style: AppTextStyles.titleMedium(
                context,
                color: AppColors.primary,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.spacing12),
            if (transactions.isEmpty)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSizes.spacing16),
                child: Text(
                  'No transactions in this period.',
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
              )
            else
              ...transactions.map(
                (txn) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spacing8),
                  child: TransactionListTile(
                    transaction: txn,
                    category: _resolveCategory(txn.categoryId),
                  ),
                ),
              ),
            const SizedBox(height: AppSizes.spacing8),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'View full transaction history',
                variant: AppButtonVariant.outline,
                onPressed: onViewAll,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
