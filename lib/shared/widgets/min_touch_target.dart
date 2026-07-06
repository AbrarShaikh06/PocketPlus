import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';

/// Ensures interactive elements meet the 48×48dp minimum touch target (WCAG).
class MinTouchTarget extends StatelessWidget {
  const MinTouchTarget({
    required this.child,
    super.key,
    this.semanticsLabel,
    this.onTap,
  });

  final Widget child;
  final String? semanticsLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget content = ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: AppSizes.minTouchTarget,
        minHeight: AppSizes.minTouchTarget,
      ),
      child: Center(child: child),
    );

    if (semanticsLabel != null) {
      content = Semantics(
        label: semanticsLabel,
        button: onTap != null,
        child: content,
      );
    }

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
