// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khata_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KhataEntry _$KhataEntryFromJson(Map<String, dynamic> json) => _KhataEntry(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toInt(),
      entryType: _entryTypeFromFirestore(json['entryType'] as String),
      note: json['note'] as String?,
      entryDate: _dateTimeFromTimestamp(json['entryDate']),
      createdAt: _dateTimeFromTimestamp(json['createdAt']),
    );

Map<String, dynamic> _$KhataEntryToJson(_KhataEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'userId': instance.userId,
      'amount': instance.amount,
      'entryType': _entryTypeToFirestore(instance.entryType),
      'note': instance.note,
      'entryDate': _dateTimeToTimestamp(instance.entryDate),
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
    };
