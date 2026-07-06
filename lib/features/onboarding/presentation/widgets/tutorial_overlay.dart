import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pocket_plus/l10n/app_localizations.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../data/tutorial_steps_provider.dart';
import '../tutorial_controller.dart';

/// In-widget onboarding tutorial overlay.
///
/// Renders directly in the widget tree (as opposed to an `Overlay` entry) so
/// it stays driven by [tutorialControllerProvider] and is easy to drive from
/// widget tests. Place it as the last child of a [Stack] over a screen body.
///
/// Shows nothing unless a tutorial is active. While active it dims the screen
/// and presents a card with the current step's title/description plus
/// Skip / Next / Finish controls.
class TutorialOverlay extends ConsumerWidget {
  const TutorialOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tutorialControllerProvider);
    final role = state.role;
    if (!state.isActive || role == null) {
      return const SizedBox.shrink();
    }

    final steps = ref.watch(tutorialStepsProvider(role));
    if (state.currentStep < 1 || state.currentStep > steps.length) {
      return const SizedBox.shrink();
    }

    final step = steps[state.currentStep - 1];
    final isLastStep = state.currentStep >= state.totalSteps;
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(tutorialControllerProvider.notifier);

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.55),
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.spacing16),
              child: Container(
                padding: const EdgeInsets.all(AppSizes.spacing20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outline.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.tutorialStepCounter(
                            step.stepNumber.toString(),
                            state.totalSteps.toString(),
                          ),
                          style: AppTextStyles.labelSmall(context).copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: controller.skip,
                          child: Text(
                            l10n.skip,
                            style: AppTextStyles.labelSmall(context).copyWith(
                              color: AppColors.onSurfaceMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.spacing8),
                    Text(
                      step.title,
                      style: AppTextStyles.titleMedium(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing8),
                    Text(
                      step.description,
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.onSurfaceMuted,
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (isLastStep) {
                              controller.complete(role);
                            } else {
                              controller.nextStep();
                            }
                          },
                          child: Text(isLastStep ? l10n.finish : l10n.next),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
