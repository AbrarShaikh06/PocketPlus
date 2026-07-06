import 'package:flutter/material.dart';

import 'package:pocket_plus/core/constants/app_colors.dart';
import 'package:pocket_plus/core/constants/app_sizes.dart';
import 'package:pocket_plus/features/budgets/domain/budget_calculator.dart';
import 'package:pocket_plus/features/budgets/domain/entities/budget.dart';

class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({
    required this.budget,
    super.key,
    this.height = 12,
    this.showPercentage = true,
  });

  final Budget budget;
  final double height;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    final calculator = BudgetCalculator();
    final percentage = calculator.computePercentage(budget);
    final status = calculator.computeStatus(budget);
    final color = _colorForStatus(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spacing4),
            child: Text(
              '$percentage%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: percentage / 100.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value.clamp(0.0, 1.0),
                backgroundColor: AppColors.outline.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: height,
                borderRadius: BorderRadius.circular(height / 2),
              );
            },
          ),
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
}
