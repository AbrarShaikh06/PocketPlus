// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khata_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KhataCustomer _$KhataCustomerFromJson(Map<String, dynamic> json) =>
    _KhataCustomer(
      id: json['id'] as String,
      userId: json['userId'] as String,
      profileId: json['profileId'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
      balance: (json['balance'] as num?)?.toInt() ?? 0,
      notes: json['notes'] as String?,
      createdAt: _dateTimeFromTimestamp(json['createdAt']),
      updatedAt: _dateTimeFromTimestamp(json['updatedAt']),
      deletedAt: _nullableDateTimeFromTimestamp(json['deletedAt']),
    );

Map<String, dynamic> _$KhataCustomerToJson(_KhataCustomer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'profileId': instance.profileId,
      'name': instance.name,
      'phone': instance.phone,
      'balance': instance.balance,
      'notes': instance.notes,
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
      'updatedAt': _dateTimeToTimestamp(instance.updatedAt),
      'deletedAt': _dateTimeToTimestamp(instance.deletedAt),
    };
