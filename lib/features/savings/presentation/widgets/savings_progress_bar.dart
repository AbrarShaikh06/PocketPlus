import 'dart:math' show sin, pi;

import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// Animated progress bar with liquid-like fill and glow at >80%.
class SavingsProgressBar extends StatefulWidget {
  const SavingsProgressBar({
    required this.savedAmount,
    required this.targetAmount,
    super.key,
  });

  final int savedAmount;
  final int targetAmount;

  @override
  State<SavingsProgressBar> createState() => _SavingsProgressBarState();
}

class _SavingsProgressBarState extends State<SavingsProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _liquidController;

  @override
  void initState() {
    super.initState();
    _liquidController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _liquidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double percentage = widget.targetAmount > 0
        ? (widget.savedAmount / widget.targetAmount).clamp(0.0, 1.0)
        : 0.0;

    final bool nearGoal = percentage > 0.80 && percentage < 1.0;
    final bool achieved = percentage >= 1.0;
    final color = achieved
        ? AppColors.income
        : nearGoal
            ? AppColors.orange
            : AppColors.primary;

    final disable = MediaQuery.disableAnimationsOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 12,
            color: AppColors.outline.withValues(alpha: 0.2),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: percentage),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Stack(
                  children: [
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: value,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: nearGoal || achieved
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                    if (nearGoal && !disable && value > 0)
                      AnimatedBuilder(
                        animation: _liquidController,
                        builder: (context, child) {
                          return Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: _LiquidWavePainter(
                                  progress: value,
                                  waveOffset: _liquidController.value * 2 * pi,
                                  color: color.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _LiquidWavePainter extends CustomPainter {
  _LiquidWavePainter({
    required this.progress,
    required this.waveOffset,
    required this.color,
  });

  final double progress;
  final double waveOffset;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final fillWidth = size.width * progress;
    if (fillWidth <= 0) return;

    final path = Path();
    path.moveTo(0, size.height);

    const waveCount = 3;
    final waveLength = fillWidth / waveCount;

    for (double x = 0; x <= fillWidth; x += 1) {
      final y = size.height + sin((x / waveLength + waveOffset) * 2 * pi) * 2;
      if (x == 0) {
        path.lineTo(x, y);
      }
      path.lineTo(x, y);
    }

    path.lineTo(fillWidth, size.height);
    path.close();

    canvas.clipRect(Rect.fromLTWH(0, 0, fillWidth, size.height));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _LiquidWavePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.waveOffset != waveOffset;
}
