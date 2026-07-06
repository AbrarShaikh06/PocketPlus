import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/models.dart';

part 'category.freezed.dart';
part 'category.g.dart';

DateTime? _nullableDateTimeFromTimestamp(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}

dynamic _dateTimeToTimestamp(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}

TransactionType _typeFromFirestore(String value) =>
    TransactionTypeX.fromFirestore(value);

String _typeToFirestore(TransactionType type) => type.firestoreValue;

GstHead? _gstHeadFromFirestore(String? value) =>
    value != null ? GstHeadX.fromFirestore(value) : null;

String? _gstHeadToFirestore(GstHead? gstHead) => gstHead?.firestoreValue;

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    String? userId, // null = system default
    String? profileId, // null = cross-profile
    required String name,
    required String icon, // material symbol name
    String? colorHex,
    @JsonKey(fromJson: _gstHeadFromFirestore, toJson: _gstHeadToFirestore)
    GstHead? gstHead,
    @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
    required TransactionType type,
    @Default(false) bool isSystem,
    @Default(0) int sortOrder,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    DateTime? createdAt,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    DateTime? deletedAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
