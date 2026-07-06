import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class ProgressDots extends StatelessWidget {
  const ProgressDots({required this.currentStep, super.key});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final stepNumber = index + 1;
        final isActive = stepNumber == currentStep;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacing4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primary : Colors.transparent,
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.outline,
              width: 2,
            ),
          ),
        );
      }),
    );
  }
}
