import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_item.freezed.dart';
part 'feedback_item.g.dart';

DateTime _dateTimeFromTimestamp(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  return DateTime.now();
}

dynamic _dateTimeToTimestamp(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}

enum FeedbackType {
  general,
  featureRequest,
  bug,
  nps,
}

extension FeedbackTypeX on FeedbackType {
  String get firestoreValue {
    if (this == FeedbackType.featureRequest) return 'FEATURE_REQUEST';
    return name.toUpperCase();
  }

  static FeedbackType fromFirestore(String value) {
    final cleanValue = value.toUpperCase().replaceAll('_', '');
    return FeedbackType.values.firstWhere(
      (e) => e.name.toUpperCase().replaceAll('_', '') == cleanValue,
      orElse: () => FeedbackType.general,
    );
  }
}

FeedbackType _typeFromFirestore(String value) =>
    FeedbackTypeX.fromFirestore(value);
String _typeToFirestore(FeedbackType type) => type.firestoreValue;

@freezed
abstract class FeedbackItem with _$FeedbackItem {
  const factory FeedbackItem({
    required String id,
    String? userId,
    @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
    required FeedbackType type,
    String? message,
    int? rating,
    int? npsScore,
    String? screenshotUrl,
    required String appVersion,
    @Default('android') String platform,
    @Default('NEW') String status,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
  }) = _FeedbackItem;

  factory FeedbackItem.fromJson(Map<String, dynamic> json) =>
      _$FeedbackItemFromJson(json);
}
