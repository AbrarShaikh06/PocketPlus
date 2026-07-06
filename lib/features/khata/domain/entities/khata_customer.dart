import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'khata_customer.freezed.dart';
part 'khata_customer.g.dart';

DateTime _dateTimeFromTimestamp(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  return DateTime.now();
}

dynamic _dateTimeToTimestamp(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}

DateTime? _nullableDateTimeFromTimestamp(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.tryParse(value);
  return null;
}

@freezed
abstract class KhataCustomer with _$KhataCustomer {
  const factory KhataCustomer({
    required String id,
    required String userId,
    required String profileId,
    required String name,
    String? phone,
    @Default(0) int balance,
    String? notes,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime updatedAt,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    DateTime? deletedAt,
  }) = _KhataCustomer;

  factory KhataCustomer.fromJson(Map<String, dynamic> json) =>
      _$KhataCustomerFromJson(json);
}
