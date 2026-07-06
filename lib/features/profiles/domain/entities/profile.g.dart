// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      type: _typeFromFirestore(json['type'] as String),
      colorHex: json['colorHex'] as String? ?? '#0D631B',
      upiIds: (json['upiIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      bankAccountLast4: (json['bankAccountLast4'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isDefault: json['isDefault'] as bool? ?? false,
      fiscalYearStart: json['fiscalYearStart'] == null
          ? FiscalYearStart.apr
          : _fiscalYearStartFromFirestore(json['fiscalYearStart'] as String),
      currency: json['currency'] as String? ?? 'INR',
      createdAt: _nullableDateTimeFromTimestamp(json['createdAt']),
      updatedAt: _nullableDateTimeFromTimestamp(json['updatedAt']),
      deletedAt: _nullableDateTimeFromTimestamp(json['deletedAt']),
    );

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'type': _typeToFirestore(instance.type),
      'colorHex': instance.colorHex,
      'upiIds': instance.upiIds,
      'bankAccountLast4': instance.bankAccountLast4,
      'isDefault': instance.isDefault,
      'fiscalYearStart': _fiscalYearStartToFirestore(instance.fiscalYearStart),
      'currency': instance.currency,
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
      'updatedAt': _dateTimeToTimestamp(instance.updatedAt),
      'deletedAt': _dateTimeToTimestamp(instance.deletedAt),
    };
