// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingsEntry _$SavingsEntryFromJson(Map<String, dynamic> json) =>
    _SavingsEntry(
      id: json['id'] as String,
      goalId: json['goalId'] as String,
      userId: json['userId'] as String,
      profileId: json['profileId'] as String,
      amount: (json['amount'] as num).toInt(),
      note: json['note'] as String?,
      entryDate: _dateTimeFromTimestamp(json['entryDate']),
      createdAt: _dateTimeFromTimestamp(json['createdAt']),
      syncStatus: json['syncStatus'] == null
          ? SyncStatus.pending
          : _syncStatusFromFirestore(json['syncStatus'] as String),
    );

Map<String, dynamic> _$SavingsEntryToJson(_SavingsEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'goalId': instance.goalId,
      'userId': instance.userId,
      'profileId': instance.profileId,
      'amount': instance.amount,
      'note': instance.note,
      'entryDate': _dateTimeToTimestamp(instance.entryDate),
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
      'syncStatus': _syncStatusToFirestore(instance.syncStatus),
    };
