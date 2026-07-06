import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/models/sync_status.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

DateTime _dateTimeFromTimestamp(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  return DateTime.now();
}

dynamic _dateTimeToTimestamp(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}

DateTime? _nullableDateTimeFromTimestamp(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.tryParse(value);
  return null;
}

BudgetType _budgetTypeFromFirestore(String value) => BudgetType.values
    .firstWhere((e) => e.name == value, orElse: () => BudgetType.category);
String _budgetTypeToFirestore(BudgetType type) => type.name;

BudgetPeriod _budgetPeriodFromFirestore(String value) => BudgetPeriod.values
    .firstWhere((e) => e.name == value, orElse: () => BudgetPeriod.monthly);
String _budgetPeriodToFirestore(BudgetPeriod period) => period.name;

SyncStatus _syncStatusFromFirestore(String value) =>
    SyncStatusX.fromFirestore(value);
String _syncStatusToFirestore(SyncStatus status) => status.firestoreValue;

enum BudgetType { category, overall, custom }

enum BudgetPeriod { weekly, monthly, yearly }

enum BudgetStatus { safe, warning, critical, exceeded }

@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    required String id,
    required String userId,
    required String profileId,
    required String name,
    @JsonKey(fromJson: _budgetTypeFromFirestore, toJson: _budgetTypeToFirestore)
    required BudgetType budgetType,
    @Default([]) List<String> categoryIds,
    required int amount,
    @Default(0) int spentAmount,
    @Default(0) int remainingAmount,
    @JsonKey(
        fromJson: _budgetPeriodFromFirestore, toJson: _budgetPeriodToFirestore)
    required BudgetPeriod period,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime startDate,
    @JsonKey(
        fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime? endDate,
    @Default('#4CAF50') String colorHex,
    @Default('account_balance_wallet') String icon,
    @Default(80) int alertThreshold,
    @Default(true) bool notificationsEnabled,
    String? notes,
    @Default(false) bool isPaused,
    @Default(false) bool isDeleted,
    @JsonKey(
        fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime? deletedAt,
    @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
    @Default(SyncStatus.pending)
    SyncStatus syncStatus,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime updatedAt,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}

extension BudgetStatusX on BudgetStatus {
  bool get isExceeded => this == BudgetStatus.exceeded;
  bool get isCritical => this == BudgetStatus.critical;
  bool get isWarning => this == BudgetStatus.warning;
  bool get isSafe => this == BudgetStatus.safe;
}
