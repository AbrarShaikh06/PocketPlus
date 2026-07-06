import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/widgets/widgets.dart';
import 'onboarding_view_model.dart';
import 'widgets/progress_dots.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingViewModelProvider);
    final viewModel = ref.read(onboardingViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSizes.spacing24),
              const ProgressDots(currentStep: 1),
              const SizedBox(height: AppSizes.spacing32),
              Text(
                'Choose Your Role',
                style: AppTextStyles.displayLarge(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacing8),
              Text(
                'Select the type of account that matches your financial tracking needs.',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: AppColors.onSurfaceMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacing32),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildRoleCard(
                      context: context,
                      roleValue: 'PERSONAL',
                      title: 'Personal Ledger',
                      description:
                          'Track personal cash flows, daily expenses, and individual savings.',
                      icon: Icons.account_balance_wallet_outlined,
                      selectedRole: state.role,
                      onTap: () => viewModel.selectRole('PERSONAL'),
                    ),
                    const SizedBox(height: AppSizes.spacing16),
                    _buildRoleCard(
                      context: context,
                      roleValue: 'BUSINESS',
                      title: 'Business Owner',
                      description:
                          'Manage shop transactions, khata udhaar ledger, invoice generation, and real-time books.',
                      icon: Icons.storefront_outlined,
                      selectedRole: state.role,
                      onTap: () => viewModel.selectRole('BUSINESS'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.spacing16),
              AppButton(
                label: 'Next',
                onPressed: state.role != null
                    ? () => context.push(RouteNames.onboardingInfo)
                    : null,
              ),
              const SizedBox(height: AppSizes.spacing24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String roleValue,
    required String title,
    required String description,
    required IconData icon,
    required String? selectedRole,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedRole == roleValue;

    return PressableScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(AppSizes.spacing16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.spacing12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSizes.spacing8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color:
                    isSelected ? AppColors.primary : AppColors.onSurfaceMuted,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSizes.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium(context).copyWith(
                      color:
                          isSelected ? AppColors.primary : AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing4),
                  Text(
                    description,
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: AppColors.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
