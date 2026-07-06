import 'package:flutter/foundation.dart';

/// A single period (month) of multi-series analytics data.
///
/// Values are unit-agnostic doubles (e.g. visitor counts). The chart treats
/// them as raw magnitudes and builds the simulated stack from [desktop],
/// [mobile] and [other] in that bottom-to-top order.
@immutable
class AnalyticsData {
  const AnalyticsData({
    required this.month,
    required this.desktop,
    required this.mobile,
    required this.other,
  });

  /// Short axis label for this period, e.g. `'Jan'`.
  final String month;

  /// Bottom-most series value.
  final double desktop;

  /// Middle series value.
  final double mobile;

  /// Top-most series value.
  final double other;

  /// Cumulative height of the full stack for this period.
  double get total => desktop + mobile + other;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnalyticsData &&
        other.month == month &&
        other.desktop == desktop &&
        other.mobile == mobile &&
        other.other == this.other;
  }

  @override
  int get hashCode => Object.hash(month, desktop, mobile, other);
}
