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

class BusinessNameScreen extends ConsumerStatefulWidget {
  const BusinessNameScreen({super.key});

  @override
  ConsumerState<BusinessNameScreen> createState() => _BusinessNameScreenState();
}

class _BusinessNameScreenState extends ConsumerState<BusinessNameScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final currentName = ref.read(onboardingViewModelProvider).businessName;
    _controller = TextEditingController(text: currentName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);
    final viewModel = ref.read(onboardingViewModelProvider.notifier);

    final isCa = state.role == 'CA';
    final title = isCa ? 'Enter Practice Name' : "What's your business name?";
    final subtitle = isCa
        ? 'Let us know the name of your CA firm or practice.'
        : 'This helps us personalize your ledger.';

    final inputLength = state.businessName.trim().length;
    final showValidationError =
        state.businessName.isNotEmpty && (inputLength < 2 || inputLength > 200);

    final errorText = showValidationError
        ? 'Name must be between 2 and 200 characters.'
        : null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ProgressDots(currentStep: 2),
                    const SizedBox(height: AppSizes.spacing16),
                    // Header / Logo Area
                    Center(
                      child: Text(
                        'PocketPlus',
                        style: AppTextStyles.displayLarge(context).copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing24),
                    // Illustration Container
                    Center(
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxHeight: 240),
                        padding: const EdgeInsets.all(AppSizes.spacing24),
                        decoration: BoxDecoration(
                          color: AppColors.outline.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppSizes.radius24),
                        ),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Image.network(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBh3x1RNMcpziTJI5CG67f4TCUIv3alp2Mr1hKrlVH5lKDkkbouOQ8oupW1PmHIh06Y-GhUMnVxXmYos9XbZuGFY1IjnTwBRTZ8oWzlayv1yxLoXDpS0EsL8q7Y_wMnT96-H2IUrNChK32wAZhSqSy11imFLJMNnCzxdUm9GdzR8lk4Cy6C3XXAX_UPojyXhG0xofGO_cu2x_dtnG96DLbhWAyUffHEbhKZC62XmieI5gYZwgD8Ka53oIc20zlNTCJ0HxZACC4b3nk',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.storefront,
                                size: 100,
                                color: AppColors.primary,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing24),
                    // Form Area Text
                    Text(
                      title,
                      style: AppTextStyles.titleLarge(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spacing8),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.onSurfaceMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSizes.spacing24),
                    // Text Input field
                    AppTextField(
                      controller: _controller,
                      label: isCa ? 'Practice / Firm Name' : 'Business Name',
                      hint: isCa
                          ? 'e.g. Verma & Associates'
                          : 'e.g. Sharma General Store',
                      errorText: errorText,
                      maxLength: 200,
                      onChanged: viewModel.updateBusinessName,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Sticky Action Area
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing24,
                vertical: AppSizes.spacing16,
              ),
              child: AppButton(
                label: 'Next',
                onPressed: viewModel.isNameValid()
                    ? () => context.push(RouteNames.onboardingSms)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
