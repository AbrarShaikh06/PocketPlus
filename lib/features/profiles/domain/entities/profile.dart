import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/models.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

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

ProfileType _typeFromFirestore(String value) =>
    ProfileTypeX.fromFirestore(value);

String _typeToFirestore(ProfileType type) => type.firestoreValue;

FiscalYearStart _fiscalYearStartFromFirestore(String value) =>
    FiscalYearStartX.fromFirestore(value);

String _fiscalYearStartToFirestore(FiscalYearStart start) =>
    start.firestoreValue;

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String userId,
    required String name,
    @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
    required ProfileType type,
    @Default('#0D631B') String colorHex,
    @Default([]) List<String> upiIds,
    @Default([]) List<String> bankAccountLast4,
    @Default(false) bool isDefault,
    @JsonKey(
      fromJson: _fiscalYearStartFromFirestore,
      toJson: _fiscalYearStartToFirestore,
    )
    @Default(FiscalYearStart.apr)
    FiscalYearStart fiscalYearStart,
    @Default('INR') String currency,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    DateTime? createdAt,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    DateTime? updatedAt,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    DateTime? deletedAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
