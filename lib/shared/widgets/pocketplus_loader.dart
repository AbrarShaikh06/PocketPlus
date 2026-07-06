import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Custom PocketPlus animated loader.
/// Animated trending_up icon with stroke draw animation and green pulse.
class PocketPlusLoader extends StatefulWidget {
  const PocketPlusLoader({
    super.key,
    this.size = 64,
    this.color,
  });

  final double size;

  /// Defaults to [AppColors.primary] when null.
  final Color? color;

  @override
  State<PocketPlusLoader> createState() => _PocketPlusLoaderState();
}

class _PocketPlusLoaderState extends State<PocketPlusLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _drawProgress;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _drawProgress = _controller.drive(
      Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Curves.easeInOut),
      ),
    );

    _pulseAnim = _controller.drive(
      Tween<double>(begin: 0.6, end: 1.0).chain(
        CurveTween(curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disable = MediaQuery.disableAnimationsOf(context);

    if (disable) {
      return Icon(
        Icons.trending_up,
        size: widget.size,
        color: widget.color ?? AppColors.primary,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _TrendingUpPainter(
            progress: _drawProgress.value,
            color: (widget.color ?? AppColors.primary)
                .withValues(alpha: _pulseAnim.value),
          ),
        );
      },
    );
  }
}

class _TrendingUpPainter extends CustomPainter {
  _TrendingUpPainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final half = size.width / 2;
    final quarter = size.width / 4;

    final path = Path();
    // Draw a trending_up arrow shape
    path.moveTo(quarter * 0.5, size.height * 0.7);
    path.lineTo(half - quarter * 0.3, size.height * 0.5);
    path.lineTo(half, size.height * 0.65);
    path.lineTo(half + quarter * 0.5, size.height * 0.3);

    // Arrow head
    path.moveTo(half + quarter * 0.5 - 8, size.height * 0.3 + 6);
    path.lineTo(half + quarter * 0.5, size.height * 0.3);
    path.lineTo(half + quarter * 0.5 - 6, size.height * 0.3 - 4);

    final metrics = path.computeMetrics();
    double totalLength = 0;
    for (final m in metrics) {
      totalLength += m.length;
    }

    final extractPath = Path();
    double accumulated = 0;
    for (final m in metrics) {
      final extractLength = m.length * progress;
      extractPath.addPath(
        m.extractPath(0, extractLength < m.length ? extractLength : m.length),
        Offset.zero,
      );
      accumulated += m.length;
      if (accumulated >= totalLength * progress) break;
    }

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(covariant _TrendingUpPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
