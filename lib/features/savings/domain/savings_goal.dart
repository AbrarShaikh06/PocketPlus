import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/models.dart';

part 'savings_goal.freezed.dart';
part 'savings_goal.g.dart';

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

SyncStatus _syncStatusFromFirestore(String value) =>
    SyncStatusX.fromFirestore(value);

String _syncStatusToFirestore(SyncStatus status) => status.firestoreValue;

enum SavingsCategory {
  CAR,
  HOUSE,
  EDUCATION,
  BUSINESS,
  TRAVEL,
  OTHER,
}

SavingsCategory _categoryFromFirestore(String value) =>
    SavingsCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SavingsCategory.OTHER,
    );

String _categoryToFirestore(SavingsCategory category) => category.name;

@freezed
abstract class SavingsGoal with _$SavingsGoal {
  const factory SavingsGoal({
    required String id,
    required String userId,
    required String profileId,
    required String name,
    @JsonKey(fromJson: _categoryFromFirestore, toJson: _categoryToFirestore)
    required SavingsCategory category,
    required int targetAmount, // Stored in paise
    required int savedAmount, // Stored in paise
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    DateTime? targetDate,
    String? notes,
    @Default(false) bool isAchieved,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    DateTime? achievedAt,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime updatedAt,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    DateTime? deletedAt,
    @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
    @Default(SyncStatus.pending)
    SyncStatus syncStatus,
  }) = _SavingsGoal;

  factory SavingsGoal.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalFromJson(json);
}
