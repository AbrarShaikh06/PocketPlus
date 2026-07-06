import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/report_summary.dart';
import '../reports_providers.dart';

class MonthlyReportParam {
  const MonthlyReportParam({
    required this.userId,
    required this.profileId,
    required this.month,
  });

  final String userId;
  final String profileId;
  final DateTime month;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyReportParam &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          profileId == other.profileId &&
          month == other.month;

  @override
  int get hashCode => userId.hashCode ^ profileId.hashCode ^ month.hashCode;
}

class MonthlyChartParam {
  const MonthlyChartParam({
    required this.userId,
    required this.profileId,
  });

  final String userId;
  final String profileId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyChartParam &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          profileId == other.profileId;

  @override
  int get hashCode => userId.hashCode ^ profileId.hashCode;
}

final monthlyReportProvider =
    StreamProvider.family<ReportSummary, MonthlyReportParam>((ref, param) {
  final repository = ref.watch(reportRepositoryProvider);
  return repository.watchMonthlyReport(
    userId: param.userId,
    profileId: param.profileId,
    month: param.month,
  );
});

final monthlyChartProvider =
    StreamProvider.family<List<ReportSummary>, MonthlyChartParam>((ref, param) {
  final repository = ref.watch(reportRepositoryProvider);
  return repository.watchMonthlyChart(
    userId: param.userId,
    profileId: param.profileId,
  );
});
