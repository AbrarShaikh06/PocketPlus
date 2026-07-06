import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import 'app_button.dart';

/// Empty list/content placeholder with illustration, message, and optional CTA.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.message,
    super.key,
    this.illustration,
    this.ctaLabel,
    this.onCtaPressed,
    this.semanticsLabel,
  });

  final Widget? illustration;
  final String message;
  final String? ctaLabel;
  final VoidCallback? onCtaPressed;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? message,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (illustration != null) ...[
              illustration!,
              const SizedBox(height: AppSizes.spacing24),
            ],
            Text(
              message,
              style: AppTextStyles.titleMedium(
                context,
                color: AppColors.onSurfaceMuted,
              ),
              textAlign: TextAlign.center,
            ),
            if (ctaLabel != null && onCtaPressed != null) ...[
              const SizedBox(height: AppSizes.spacing24),
              AppButton(
                label: ctaLabel!,
                onPressed: onCtaPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
