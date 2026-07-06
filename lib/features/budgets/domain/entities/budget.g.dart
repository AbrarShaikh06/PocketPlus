// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Budget _$BudgetFromJson(Map<String, dynamic> json) => _Budget(
      id: json['id'] as String,
      userId: json['userId'] as String,
      profileId: json['profileId'] as String,
      name: json['name'] as String,
      budgetType: _budgetTypeFromFirestore(json['budgetType'] as String),
      categoryIds: (json['categoryIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      amount: (json['amount'] as num).toInt(),
      spentAmount: (json['spentAmount'] as num?)?.toInt() ?? 0,
      remainingAmount: (json['remainingAmount'] as num?)?.toInt() ?? 0,
      period: _budgetPeriodFromFirestore(json['period'] as String),
      startDate: _dateTimeFromTimestamp(json['startDate']),
      endDate: _nullableDateTimeFromTimestamp(json['endDate']),
      colorHex: json['colorHex'] as String? ?? '#4CAF50',
      icon: json['icon'] as String? ?? 'account_balance_wallet',
      alertThreshold: (json['alertThreshold'] as num?)?.toInt() ?? 80,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      notes: json['notes'] as String?,
      isPaused: json['isPaused'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: _nullableDateTimeFromTimestamp(json['deletedAt']),
      syncStatus: json['syncStatus'] == null
          ? SyncStatus.pending
          : _syncStatusFromFirestore(json['syncStatus'] as String),
      createdAt: _dateTimeFromTimestamp(json['createdAt']),
      updatedAt: _dateTimeFromTimestamp(json['updatedAt']),
    );

Map<String, dynamic> _$BudgetToJson(_Budget instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'profileId': instance.profileId,
      'name': instance.name,
      'budgetType': _budgetTypeToFirestore(instance.budgetType),
      'categoryIds': instance.categoryIds,
      'amount': instance.amount,
      'spentAmount': instance.spentAmount,
      'remainingAmount': instance.remainingAmount,
      'period': _budgetPeriodToFirestore(instance.period),
      'startDate': _dateTimeToTimestamp(instance.startDate),
      'endDate': _dateTimeToTimestamp(instance.endDate),
      'colorHex': instance.colorHex,
      'icon': instance.icon,
      'alertThreshold': instance.alertThreshold,
      'notificationsEnabled': instance.notificationsEnabled,
      'notes': instance.notes,
      'isPaused': instance.isPaused,
      'isDeleted': instance.isDeleted,
      'deletedAt': _dateTimeToTimestamp(instance.deletedAt),
      'syncStatus': _syncStatusToFirestore(instance.syncStatus),
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
      'updatedAt': _dateTimeToTimestamp(instance.updatedAt),
    };
