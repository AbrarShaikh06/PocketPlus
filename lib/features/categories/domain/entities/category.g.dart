// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      profileId: json['profileId'] as String?,
      name: json['name'] as String,
      icon: json['icon'] as String,
      colorHex: json['colorHex'] as String?,
      gstHead: _gstHeadFromFirestore(json['gstHead'] as String?),
      type: _typeFromFirestore(json['type'] as String),
      isSystem: json['isSystem'] as bool? ?? false,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      createdAt: _nullableDateTimeFromTimestamp(json['createdAt']),
      deletedAt: _nullableDateTimeFromTimestamp(json['deletedAt']),
    );

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'profileId': instance.profileId,
      'name': instance.name,
      'icon': instance.icon,
      'colorHex': instance.colorHex,
      'gstHead': _gstHeadToFirestore(instance.gstHead),
      'type': _typeToFirestore(instance.type),
      'isSystem': instance.isSystem,
      'sortOrder': instance.sortOrder,
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
      'deletedAt': _dateTimeToTimestamp(instance.deletedAt),
    };
