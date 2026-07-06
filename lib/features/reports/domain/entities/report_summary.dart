import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_summary.freezed.dart';
part 'report_summary.g.dart';

@freezed
abstract class ReportSummary with _$ReportSummary {
  const factory ReportSummary({
    required int totalIncome,
    required int totalExpense,
    required int netProfit,
    required double changePercent,
    required DateTime month,
    required String profileId,
  }) = _ReportSummary;

  factory ReportSummary.fromJson(Map<String, dynamic> json) =>
      _$ReportSummaryFromJson(json);
}
