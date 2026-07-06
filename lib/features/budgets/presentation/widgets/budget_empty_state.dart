import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:pocket_plus/core/constants/app_colors.dart';
import 'package:pocket_plus/core/constants/app_sizes.dart';
import 'package:pocket_plus/core/constants/app_text_styles.dart';
import 'package:pocket_plus/core/router/route_names.dart';
import 'package:pocket_plus/shared/widgets/app_button.dart';

class BudgetEmptyState extends StatelessWidget {
  const BudgetEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppSizes.spacing24),
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 60,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSizes.spacing24),
            Text(
              'No budgets yet',
              style: AppTextStyles.titleMedium(context),
            ),
            const SizedBox(height: AppSizes.spacing8),
            Text(
              'Create your first budget to start tracking your spending and saving more.',
              style: AppTextStyles.bodyMedium(context,
                  color: AppColors.onSurfaceMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacing24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: AppButton(
                label: 'Create Your First Budget',
                onPressed: () => context.push(RouteNames.budgetsNew),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
