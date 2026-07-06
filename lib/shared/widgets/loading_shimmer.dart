import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// Skeleton placeholder with 1200ms repeating linear shimmer (Eng Spec B1.5).
/// Enhanced with subtle scale pulse alongside shimmer.
class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({
    super.key,
    this.width,
    this.height = AppSizes.spacing16,
    this.borderRadius,
  });

  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  /// Pre-built shimmer matching a list tile layout.
  factory LoadingShimmer.listTile() {
    return const LoadingShimmer(
      height: AppSizes.spacing48,
      borderRadius: BorderRadius.all(Radius.circular(AppSizes.spacing8)),
    );
  }

  /// Pre-built shimmer matching a card layout.
  factory LoadingShimmer.card({double height = 120}) {
    return LoadingShimmer(
      height: height,
      borderRadius: const BorderRadius.all(Radius.circular(AppSizes.spacing12)),
    );
  }

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = _pulseController.drive(
      Tween<double>(begin: 1.0, end: 1.03).chain(
        CurveTween(curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final radius = widget.borderRadius ??
        const BorderRadius.all(Radius.circular(AppSizes.spacing4));

    final placeholder = Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.outline.withValues(alpha: 0.3),
        borderRadius: radius,
      ),
    );

    Widget inner;
    if (disableAnimations) {
      inner = placeholder;
    } else {
      inner = Shimmer.fromColors(
        baseColor: AppColors.outline.withValues(alpha: 0.25),
        highlightColor: AppColors.card,
        period: const Duration(milliseconds: 1200),
        direction: ShimmerDirection.ltr,
        child: placeholder,
      );
    }

    if (disableAnimations) return inner;

    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, child) {
        return Transform.scale(scale: _pulseAnim.value, child: child);
      },
      child: inner,
    );
  }
}

/// Vertical list of shimmer placeholders for skeleton loading states.
class LoadingShimmerList extends StatelessWidget {
  const LoadingShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = AppSizes.spacing48,
    this.spacing = AppSizes.spacing12,
  });

  final int itemCount;
  final double itemHeight;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index < itemCount - 1 ? spacing : 0),
          child: LoadingShimmer(
            height: itemHeight,
            borderRadius:
                const BorderRadius.all(Radius.circular(AppSizes.spacing8)),
          ),
        );
      }),
    );
  }
}
