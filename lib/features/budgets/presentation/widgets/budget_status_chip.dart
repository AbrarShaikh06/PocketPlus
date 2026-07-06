import 'package:flutter/material.dart';

import 'package:pocket_plus/core/constants/app_colors.dart';
import 'package:pocket_plus/core/constants/app_sizes.dart';
import 'package:pocket_plus/core/constants/app_text_styles.dart';
import 'package:pocket_plus/features/budgets/domain/budget_calculator.dart';
import 'package:pocket_plus/features/budgets/domain/entities/budget.dart';

class BudgetStatusChip extends StatelessWidget {
  const BudgetStatusChip({required this.budget, super.key});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final calculator = BudgetCalculator();
    final status = calculator.computeStatus(budget);
    final percentage = calculator.computePercentage(budget);
    final (label, color, icon) = switch (status) {
      BudgetStatus.safe => ('Safe', AppColors.income, Icons.check_circle),
      BudgetStatus.warning => (
          'Warning',
          AppColors.orange,
          Icons.warning_amber_rounded
        ),
      BudgetStatus.critical => (
          'Critical',
          AppColors.warning,
          Icons.error_outline
        ),
      BudgetStatus.exceeded => ('Exceeded', AppColors.error, Icons.gpp_bad),
    };

    final displayLabel = status == BudgetStatus.exceeded
        ? 'Exceeded by ${(percentage - 100)}%'
        : '$label · $percentage%';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing8,
        vertical: AppSizes.spacing4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.spacing20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            displayLabel,
            style: AppTextStyles.labelSmall(context, color: color),
          ),
        ],
      ),
    );
  }
}
