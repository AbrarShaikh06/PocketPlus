// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportSummary _$ReportSummaryFromJson(Map<String, dynamic> json) =>
    _ReportSummary(
      totalIncome: (json['totalIncome'] as num).toInt(),
      totalExpense: (json['totalExpense'] as num).toInt(),
      netProfit: (json['netProfit'] as num).toInt(),
      changePercent: (json['changePercent'] as num).toDouble(),
      month: DateTime.parse(json['month'] as String),
      profileId: json['profileId'] as String,
    );

Map<String, dynamic> _$ReportSummaryToJson(_ReportSummary instance) =>
    <String, dynamic>{
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'netProfit': instance.netProfit,
      'changePercent': instance.changePercent,
      'month': instance.month.toIso8601String(),
      'profileId': instance.profileId,
    };
