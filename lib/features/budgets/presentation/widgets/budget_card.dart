import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pocket_plus/core/constants/app_colors.dart';
import 'package:pocket_plus/core/constants/app_sizes.dart';
import 'package:pocket_plus/core/constants/app_text_styles.dart';
import 'package:pocket_plus/core/router/route_names.dart';
import 'package:pocket_plus/core/utils/currency_formatter.dart';
import 'package:pocket_plus/shared/widgets/app_card.dart';
import 'package:pocket_plus/features/budgets/domain/budget_calculator.dart';
import 'package:pocket_plus/features/budgets/domain/entities/budget.dart';
import '../budget_helpers.dart';
import 'budget_progress_bar.dart';
import 'budget_status_chip.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({required this.budget, super.key});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final calculator = BudgetCalculator();
    final status = calculator.computeStatus(budget);
    final daysElapsed = calculator.computeDaysElapsed(budget);

    return AppCard(
      onTap: () => context.push(RouteNames.budgetDetail(budget.id)),
      padding: const EdgeInsets.all(AppSizes.spacing16),
      margin: const EdgeInsets.only(bottom: AppSizes.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: BudgetHelpers.parseBudgetColor(budget.colorHex)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizes.spacing8),
                ),
                child: Icon(
                  BudgetHelpers.budgetIconData(budget.icon),
                  color: BudgetHelpers.parseBudgetColor(budget.colorHex),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.name,
                      style: AppTextStyles.titleMedium(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      budget.budgetType == BudgetType.overall
                          ? 'Overall Spending'
                          : budget.budgetType == BudgetType.custom
                              ? '${budget.categoryIds.length} Categories'
                              : budget.categoryIds.isNotEmpty
                                  ? 'Category Budget'
                                  : 'Budget',
                      style: AppTextStyles.bodyMedium(context,
                          color: AppColors.onSurfaceMuted),
                    ),
                  ],
                ),
              ),
              BudgetStatusChip(budget: budget),
            ],
          ),
          const SizedBox(height: AppSizes.spacing16),
          BudgetProgressBar(budget: budget),
          const SizedBox(height: AppSizes.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _amountColumn(
                context,
                'Spent',
                CurrencyFormatter.format(budget.spentAmount),
                _colorForStatus(status),
              ),
              _amountColumn(
                context,
                'Remaining',
                CurrencyFormatter.format(budget.remainingAmount),
                budget.remainingAmount > 0 ? AppColors.income : AppColors.error,
              ),
              _amountColumn(
                context,
                'Budget',
                CurrencyFormatter.format(budget.amount),
                AppColors.onSurface,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing8),
          Row(
            children: [
              const Icon(Icons.calendar_today,
                  size: 14, color: AppColors.onSurfaceMuted),
              const SizedBox(width: 4),
              Text(
                '${_periodLabel(budget.period)} · $daysElapsed days elapsed',
                style: AppTextStyles.bodyMedium(context,
                    color: AppColors.onSurfaceMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amountColumn(
      BuildContext context, String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.labelSmall(context,
                color: AppColors.onSurfaceMuted)),
        const SizedBox(height: 2),
        Text(
          amount,
          style: AppTextStyles.bodyMedium(context, color: color)
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Color _colorForStatus(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe:
        return AppColors.income;
      case BudgetStatus.warning:
        return AppColors.orange;
      case BudgetStatus.critical:
        return AppColors.warning;
      case BudgetStatus.exceeded:
        return AppColors.error;
    }
  }

  String _periodLabel(BudgetPeriod period) {
    switch (period) {
      case BudgetPeriod.weekly:
        return 'Weekly';
      case BudgetPeriod.monthly:
        return 'Monthly';
      case BudgetPeriod.yearly:
        return 'Yearly';
    }
  }
}
