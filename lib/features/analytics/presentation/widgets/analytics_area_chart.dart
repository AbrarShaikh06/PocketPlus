import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/analytics_data.dart';

/// Smooth, stacked-looking area chart built on fl_chart's [LineChart].
///
/// fl_chart has no native stacked-area support, so the stack is *simulated*
/// with cumulative series rendered back-to-front from a common zero baseline:
///
/// * layer 3 (drawn first, behind) — desktop + mobile + other   → lightest
/// * layer 2 (middle)              — desktop + mobile            → mid
/// * layer 1 (drawn last, front)   — desktop                    → strongest
///
/// Each layer fills down to the axis with a semi-transparent vertical gradient,
/// so overlaps blend into the layered look of a true stacked chart.
///
/// On first appearance the lines draw left-to-right by revealing a growing
/// slice of every series in lockstep (see [_revealSpots]).
class AnalyticsAreaChart extends StatefulWidget {
  const AnalyticsAreaChart({
    required this.data,
    required this.seriesColors,
    required this.gridColor,
    required this.labelColor,
    required this.tooltipColor,
    required this.tooltipTextColor,
    super.key,
    this.showGrid = true,
    this.showTooltip = true,
    this.animate = true,
    this.height = 230,
  }) : assert(seriesColors.length == 3, 'Expected exactly 3 series colors');

  final List<AnalyticsData> data;

  /// `[bottom (desktop), middle (mobile), top (other)]`.
  final List<Color> seriesColors;
  final Color gridColor;
  final Color labelColor;
  final Color tooltipColor;
  final Color tooltipTextColor;

  final bool showGrid;
  final bool showTooltip;
  final bool animate;
  final double height;

  /// Fill opacity per layer — bottom is most opaque, top is faintest.
  static const double _bottomOpacity = 0.45;
  static const double _middleOpacity = 0.35;
  static const double _topOpacity = 0.15;

  @override
  State<AnalyticsAreaChart> createState() => _AnalyticsAreaChartState();
}

