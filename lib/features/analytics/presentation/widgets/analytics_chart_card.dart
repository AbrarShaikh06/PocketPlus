import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../models/analytics_data.dart';
import 'analytics_area_chart.dart';
import 'analytics_footer.dart';

/// A premium, reusable analytics card: header, stacked-looking area chart and a
/// trend footer, designed to read well on a dark surface.
///
/// Colours follow the app theme. By default the three series are derived from a
/// documented blue ramp (primary / secondary / light blue); pass [seriesColors]
/// to drive them from `Theme.of(context).colorScheme` instead. Foreground text
/// adapts to the resolved [backgroundColor]'s luminance, so the same widget
/// works on dark and light surfaces without changes.
class AnalyticsChartCard extends StatelessWidget {
  const AnalyticsChartCard({
    required this.title,
    required this.subtitle,
    required this.data,
    super.key,
    this.showGrid = true,
    this.showFooter = true,
    this.showTooltip = true,
    this.animate = true,
    this.trendPercentage = 0,
    this.dateRange = '',
    this.seriesColors,
    this.backgroundColor,
    this.chartHeight = 230,
  });

  final String title;
  final String subtitle;
  final List<AnalyticsData> data;

  final bool showGrid;
  final bool showFooter;
  final bool showTooltip;
  final bool animate;

  final double trendPercentage;
  final String dateRange;

  /// Optional `[bottom, middle, top]` series colours. Defaults to [_blueRamp].
  final List<Color>? seriesColors;

  /// Optional card surface colour. Defaults to a premium dark surface.
  final Color? backgroundColor;

  final double chartHeight;

  static const double _radius = 20;

  /// Documented default ramp — primary / secondary / light blue.
  static const List<Color> _blueRamp = [
    Color(0xFF3B82F6), // bottom — primary blue
    Color(0xFF60A5FA), // middle — secondary blue
    Color(0xFF93C5FD), // top    — light blue
  ];

  static const Color _defaultDarkSurface = Color(0xFF0F1115);
  static const Color _trendUp = Color(0xFF22C55E);
  static const Color _trendDown = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final surface = backgroundColor ?? _defaultDarkSurface;
    final onSurface = surface.computeLuminance() > 0.5
        ? const Color(0xFF111317)
        : Colors.white;
    final muted = onSurface.withValues(alpha: 0.6);
    final series = seriesColors ?? _blueRamp;

    return Semantics(
      container: true,
      label: '$title. $subtitle',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.spacing20),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(_radius),
          border: Border.all(color: onSurface.withValues(alpha: 0.08)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Text(
              title,
              style: TextStyle(
                color: onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: AppSizes.spacing4),
            Text(
              subtitle,
              style: TextStyle(
                color: muted,
                fontSize: 13.5,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: AppSizes.spacing20),

            // ── Chart ──────────────────────────────────────────────────────
            AnalyticsAreaChart(
              data: data,
              seriesColors: series,
              gridColor: onSurface.withValues(alpha: 0.10),
              labelColor: muted,
              tooltipColor: surface.computeLuminance() > 0.5
                  ? const Color(0xFF1F2430)
                  : const Color(0xFF1B1F27),
              tooltipTextColor: Colors.white,
              showGrid: showGrid,
              showTooltip: showTooltip,
              animate: animate,
              height: chartHeight,
            ),

            // ── Footer ─────────────────────────────────────────────────────
            if (showFooter) ...[
              const SizedBox(height: AppSizes.spacing20),
              AnalyticsFooter(
                trendPercentage: trendPercentage,
                dateRange: dateRange,
                trendUpColor: _trendUp,
                trendDownColor: _trendDown,
                mutedColor: muted,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
