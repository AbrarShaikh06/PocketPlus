// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeedbackItem _$FeedbackItemFromJson(Map<String, dynamic> json) =>
    _FeedbackItem(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      type: _typeFromFirestore(json['type'] as String),
      message: json['message'] as String?,
      rating: (json['rating'] as num?)?.toInt(),
      npsScore: (json['npsScore'] as num?)?.toInt(),
      screenshotUrl: json['screenshotUrl'] as String?,
      appVersion: json['appVersion'] as String,
      platform: json['platform'] as String? ?? 'android',
      status: json['status'] as String? ?? 'NEW',
      createdAt: _dateTimeFromTimestamp(json['createdAt']),
    );

Map<String, dynamic> _$FeedbackItemToJson(_FeedbackItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _typeToFirestore(instance.type),
      'message': instance.message,
      'rating': instance.rating,
      'npsScore': instance.npsScore,
      'screenshotUrl': instance.screenshotUrl,
      'appVersion': instance.appVersion,
      'platform': instance.platform,
      'status': instance.status,
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
    };
