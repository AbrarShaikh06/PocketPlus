import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Card surface with optional tap feedback.
/// Press: scale 1.0 → 0.97, ease-out-quart (single InkWell drives both the
/// ripple and the scale — no competing gesture recognizers).
/// Appear: fade + slide up
class AppCard extends StatefulWidget {
  const AppCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
    this.margin,
    this.semanticsLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final String? semanticsLabel;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> with SingleTickerProviderStateMixin {
  late AnimationController _appearController;
  late Animation<double> _appearOpacity;
  late Animation<Offset> _appearSlide;
  final bool _pressed = true;

  @override
  void initState() {
    super.initState();
    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _appearOpacity = _appearController.drive(
      Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Curves.easeOut),
      ),
    );
    _appearSlide = _appearController.drive(
      Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).chain(
        CurveTween(curve: Curves.easeOut),
      ),
    );
    _appearController.forward();
  }

  @override
  void dispose() {
    _appearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.spacing12),
        border: Border.all(color: AppColors.outline),
      ),
      padding: widget.padding ?? const EdgeInsets.all(AppSizes.spacing16),
      child: widget.child,
    );

    Widget result = card;

    final disableMotion = MediaQuery.disableAnimationsOf(context);

    if (widget.onTap != null) {
      result = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppSizes.spacing12),
          splashColor: AppColors.primary.withValues(alpha: 0.12),
          highlightColor: AppColors.primary.withValues(alpha: 0.06),
          child: AnimatedScale(
            scale: _pressed ? 0.97 : 1.0,
            duration: disableMotion
                ? Duration.zero
                : const Duration(milliseconds: 180),
            curve: Curves.easeOutQuart,
            child: card,
          ),
        ),
      );
    }

    if (widget.semanticsLabel != null) {
      result = Semantics(
        label: widget.semanticsLabel,
        button: widget.onTap != null,
        child: result,
      );
    }

    final disable = MediaQuery.disableAnimationsOf(context);

    if (disable) return result;

    return SlideTransition(
      position: _appearSlide,
      child: FadeTransition(
        opacity: _appearOpacity,
        child: result,
      ),
    );
  }
}
