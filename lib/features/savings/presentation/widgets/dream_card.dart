import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../domain/savings_goal.dart';
import 'savings_progress_bar.dart';

class DreamCard extends StatelessWidget {
  const DreamCard({
    required this.goal,
    required this.onAddMoney,
    super.key,
  });

  final SavingsGoal goal;
  final VoidCallback onAddMoney;

  IconData _getCategoryIcon(SavingsCategory category) {
    switch (category) {
      case SavingsCategory.CAR:
        return Icons.local_shipping;
      case SavingsCategory.HOUSE:
        return Icons.home;
      case SavingsCategory.EDUCATION:
        return Icons.school;
      case SavingsCategory.BUSINESS:
        return Icons.storefront;
      case SavingsCategory.TRAVEL:
        return Icons.flight;
      case SavingsCategory.OTHER:
        return Icons.savings;
    }
  }

  Color _getCategoryColor(SavingsCategory category) {
    switch (category) {
      case SavingsCategory.BUSINESS:
        return AppColors.primary;
      case SavingsCategory.CAR:
        return AppColors.secondary;
      case SavingsCategory.EDUCATION:
        return AppColors.orange;
      case SavingsCategory.HOUSE:
        return AppColors.blue;
      case SavingsCategory.TRAVEL:
        return AppColors.secondary;
      case SavingsCategory.OTHER:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double percentage = goal.targetAmount > 0
        ? (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0)
        : 0.0;

    // Format percentage nicely: show decimals only if not whole number
    final double percentVal = percentage * 100;
    final String percentText = percentVal % 1 == 0
        ? percentVal.toInt().toString()
        : percentVal.toStringAsFixed(1);

    final color = _getCategoryColor(goal.category);
    final icon = _getCategoryIcon(goal.category);

    return InkWell(
      onTap: () => context.push(RouteNames.savingsDetail(goal.id)),
      borderRadius: BorderRadius.circular(AppSizes.radius12),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.radius12),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row 1: Icon, Title, and Target/Percentage Info
            Row(
              children: [
                // Category Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radius8),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: AppSizes.spacing12),

                // Title and Target Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.name,
                        style: AppTextStyles.bodyLarge(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Target: ${CurrencyFormatter.formatRupees(goal.targetAmount)}',
                        style: AppTextStyles.labelSmall(
                          context,
                          color: AppColors.onSurfaceMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSizes.spacing8),

                // Percentage and Complete Label
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$percentText%',
                      style: AppTextStyles.bodyLarge(context).copyWith(
                        color: percentage > 0.90
                            ? AppColors.orange
                            : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Complete',
                      style: AppTextStyles.labelSmall(
                        context,
                        color: AppColors.onSurfaceMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing16),

            // Progress Bar
            SavingsProgressBar(
              savedAmount: goal.savedAmount,
              targetAmount: goal.targetAmount,
            ),
            const SizedBox(height: AppSizes.spacing12),

            // Saved / Left values
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${CurrencyFormatter.formatRupees(goal.savedAmount)} saved',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  '${CurrencyFormatter.formatRupees(goal.targetAmount - goal.savedAmount)} left',
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
              ],
            ),

            // Add money button or achieved badge
            if (!goal.isAchieved) ...[
              const SizedBox(height: AppSizes.spacing16),
              AppButton(
                label: 'Add Money Today',
                variant: AppButtonVariant.outline,
                onPressed: onAddMoney,
              ),
            ] else ...[
              const SizedBox(height: AppSizes.spacing16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    'Goal Achieved! 🎉',
                    style: AppTextStyles.labelLarge(context).copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
