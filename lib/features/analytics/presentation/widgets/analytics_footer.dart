import 'package:flutter/material.dart';

/// Footer line for the analytics card: a coloured trend statement above a
/// muted date range, matching the reference design.
class AnalyticsFooter extends StatelessWidget {
  const AnalyticsFooter({
    required this.trendPercentage,
    required this.dateRange,
    required this.trendUpColor,
    required this.trendDownColor,
    required this.mutedColor,
    super.key,
  });

  final double trendPercentage;
  final String dateRange;
  final Color trendUpColor;
  final Color trendDownColor;
  final Color mutedColor;

  @override
  Widget build(BuildContext context) {
    final isUp = trendPercentage >= 0;
    final trendColor = isUp ? trendUpColor : trendDownColor;
    final magnitude = trendPercentage.abs().toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                'Trending ${isUp ? 'up' : 'down'} by $magnitude% this month',
                style: TextStyle(
                  color: trendColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isUp ? Icons.trending_up : Icons.trending_down,
              size: 16,
              color: trendColor,
            ),
          ],
        ),
        if (dateRange.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            dateRange,
            style: TextStyle(
              color: mutedColor,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
