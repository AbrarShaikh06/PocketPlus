import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';

import '../../../core/utils/chart_formatter.dart';
import '../../budgets/domain/entities/budget.dart';
import '../../budgets/presentation/providers/budget_providers.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/widgets.dart';
import '../../reports/domain/entities/report_summary.dart';
import 'analytics_providers.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  int _activeTabIndex = 0; // 0 = Net Profit, 1 = Income, 2 = Expense
  bool _showBudgetOverlay = false;

  @override
  Widget build(BuildContext context) {
    final chartDataAsync = ref.watch(analyticsChartProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.analytics,
          style:
              AppTextStyles.titleLarge(context, color: Colors.white).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _showBudgetOverlay
                  ? Icons.account_balance_wallet
                  : Icons.account_balance_wallet_outlined,
              color: _showBudgetOverlay ? AppColors.warning : Colors.white,
            ),
            onPressed: () =>
                setState(() => _showBudgetOverlay = !_showBudgetOverlay),
            tooltip: 'Toggle budget overlay',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: chartDataAsync.when(
        data: (summaries) {
          final activeBudgets = ref.watch(activeBudgetsProvider);
          final monthlyBudgets = activeBudgets
              .where((b) => b.period == BudgetPeriod.monthly)
              .toList();

          final hasNoData = summaries.isEmpty ||
              summaries.every(
                (s) =>
                    s.totalIncome == 0 &&
                    s.totalExpense == 0 &&
                    s.netProfit == 0,
              );

          if (hasNoData) {
            return Center(
              child: SingleChildScrollView(
                child: EmptyState(
                  message: AppLocalizations.of(context)!.addTxnsForInsights,
                  ctaLabel: AppLocalizations.of(context)!.addTransaction,
                  onCtaPressed: () => context.push(RouteNames.addTransaction),
                ),
              ),
            );
          }

          // Calculate statistics
          final bestMonth = summaries.reduce((a, b) {
            final valA = _getMetricValue(a);
            final valB = _getMetricValue(b);
            return valA >= valB ? a : b;
          });

          final worstMonth = summaries.reduce((a, b) {
            final valA = _getMetricValue(a);
            final valB = _getMetricValue(b);
            return valA <= valB ? a : b;
          });

          final totalVal =
              summaries.map(_getMetricValue).fold(0, (sum, val) => sum + val);
          final avgVal = totalVal ~/ summaries.length;

          double momGrowth = 0.0;
          if (summaries.length >= 2) {
            final current = summaries[summaries.length - 1];
            final previous = summaries[summaries.length - 2];
            final currentVal = _getMetricValue(current);
            final previousVal = _getMetricValue(previous);
            if (previousVal != 0) {
              momGrowth =
                  ((currentVal - previousVal) / previousVal.abs()) * 100.0;
            }
          }

          final bestMonthLabel = DateFormat('MMM yyyy').format(bestMonth.month);
          final worstMonthLabel =
              DateFormat('MMM yyyy').format(worstMonth.month);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing16,
              vertical: AppSizes.spacing24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Chart Card
                _buildChartCard(summaries, totalVal, momGrowth,
                    monthlyBudgets: monthlyBudgets),
                const SizedBox(height: AppSizes.spacing24),

                // Insights Header
                Text(
                  AppLocalizations.of(context)!.insights,
                  style: AppTextStyles.titleMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSizes.spacing16),

                // Stat Bento Cards Layout
                Row(
                  children: [
                    _buildBestMonthCard(bestMonth, bestMonthLabel),
                    const SizedBox(width: AppSizes.spacing16),
                    _buildWorstMonthCard(worstMonth, worstMonthLabel),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing16),
                _buildAvgMonthlyCard(avgVal, summaries),
                const SizedBox(height: AppSizes.spacing16),
                _buildGrowthCard(momGrowth),
                const SizedBox(height: AppSizes.spacing32),
              ],
            ),
          );
        },
        loading: () => const _AnalyticsSkeletonLoading(),
        error: (error, stack) => Center(
          child: EmptyState(
            message: AppLocalizations.of(context)!.failedToLoadAnalytics,
            ctaLabel: AppLocalizations.of(context)!.retry,
            onCtaPressed: () => ref.invalidate(analyticsChartProvider),
          ),
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

  int _getMetricValue(ReportSummary summary) {
    if (_activeTabIndex == 0) return summary.netProfit;
    if (_activeTabIndex == 1) return summary.totalIncome;
    return summary.totalExpense;
  }

  Color get _lineColor {
    if (_activeTabIndex == 2) return AppColors.expense;
    return AppColors.secondary;
  }

  String _formatAmt(double value) => formatChartAmount(value);

  Color _getMetricColor(int value) {
    if (_activeTabIndex == 2) return AppColors.expense;
    if (_activeTabIndex == 0 && value < 0) return AppColors.expense;
    return AppColors.primary;
  }

  Widget _buildChartCard(
    List<ReportSummary> summaries,
    int totalVal,
    double momGrowth, {
    List<Budget> monthlyBudgets = const [],
  }) {
    final List<double> chartValues =
        summaries.map((s) => _getMetricValue(s) / 100.0).toList();

    final double maxVal = chartValues.fold(0.0, (p, v) => v > p ? v : p);
    final double minVal = _activeTabIndex == 0
        ? chartValues
            .fold(0.0, (p, v) => v < p ? v : p)
            .clamp(double.negativeInfinity, 0.0)
        : 0.0;
    final double yRange = (maxVal - minVal).clamp(100.0, double.infinity);

    final String metricLabel;
    if (_activeTabIndex == 0) {
      metricLabel = AppLocalizations.of(context)!.totalNetProfit;
    } else if (_activeTabIndex == 1) {
      metricLabel = AppLocalizations.of(context)!.totalIncome;
    } else {
      metricLabel = AppLocalizations.of(context)!.totalExpense;
    }

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metricLabel.toUpperCase(),
                      style: AppTextStyles.labelSmall(context).copyWith(
                        color: AppColors.onSurfaceMuted,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing4),
                    Text(
                      CurrencyFormatter.formatRupees(totalVal),
                      style: AppTextStyles.displayLarge(
                        context,
                        color: _getMetricColor(totalVal),
                      ).copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (summaries.length >= 2)
                  Container(
                    decoration: BoxDecoration(
                      color: momGrowth >= 0
                          ? AppColors.secondaryLight
                          : AppColors.errorLight,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: (momGrowth >= 0
                                ? AppColors.secondary
                                : AppColors.error)
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          momGrowth >= 0
                              ? Icons.trending_up
                              : Icons.trending_down,
                          size: 14,
                          color: momGrowth >= 0
                              ? AppColors.secondary
                              : AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${momGrowth >= 0 ? "+" : ""}${momGrowth.toStringAsFixed(1)}%',
                          style: AppTextStyles.labelSmall(context).copyWith(
                            color: momGrowth >= 0
                                ? AppColors.secondary
                                : AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing20),

            // Tab Switcher
            Container(
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(AppSizes.spacing4),
              child: Row(
                children: [
                  _buildTabButton(0, AppLocalizations.of(context)!.netProfit),
                  _buildTabButton(1, AppLocalizations.of(context)!.income),
                  _buildTabButton(2, AppLocalizations.of(context)!.expense),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.spacing24),

            // Line Chart
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: minVal,
                  maxY: maxVal + yRange * 0.25,
                  clipData: const FlClipData.none(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: yRange / 4,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.outline.withValues(alpha: 0.15),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 48,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 && minVal == 0) {
                            return const SizedBox();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              '₹${_formatAmt(value)}',
                              style: AppTextStyles.labelSmall(context)
                                  .copyWith(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final int index = value.toInt();
                          if (index < 0 || index >= summaries.length) {
                            return const SizedBox();
                          }
                          final String label =
                              DateFormat('MMM').format(summaries[index].month);
                          final bool isCurrentMonth =
                              index == summaries.length - 1;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              label,
                              style: isCurrentMonth
                                  ? AppTextStyles.labelLarge(
                                      context,
                                      color: AppColors.secondary,
                                    ).copyWith(fontWeight: FontWeight.bold)
                                  : AppTextStyles.labelSmall(
                                      context,
                                      color: AppColors.onSurfaceMuted,
                                    ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.outline.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => AppColors.onSurface,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            CurrencyFormatter.formatRupees(
                              (spot.y * 100).round(),
                            ),
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: _buildLineBarsData(summaries, monthlyBudgets),
                ),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
              ),
            ),
            if (_showBudgetOverlay && monthlyBudgets.isNotEmpty) ...[
              const SizedBox(height: AppSizes.spacing12),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: monthlyBudgets
                    .map(
                      (b) => Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 3,
                            decoration: BoxDecoration(
                              color: _parseColor(b.colorHex),
                              borderRadius: BorderRadius.circular(1.5),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            b.name,
                            style: AppTextStyles.labelSmall(context).copyWith(
                              color: AppColors.onSurfaceMuted,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<LineChartBarData> _buildLineBarsData(
      List<ReportSummary> summaries, List<Budget> monthlyBudgets) {
    final bars = <LineChartBarData>[
      LineChartBarData(
        spots: List.generate(summaries.length, (index) {
          return FlSpot(
            index.toDouble(),
            _getMetricValue(summaries[index]) / 100.0,
          );
        }),
        isCurved: true,
        preventCurveOverShooting: true,
        color: _lineColor,
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            final isCurrentMonth = index == summaries.length - 1;
            return FlDotCirclePainter(
              radius: isCurrentMonth ? 5 : 3,
              color: _lineColor,
              strokeWidth: isCurrentMonth ? 2 : 0,
              strokeColor: Colors.white,
            );
          },
        ),
        belowBarData: BarAreaData(
          show: true,
          color: _lineColor.withValues(alpha: 0.08),
        ),
      ),
    ];

    if (_showBudgetOverlay) {
      for (final b in monthlyBudgets) {
        final budgetValue = b.amount / 100.0;
        bars.add(
          LineChartBarData(
            spots: List.generate(summaries.length,
                (index) => FlSpot(index.toDouble(), budgetValue)),
            isCurved: false,
            dashArray: [6, 4],
            color: _parseColor(b.colorHex),
            barWidth: 1.5,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        );
      }
    }

    return bars;
  }

  Color _parseColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  Widget _buildTabButton(int index, String title) {
    final bool isSelected = _activeTabIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _activeTabIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelLarge(
              context,
              color: isSelected
                  ? AppColors.primary
                  : Colors.white.withValues(alpha: 0.8),
            ).copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildBestMonthCard(ReportSummary bestMonth, String subtitle) {
    final monthName = DateFormat('MMMM').format(bestMonth.month);
    final val = _getMetricValue(bestMonth);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius12),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: AppColors.secondary,
                  size: 18,
                ),
                const SizedBox(width: AppSizes.spacing8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.bestMonth,
                    style: AppTextStyles.labelSmall(context).copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing16),
            Text(
              monthName,
              style: AppTextStyles.titleMedium(context)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.spacing4),
            Text(
              CurrencyFormatter.formatRupees(val),
              style: AppTextStyles.labelLarge(
                context,
                color: val >= 0 ? AppColors.income : AppColors.expense,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorstMonthCard(ReportSummary worstMonth, String subtitle) {
    final monthName = DateFormat('MMMM').format(worstMonth.month);
    final val = _getMetricValue(worstMonth);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius12),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning, color: AppColors.error, size: 18),
                const SizedBox(width: AppSizes.spacing8),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.worstMonth,
                    style: AppTextStyles.labelSmall(context).copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing16),
            Text(
              monthName,
              style: AppTextStyles.titleMedium(context)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.spacing4),
            Text(
              CurrencyFormatter.formatRupees(val),
              style: AppTextStyles.labelLarge(
                context,
                color: val >= 0 ? AppColors.income : AppColors.expense,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvgMonthlyCard(int avgVal, List<ReportSummary> summaries) {
    final double maxVal = summaries
        .map((s) => _getMetricValue(s).abs().toDouble())
        .fold(1.0, (prev, val) => val > prev ? val : prev);
    final double progressFactor =
        maxVal > 0 ? (avgVal.abs() / maxVal).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calculate, color: AppColors.secondary, size: 18),
              const SizedBox(width: AppSizes.spacing8),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.avgMonthly,
                  style: AppTextStyles.labelSmall(context).copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing12),
          Text(
            CurrencyFormatter.formatRupees(avgVal),
            style: AppTextStyles.titleLarge(
              context,
              color: _getMetricColor(avgVal),
            ).copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSizes.spacing4),
          Text(
            AppLocalizations.of(context)!
                .lastXMonths(summaries.length.toString()),
            style: AppTextStyles.labelSmall(
              context,
              color: AppColors.onSurfaceMuted,
            ),
          ),
          const SizedBox(height: AppSizes.spacing12),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outline.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progressFactor,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthCard(double momGrowth) {
    final hasGrown = momGrowth >= 0;
    final growthColor = hasGrown ? AppColors.secondary : AppColors.expense;
    final growthBg = hasGrown ? AppColors.secondaryLight : AppColors.errorLight;
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: growthBg,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(color: growthColor.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: growthColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.momGrowth,
            style: AppTextStyles.labelSmall(context).copyWith(
              color: growthColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: AppSizes.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasGrown ? Icons.arrow_upward : Icons.arrow_downward,
                color: growthColor,
                size: 28,
              ),
              const SizedBox(width: AppSizes.spacing4),
              Text(
                '${momGrowth.abs().toStringAsFixed(1)}%',
                style: AppTextStyles.displayLarge(context, color: growthColor)
                    .copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing4),
          Text(
            hasGrown
                ? AppLocalizations.of(context)!.lookingGood
                : AppLocalizations.of(context)!.needsAttention,
            style: AppTextStyles.labelSmall(context).copyWith(
              color: growthColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsSkeletonLoading extends StatelessWidget {
  const _AnalyticsSkeletonLoading();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoadingShimmer.card(height: 280),
          const SizedBox(height: AppSizes.spacing24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSizes.spacing16,
            mainAxisSpacing: AppSizes.spacing16,
            childAspectRatio: 1.4,
            children: List.generate(4, (_) => LoadingShimmer.card(height: 80)),
          ),
          const SizedBox(height: AppSizes.spacing24),
          LoadingShimmer.card(height: 56),
        ],
      ),
    );
  }
}
