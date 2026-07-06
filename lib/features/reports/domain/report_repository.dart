import 'entities/report_summary.dart';

abstract interface class ReportRepository {
  Stream<ReportSummary> watchMonthlyReport({
    required String userId,
    required String profileId,
    required DateTime month,
  });
  Stream<List<ReportSummary>> watchMonthlyChart({
    required String userId,
    required String profileId,
  });
}
