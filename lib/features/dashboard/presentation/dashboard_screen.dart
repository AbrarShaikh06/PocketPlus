import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../../categories/domain/entities/category.dart';
import '../../home/presentation/home_providers.dart';
import '../../transactions/domain/entities/transaction.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/widgets.dart';
import '../dashboard_providers.dart';
import '../domain/dashboard_data.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const _netProfitKey = Key('dashboard-net-profit');
  static const _statsRowKey = Key('dashboard-stats-row');
  static const _recentKey = Key('dashboard-recent');
  static const _actionsKey = Key('dashboard-quick-actions');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardViewModelProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return dashboardAsync.when(
      loading: () => const _DashboardSkeleton(),
      error: (error, _) => _DashboardError(
        message: error.toString(),
        onRetry: () => ref.read(dashboardViewModelProvider.notifier).refresh(),
      ),
      data: (data) {
        if (!data.hasData) {
          return _DashboardEmpty(
            onAddTransaction: () => ref
                .read(dashboardViewModelProvider.notifier)
                .navigateToAddTransaction(context),
          );
        }

        final categories = categoriesAsync.asData?.value ?? [];
        return _DashboardContent(
          data: data,
          categories: categories,
          onRefresh: () =>
              ref.read(dashboardViewModelProvider.notifier).refresh(),
          onAddTransaction: () => ref
              .read(dashboardViewModelProvider.notifier)
              .navigateToAddTransaction(context),
          onCaptureSms: () => ref
              .read(dashboardViewModelProvider.notifier)
              .navigateToCaptureSms(context),
          onViewReports: () => ref
              .read(dashboardViewModelProvider.notifier)
              .navigateToReports(context),
          onTransactionTap: (id) => ref
              .read(dashboardViewModelProvider.notifier)
              .navigateToTransactionDetail(context, id),
          onViewAllTransactions: () => ref
              .read(dashboardViewModelProvider.notifier)
              .navigateToHistory(context),
        );
      },
    );
  }
}

// ── Loading Skeleton ────────────────────────────────────────────────────────

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSizes.spacing24),
      child: Column(
        children: [
          LoadingShimmer.card(height: 160),
          const SizedBox(height: AppSizes.spacing24),
          Row(
            children: [
              Expanded(child: LoadingShimmer.card(height: 88)),
              const SizedBox(width: AppSizes.spacing12),
              Expanded(child: LoadingShimmer.card(height: 88)),
              const SizedBox(width: AppSizes.spacing12),
              Expanded(child: LoadingShimmer.card(height: 88)),
            ],
          ),
          const SizedBox(height: AppSizes.spacing24),
          const LoadingShimmerList(itemCount: 5, itemHeight: 72),
          const SizedBox(height: AppSizes.spacing24),
          LoadingShimmer.card(height: 56),
        ],
      ),
    );
  }
}

// ── Error State ─────────────────────────────────────────────────────────────

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.spacing24),
        child: EmptyState(
          illustration: const Icon(
            Icons.cloud_off_rounded,
            size: 64,
            color: AppColors.onSurfaceMuted,
          ),
          message: AppLocalizations.of(context)!.cantConnect,
          ctaLabel: AppLocalizations.of(context)!.retry,
          onCtaPressed: onRetry,
        ),
      ),
    );
  }
}

// ── Empty State ─────────────────────────────────────────────────────────────

class _DashboardEmpty extends StatelessWidget {
  const _DashboardEmpty({required this.onAddTransaction});

  final VoidCallback onAddTransaction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.spacing24),
        child: EmptyState(
          illustration: const Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppColors.onSurfaceMuted,
          ),
          message: AppLocalizations.of(context)!.noTransactionsYet,
          ctaLabel: AppLocalizations.of(context)!.addFirstTransaction,
          onCtaPressed: onAddTransaction,
        ),
      ),
    );
  }
}

