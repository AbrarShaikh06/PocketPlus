import 'package:flutter/material.dart';

import 'package:pocket_plus/core/constants/app_colors.dart';
import 'package:pocket_plus/core/constants/app_sizes.dart';
import 'package:pocket_plus/core/constants/app_text_styles.dart';
import 'package:pocket_plus/core/utils/currency_formatter.dart';
import 'package:pocket_plus/shared/widgets/app_card.dart';
import 'package:pocket_plus/features/budgets/domain/budget_calculator.dart';
import 'package:pocket_plus/features/budgets/domain/entities/budget.dart';

class BudgetForecastCard extends StatelessWidget {
  const BudgetForecastCard({required this.budget, super.key});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final calculator = BudgetCalculator();
    final forecast = calculator.computeForecast(budget);
    final exceeds = forecast > budget.amount;
    final variance = (forecast - budget.amount).abs();

    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                exceeds ? Icons.trending_up : Icons.trending_down,
                color: exceeds ? AppColors.error : AppColors.income,
                size: 20,
              ),
              const SizedBox(width: AppSizes.spacing8),
              Text('Forecast', style: AppTextStyles.titleMedium(context)),
            ],
          ),
          const SizedBox(height: AppSizes.spacing8),
          Text(
            'Projected spend: ${CurrencyFormatter.format(forecast)}',
            style: AppTextStyles.bodyLarge(context)
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSizes.spacing4),
          Text(
            exceeds
                ? 'Likely to exceed by ${CurrencyFormatter.format(variance)}'
                : 'On track to save ${CurrencyFormatter.format(variance)}',
            style: AppTextStyles.bodyMedium(
              context,
              color: exceeds ? AppColors.error : AppColors.income,
            ),
          ),
        ],
      ),
    );
  }
}
