// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingsGoal _$SavingsGoalFromJson(Map<String, dynamic> json) => _SavingsGoal(
      id: json['id'] as String,
      userId: json['userId'] as String,
      profileId: json['profileId'] as String,
      name: json['name'] as String,
      category: _categoryFromFirestore(json['category'] as String),
      targetAmount: (json['targetAmount'] as num).toInt(),
      savedAmount: (json['savedAmount'] as num).toInt(),
      targetDate: _nullableDateTimeFromTimestamp(json['targetDate']),
      notes: json['notes'] as String?,
      isAchieved: json['isAchieved'] as bool? ?? false,
      achievedAt: _nullableDateTimeFromTimestamp(json['achievedAt']),
      createdAt: _dateTimeFromTimestamp(json['createdAt']),
      updatedAt: _dateTimeFromTimestamp(json['updatedAt']),
      deletedAt: _nullableDateTimeFromTimestamp(json['deletedAt']),
      syncStatus: json['syncStatus'] == null
          ? SyncStatus.pending
          : _syncStatusFromFirestore(json['syncStatus'] as String),
    );

Map<String, dynamic> _$SavingsGoalToJson(_SavingsGoal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'profileId': instance.profileId,
      'name': instance.name,
      'category': _categoryToFirestore(instance.category),
      'targetAmount': instance.targetAmount,
      'savedAmount': instance.savedAmount,
      'targetDate': _dateTimeToTimestamp(instance.targetDate),
      'notes': instance.notes,
      'isAchieved': instance.isAchieved,
      'achievedAt': _dateTimeToTimestamp(instance.achievedAt),
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
      'updatedAt': _dateTimeToTimestamp(instance.updatedAt),
      'deletedAt': _dateTimeToTimestamp(instance.deletedAt),
      'syncStatus': _syncStatusToFirestore(instance.syncStatus),
    };
