import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import 'pressable_scale.dart';

enum AppButtonVariant { primary, outline, text }

/// Full-width button with primary, outline, and text variants.
///
/// States: default, pressed (scale 0.96, ease-out settle), loading (3 dots),
/// success (checkmark morph), disabled, error.
class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.semanticsLabel,
    this.icon,
    this.iconWidget,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final String? semanticsLabel;
  final IconData? icon;
  final Widget? iconWidget;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with TickerProviderStateMixin {
  late AnimationController _dotsController;
  late AnimationController _successController;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(AppButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _dotsController.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _dotsController.stop();
      _dotsController.reset();
    }
    if (widget.isSuccess && !oldWidget.isSuccess) {
      _successController.forward();
    } else if (!widget.isSuccess && oldWidget.isSuccess) {
      _successController.reset();
    }
  }

  @override
  void dispose() {
    _dotsController.dispose();
    _successController.dispose();
    super.dispose();
  }

  bool get _isDisabled => widget.onPressed == null || widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final child = _buildContent(context);

    if (_isDisabled && !widget.isLoading) {
      return Semantics(
        label: widget.semanticsLabel ?? widget.label,
        button: true,
        enabled: false,
        child: Opacity(
          opacity: 0.5,
          child: IgnorePointer(child: child),
        ),
      );
    }

    if (widget.isLoading) {
      return Semantics(
        label: widget.semanticsLabel ?? widget.label,
        button: true,
        enabled: false,
        liveRegion: true,
        value: 'Loading',
        child: IgnorePointer(child: child),
      );
    }

    return Semantics(
      label: widget.semanticsLabel ?? widget.label,
      button: true,
      enabled: !_isDisabled,
      child: child,
    );
  }

  Widget _buildContent(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.minTouchTarget,
      child: PressableScale(
        enabled: !_isDisabled,
        onTap: _isDisabled ? null : widget.onPressed,
        pressedScale: 0.96,
        duration: const Duration(milliseconds: 80),
        child: _buildButtonSurface(context),
      ),
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(right: index < 2 ? 6 : 0),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _indicatorColor(),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildSuccessIcon() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.check, size: 16, color: AppColors.primary),
    );
  }

  Widget _buildButtonSurface(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppSizes.spacing8);
    final labelStyle = AppTextStyles.labelLarge(
      context,
      color: _labelColor(),
    );

    Widget inner = Center(
      child: widget.isLoading
          ? _buildLoadingDots()
          : widget.isSuccess
              ? _buildSuccessIcon()
              : widget.icon != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(widget.icon, size: 20, color: _labelColor()),
                        const SizedBox(width: AppSizes.spacing8),
                        Text(widget.label, style: labelStyle),
                      ],
                    )
                  : widget.iconWidget != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.iconWidget!,
                            const SizedBox(width: AppSizes.spacing8),
                            Text(widget.label, style: labelStyle),
                          ],
                        )
                      : Text(widget.label, style: labelStyle),
    );

    switch (widget.variant) {
      case AppButtonVariant.primary:
        return DecoratedBox(
          decoration: BoxDecoration(
            color: widget.isError
                ? AppColors.error
                : widget.isSuccess
                    ? AppColors.income
                    : AppColors.primary,
            borderRadius: borderRadius,
            border: widget.isError
                ? Border.all(color: AppColors.error, width: 2)
                : null,
          ),
          child: inner,
        );
      case AppButtonVariant.outline:
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: borderRadius,
            border: Border.all(
              color: widget.isError ? AppColors.error : AppColors.primary,
              width: widget.isError ? 2 : 1.5,
            ),
          ),
          child: inner,
        );
      case AppButtonVariant.text:
        return inner;
    }
  }

  Color _labelColor() {
    if (widget.isError) return AppColors.error;
    if (widget.isSuccess) return AppColors.income;
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColors.onPrimary;
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return AppColors.primary;
    }
  }

  Color _indicatorColor() {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColors.onPrimary;
      case AppButtonVariant.outline:
      case AppButtonVariant.text:
        return AppColors.primary;
    }
  }
}
