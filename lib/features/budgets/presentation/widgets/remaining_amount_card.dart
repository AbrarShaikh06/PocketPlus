import 'package:flutter/material.dart';

import 'package:pocket_plus/core/constants/app_colors.dart';
import 'package:pocket_plus/core/constants/app_sizes.dart';
import 'package:pocket_plus/core/constants/app_text_styles.dart';
import 'package:pocket_plus/core/utils/currency_formatter.dart';
import 'package:pocket_plus/shared/widgets/app_card.dart';
import 'package:pocket_plus/features/budgets/domain/budget_calculator.dart';
import 'package:pocket_plus/features/budgets/domain/entities/budget.dart';

class RemainingAmountCard extends StatelessWidget {
  const RemainingAmountCard({required this.budget, super.key});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final calculator = BudgetCalculator();
    final dailyAvg = calculator.computeDailyAverage(budget);
    final dailyAllowance = calculator.computeRemainingDailyAllowance(budget);

    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Remaining', style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSizes.spacing8),
          Text(
            CurrencyFormatter.format(budget.remainingAmount),
            style: AppTextStyles.titleLarge(context,
                color: budget.remainingAmount > 0
                    ? AppColors.income
                    : AppColors.error),
          ),
          const SizedBox(height: AppSizes.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoChip(
                  context, 'Daily Avg', CurrencyFormatter.format(dailyAvg)),
              _infoChip(context, 'Daily Allowance',
                  CurrencyFormatter.format(dailyAllowance)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(label,
            style: AppTextStyles.labelSmall(context,
                color: AppColors.onSurfaceMuted)),
        const SizedBox(height: 2),
        Text(value,
            style: AppTextStyles.bodyMedium(context)
                .copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
