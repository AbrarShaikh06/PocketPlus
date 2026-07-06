import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:pocket_plus/core/errors/error_localizer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_names.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../shared/widgets/widgets.dart';
import '../../sms_capture/data/sms_permission_service.dart';
import '../../sms_capture/presentation/sms_permission_provider.dart';
import 'onboarding_view_model.dart';
import 'widgets/progress_dots.dart';

class SmsPermissionScreen extends ConsumerStatefulWidget {
  const SmsPermissionScreen({super.key});

  @override
  ConsumerState<SmsPermissionScreen> createState() =>
      _SmsPermissionScreenState();
}

class _SmsPermissionScreenState extends ConsumerState<SmsPermissionScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);
    final viewModel = ref.read(onboardingViewModelProvider.notifier);
    final smsState = ref.watch(smsPermissionProvider);
    final smsNotifier = ref.read(smsPermissionProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          tooltip: 'Go back',
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProgressDots(currentStep: 3),
              const SizedBox(height: AppSizes.spacing32),
              Text(
                'Auto-Capture Income',
                style: AppTextStyles.displayLarge(context),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacing8),
              Text(
                'Enable SMS processing to automatically log sales and expenses when bank SMS alerts arrive.',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  color: AppColors.onSurfaceMuted,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacing32),

              // Mock Bank SMS simulation card
              _buildMockSmsCard(context),

              const Spacer(),

              if (state.errorCode != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSizes.spacing16),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      localizeError(context, state.errorCode),
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              // Allow SMS button
              if (smsState.hasPermanentlyDenied)
                AppButton(
                  label: 'Enable in Settings',
                  isLoading: state.isLoading,
                  onPressed: () async {
                    final service = ref.read(smsPermissionServiceProvider);
                    await service.openSettings();
                  },
                )
              else
                AppButton(
                  label: 'Allow SMS',
                  isLoading: state.isLoading,
                  onPressed: () async {
                    final status = await smsNotifier.requestPermission();
                    final isGranted = status.isGranted;
                    viewModel.setSmsPermission(isGranted);

                    try {
                      final analytics = ref.read(analyticsServiceProvider);
                      if (isGranted) {
                        await analytics.logSmsPermissionGranted();
                      } else {
                        await analytics.logSmsPermissionDenied();
                      }
                    } catch (e) {
                      debugPrint('Analytics log error: $e');
                    }

                    if (context.mounted) {
                      if (status.isGranted || status.isDenied) {
                        await _completeOnboarding(context, viewModel);
                      }
                    }
                  },
                ),
              const SizedBox(height: AppSizes.spacing12),

              // Skip button
              AppButton(
                label: 'Skip for now',
                variant: AppButtonVariant.text,
                isLoading: state.isLoading,
                onPressed: () async {
                  viewModel.setSmsPermission(false);
                  await _completeOnboarding(context, viewModel);
                },
              ),
              const SizedBox(height: AppSizes.spacing24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding(
    BuildContext context,
    OnboardingViewModel viewModel,
  ) async {
    final success = await viewModel.completeOnboarding();
    if (success && context.mounted) {
      context.go(RouteNames.onboardingDone);
    }
  }

  Widget _buildMockSmsCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.spacing12),
        border: Border.all(color: AppColors.outline),
      ),
      padding: const EdgeInsets.all(AppSizes.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.sms_outlined,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSizes.spacing8),
              Text(
                'Simulated bank message',
                style: AppTextStyles.labelSmall(context),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing12),
          Container(
            padding: const EdgeInsets.all(AppSizes.spacing12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.spacing8),
            ),
            child: Text(
              'Dear Customer, A/c X1234 credited with ₹12,500.00 via UPI Ref: 6192839. - HDFC Bank',
              style: AppTextStyles.bodyMedium(context).copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacing12),
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: AppSizes.spacing8),
              Text(
                'PocketPlus Auto-Logs:',
                style: AppTextStyles.labelLarge(context).copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSizes.spacing8),
              Text(
                'Income of ₹12,500.00',
                style: AppTextStyles.bodyMedium(context).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
