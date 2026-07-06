import 'dart:math';
import 'package:flutter/material.dart';

import 'package:pocket_plus/core/constants/app_colors.dart';
import 'package:pocket_plus/core/utils/currency_formatter.dart';
import 'package:pocket_plus/features/budgets/domain/budget_calculator.dart';
import 'package:pocket_plus/features/budgets/domain/entities/budget.dart';

class CircularBudgetIndicator extends StatelessWidget {
  const CircularBudgetIndicator({
    required this.budget,
    super.key,
    this.size = 100,
    this.strokeWidth = 8,
  });

  final Budget budget;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final calculator = BudgetCalculator();
    final percentage = calculator.computePercentage(budget);
    final status = calculator.computeStatus(budget);
    final color = _colorForStatus(status);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CircularProgressPainter(
          percentage: percentage / 100.0,
          color: color,
          backgroundColor: AppColors.outline.withValues(alpha: 0.2),
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              Text(
                CurrencyFormatter.format(budget.spentAmount, symbol: ''),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceMuted,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _colorForStatus(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe:
        return AppColors.income;
      case BudgetStatus.warning:
        return AppColors.orange;
      case BudgetStatus.critical:
        return AppColors.warning;
      case BudgetStatus.exceeded:
        return AppColors.error;
    }
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.percentage,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  final double percentage;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final sweepAngle = (percentage * 2 * pi).clamp(0, 2 * pi).toDouble();
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter old) =>
      old.percentage != percentage || old.color != color;
}
