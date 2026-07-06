import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';

/// Text field with validation error display announced via TalkBack.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.maxLength,
    this.inputFormatters,
    this.textInputAction,
    this.autofillHints,
    this.semanticsLabel,
    this.prefixIcon,
    this.suffixIcon,
    this.onEditingComplete,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? semanticsLabel;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onEditingComplete;

  bool get _hasError => errorText != null && errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          label: semanticsLabel ?? label,
          textField: true,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            onEditingComplete: onEditingComplete,
            keyboardType: keyboardType,
            obscureText: obscureText,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            textInputAction: textInputAction,
            autofillHints: autofillHints,
            style: AppTextStyles.bodyLarge(context),
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              labelStyle: AppTextStyles.bodyMedium(
                context,
                color: AppColors.onSurfaceMuted,
              ),
              hintStyle: AppTextStyles.bodyMedium(
                context,
                color: AppColors.onSurfaceMuted,
              ),
              filled: true,
              fillColor: AppColors.card,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing16,
                vertical: AppSizes.spacing12,
              ),
              constraints: const BoxConstraints(
                minHeight: AppSizes.minTouchTarget,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.spacing8),
                borderSide: const BorderSide(color: AppColors.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.spacing8),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.spacing8),
                borderSide: const BorderSide(color: AppColors.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSizes.spacing8),
                borderSide: const BorderSide(
                  color: AppColors.error,
                  width: 2,
                ),
              ),
              errorText: _hasError ? ' ' : null,
              errorStyle: const TextStyle(fontSize: 0, height: 0),
            ),
          ),
        ),
        if (_hasError)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSizes.spacing4,
              left: AppSizes.spacing12,
            ),
            child: Semantics(
              liveRegion: true,
              label: errorText,
              child: Text(
                errorText!,
                style: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