class _AnalyticsAreaChartState extends State<AnalyticsAreaChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _progress =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Honour the system "reduce motion" setting: jump straight to the end.
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (!widget.animate || reduceMotion) {
      _controller.value = 1;
    } else if (!_controller.isAnimating && _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Cumulative magnitude for [layer] (0 = bottom) at row [i].
  double _cumulative(int i, int layer) {
    final d = widget.data[i];
    return switch (layer) {
      0 => d.desktop,
      1 => d.desktop + d.mobile,
      _ => d.total,
    };
  }

  /// Returns the slice of [full] visible at animation progress [t] (0..1),
  /// linearly interpolating the leading edge so the line grows left-to-right.
  static List<FlSpot> _revealSpots(List<FlSpot> full, double t) {
    if (t >= 1 || full.length < 2) return full;
    final minX = full.first.x;
    final maxX = full.last.x;
    final revealX = minX + (maxX - minX) * t;

    final out = <FlSpot>[];
    for (var i = 0; i < full.length; i++) {
      final s = full[i];
      if (s.x <= revealX) {
        out.add(s);
      } else {
        final prev = full[i - 1];
        final localT = (revealX - prev.x) / (s.x - prev.x);
        out.add(FlSpot(revealX, prev.y + (s.y - prev.y) * localT));
        break;
      }
    }
    return out;
  }

  LineChartBarData _barFor(int layer, double t) {
    final color = widget.seriesColors[layer];
    final fillOpacity = switch (layer) {
      0 => AnalyticsAreaChart._bottomOpacity,
      1 => AnalyticsAreaChart._middleOpacity,
      _ => AnalyticsAreaChart._topOpacity,
    };

    final full = [
      for (var i = 0; i < widget.data.length; i++)
        FlSpot(i.toDouble(), _cumulative(i, layer)),
    ];

    return LineChartBarData(
      spots: _revealSpots(full, t),
      isCurved: true,
      curveSmoothness: 0.32,
      preventCurveOverShooting: true,
      color: color,
      barWidth: 2.5,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: fillOpacity),
            color.withValues(alpha: fillOpacity * 0.08),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return SizedBox(height: widget.height);

    final maxStack = widget.data
        .map((d) => d.total)
        .fold(0.0, (prev, v) => v > prev ? v : prev);
    final maxY = maxStack <= 0 ? 1.0 : maxStack * 1.12;
    final gridInterval = maxY / 4;

    return SizedBox(
      height: widget.height,
      child: AnimatedBuilder(
        animation: _progress,
        builder: (context, _) {
          final t = _progress.value;
          return LineChart(
            LineChartData(
              minX: 0,
              maxX: (widget.data.length - 1).toDouble(),
              minY: 0,
              maxY: maxY,
              clipData: const FlClipData.all(),
              // Layers drawn back-to-front: top (faint) first, bottom last.
              lineBarsData: [
                _barFor(2, t),
                _barFor(1, t),
                _barFor(0, t),
              ],
              gridData: FlGridData(
                show: widget.showGrid,
                drawVerticalLine: false,
                horizontalInterval: gridInterval,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: widget.gridColor,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 28,
                    getTitlesWidget: _bottomTitle,
                  ),
                ),
              ),
              lineTouchData: _touchData(),
            ),
            // Per-frame reveal is driven manually; disable fl_chart's own tween.
            duration: Duration.zero,
          );
        },
      ),
    );
  }

  Widget _bottomTitle(double value, TitleMeta meta) {
    final i = value.round();
    if (i < 0 || i >= widget.data.length) return const SizedBox.shrink();
    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: Text(
        widget.data[i].month,
        style: TextStyle(
          color: widget.labelColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  LineTouchData _touchData() {
    if (!widget.showTooltip) return const LineTouchData(enabled: false);

    return LineTouchData(
      handleBuiltInTouches: true,
      getTouchedSpotIndicator: (barData, indexes) {
        return indexes.map((i) {
          return TouchedSpotIndicatorData(
            FlLine(
              color: widget.gridColor.withValues(alpha: 0.9),
              strokeWidth: 1,
            ),
            FlDotData(
              getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                radius: 3.5,
                color: bar.color ?? widget.seriesColors.first,
                strokeWidth: 2,
                strokeColor: widget.tooltipColor,
              ),
            ),
          );
        }).toList();
      },
      touchTooltipData: LineTouchTooltipData(
        getTooltipColor: (_) => widget.tooltipColor,
        tooltipBorderRadius: BorderRadius.circular(12),
        tooltipPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        tooltipMargin: 12,
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        maxContentWidth: 220,
        getTooltipItems: _tooltipItems,
      ),
    );
  }

  /// One combined tooltip listing all three original (non-cumulative) series.
  List<LineTooltipItem?> _tooltipItems(List<LineBarSpot> touchedSpots) {
    const labels = ['Desktop', 'Mobile', 'Other'];

    return touchedSpots.asMap().entries.map((entry) {
      // Render the full breakdown only once, on the first touched layer.
      if (entry.key != 0) return null;

      final i = entry.value.x.round().clamp(0, widget.data.length - 1);
      final d = widget.data[i];
      final values = [d.desktop, d.mobile, d.other];

      return LineTooltipItem(
        '${d.month}\n',
        TextStyle(
          color: widget.tooltipTextColor,
          fontWeight: FontWeight.w700,
          fontSize: 13,
          height: 1.4,
        ),
        children: [
          for (var s = 0; s < labels.length; s++)
            TextSpan(
              text:
                  '${labels[s]}:  ${_fmt(values[s])}${s == labels.length - 1 ? '' : '\n'}',
              style: TextStyle(
                color: widget.tooltipTextColor.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 1.5,
              ),
            ),
        ],
        textAlign: TextAlign.left,
      );
    }).toList();
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v.toStringAsFixed(1);
  }
}
