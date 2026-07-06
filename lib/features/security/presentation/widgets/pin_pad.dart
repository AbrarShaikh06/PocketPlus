import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Row of filled/empty dots showing how many PIN digits have been entered.
class PinDots extends StatelessWidget {
  const PinDots({
    required this.length,
    required this.filled,
    this.hasError = false,
    super.key,
  });

  final int length;
  final int filled;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final active = hasError ? AppColors.error : AppColors.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < length; i++)
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: AppSizes.spacing8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < filled ? active : Colors.transparent,
              border: Border.all(color: active, width: 1.6),
            ),
          ),
      ],
    );
  }
}

/// Numeric keypad (0–9, optional biometric key, backspace).
class PinPad extends StatelessWidget {
  const PinPad({
    required this.onDigit,
    required this.onBackspace,
    this.onBiometric,
    super.key,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  /// When non-null, a fingerprint key is shown in the bottom-left slot.
  final VoidCallback? onBiometric;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.6,
      children: [
        for (var n = 1; n <= 9; n++) _DigitKey(digit: '$n', onTap: onDigit),
        // Bottom row: biometric (or empty), 0, backspace.
        if (onBiometric != null)
          _IconKey(
            icon: Icons.fingerprint,
            tooltip: 'Unlock with biometrics',
            onTap: onBiometric!,
          )
        else
          const SizedBox.shrink(),
        _DigitKey(digit: '0', onTap: onDigit),
        _IconKey(
          icon: Icons.backspace_outlined,
          tooltip: 'Delete',
          onTap: onBackspace,
        ),
      ],
    );
  }
}

class _DigitKey extends StatelessWidget {
  const _DigitKey({required this.digit, required this.onTap});

  final String digit;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: 40,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap(digit);
      },
      child: Center(
        child: Text(
          digit,
          style: AppTextStyles.titleLarge(context)
              .copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _IconKey extends StatelessWidget {
  const _IconKey({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      radius: 40,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Tooltip(
        message: tooltip,
        child: Icon(icon, color: AppColors.primary, size: 26),
      ),
    );
  }
}