// ── Dashboard Content ───────────────────────────────────────────────────────

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.data,
    required this.categories,
    required this.onRefresh,
    required this.onAddTransaction,
    required this.onCaptureSms,
    required this.onViewReports,
    required this.onTransactionTap,
    required this.onViewAllTransactions,
  });

  final DashboardData data;
  final List<Category> categories;
  final VoidCallback onRefresh;
  final VoidCallback onAddTransaction;
  final VoidCallback onCaptureSms;
  final VoidCallback onViewReports;
  final void Function(String id) onTransactionTap;
  final VoidCallback onViewAllTransactions;

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat('MMMM yyyy').format(data.month);

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      color: AppColors.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSizes.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Net Profit Card
            _NetProfitCard(
              key: DashboardScreen._netProfitKey,
              netProfit: data.netProfit,
              monthLabel: monthLabel,
            ),
            const SizedBox(height: AppSizes.spacing24),

            // Quick Stats Row
            _QuickStatsRow(
              key: DashboardScreen._statsRowKey,
              income: data.totalIncome,
              expense: data.totalExpense,
              count: data.transactionCount,
              onViewAll: onViewAllTransactions,
            ),
            const SizedBox(height: AppSizes.spacing24),

            // Recent Transactions
            _RecentTransactionsSection(
              key: DashboardScreen._recentKey,
              transactions: data.recentTransactions,
              categories: categories,
              onTransactionTap: onTransactionTap,
              onViewAll: onViewAllTransactions,
            ),
            const SizedBox(height: AppSizes.spacing24),

            // Quick Actions
            _QuickActions(
              key: DashboardScreen._actionsKey,
              onAddTransaction: onAddTransaction,
              onCaptureSms: onCaptureSms,
              onViewReports: onViewReports,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Net Profit Card ─────────────────────────────────────────────────────────

class _NetProfitCard extends StatelessWidget {
  const _NetProfitCard({
    super.key,
    required this.netProfit,
    required this.monthLabel,
  });

  final int netProfit;
  final String monthLabel;

  @override
  Widget build(BuildContext context) {
    final isPositive = netProfit >= 0;
    final bgColor = isPositive ? AppColors.primary : AppColors.error;
    final formatted = CurrencyFormatter.format(netProfit.abs());

    return Semantics(
      label: AppLocalizations.of(context)!
          .netProfitForMonthArg(monthLabel, formatted),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppSizes.radius16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                monthLabel,
                style: AppTextStyles.labelSmall(context).copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSizes.spacing16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    isPositive ? '\u20b9' : '-\u20b9',
                    style: AppTextStyles.displayLarge(context).copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacing8),
                  Flexible(
                    child: Text(
                      formatted.replaceFirst('\u20b9', '').trim(),
                      style: AppTextStyles.displayHero(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.spacing12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.spacing12,
                  vertical: AppSizes.spacing4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: AppSizes.spacing4),
                    Text(
                      isPositive
                          ? AppLocalizations.of(context)!.netProfit
                          : AppLocalizations.of(context)!.netLoss,
                      style: AppTextStyles.labelSmall(context).copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick Stats Row ────────────────────────────────────────────────────────

class _QuickStatsRow extends StatelessWidget {
  const _QuickStatsRow({
    super.key,
    required this.income,
    required this.expense,
    required this.count,
    required this.onViewAll,
  });

  final int income;
  final int expense;
  final int count;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: AppLocalizations.of(context)!.income,
            amount: income,
            icon: Icons.arrow_downward,
            iconColor: AppColors.income,
            bgColor: AppColors.primaryLight,
          ),
        ),
        const SizedBox(width: AppSizes.spacing12),
        Expanded(
          child: _StatCard(
            label: AppLocalizations.of(context)!.expense,
            amount: expense,
            icon: Icons.arrow_upward,
            iconColor: AppColors.expense,
            bgColor: AppColors.errorLight,
          ),
        ),
        const SizedBox(width: AppSizes.spacing12),
        Expanded(
          child: _StatCard(
            label: AppLocalizations.of(context)!.transactionsLabel,
            amount: count,
            icon: Icons.receipt_long,
            iconColor: AppColors.primary,
            bgColor: AppColors.primaryLight,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  final String label;
  final int amount;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: bgColor,
                  child: Icon(icon, size: 14, color: iconColor),
                ),
                const SizedBox(width: AppSizes.spacing8),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.labelSmall(context).copyWith(
                      color: iconColor,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing12),
            Text(
              CurrencyFormatter.format(amount),
              style: AppTextStyles.titleMedium(context).copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Recent Transactions Section ─────────────────────────────────────────────

class _RecentTransactionsSection extends StatelessWidget {
  const _RecentTransactionsSection({
    super.key,
    required this.transactions,
    required this.categories,
    required this.onTransactionTap,
    required this.onViewAll,
  });

  final List<Transaction> transactions;
  final List<Category> categories;
  final void Function(String id) onTransactionTap;
  final VoidCallback onViewAll;

  Category _findCategory(String? categoryId) {
    return categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => const Category(
        id: '',
        name: '',
        icon: 'receipt_long',
        type: TransactionType.expense,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context)!.recentTransactions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.recentTransactions,
                style: AppTextStyles.titleMedium(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing12,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: onViewAll,
                child: Text(
                  AppLocalizations.of(context)!.viewAll,
                  style: AppTextStyles.labelSmall(context).copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing12),
          if (transactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSizes.spacing24),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppSizes.radius12),
                border:
                    Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.noRecentTransactions,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
              ),
            )
          else
            ...List.generate(transactions.length, (index) {
              final txn = transactions[index];
              final category = _findCategory(txn.categoryId);
              return Padding(
                padding: EdgeInsets.only(
                  bottom:
                      index < transactions.length - 1 ? AppSizes.spacing8 : 0,
                ),
                child: TransactionListTile(
                  transaction: txn,
                  category: category,
                  index: index,
                  onTap: () => onTransactionTap(txn.id),
                ),
              );
            }),
        ],
      ),
    );
  }
}

// ── Quick Actions ───────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    super.key,
    required this.onAddTransaction,
    required this.onCaptureSms,
    required this.onViewReports,
  });

  final VoidCallback onAddTransaction;
  final VoidCallback onCaptureSms;
  final VoidCallback onViewReports;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context)!.quickActions,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.quickActions,
            style: AppTextStyles.titleMedium(context).copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSizes.spacing12),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.add_rounded,
                  label: AppLocalizations.of(context)!.addTransaction,
                  onTap: onAddTransaction,
                ),
              ),
              const SizedBox(width: AppSizes.spacing12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.sms_outlined,
                  label: AppLocalizations.of(context)!.captureSms,
                  onTap: onCaptureSms,
                ),
              ),
              const SizedBox(width: AppSizes.spacing12),
              Expanded(
                child: _ActionButton(
                  icon: Icons.bar_chart_rounded,
                  label: AppLocalizations.of(context)!.reports,
                  onTap: onViewReports,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppSizes.radius12),
            border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(height: AppSizes.spacing4),
              Text(
                label,
                style: AppTextStyles.labelSmall(context).copyWith(
                  color: AppColors.onSurfaceMuted,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
