import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'khata_entry.freezed.dart';
part 'khata_entry.g.dart';

DateTime _dateTimeFromTimestamp(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  return DateTime.now();
}

dynamic _dateTimeToTimestamp(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}

KhataEntryType _entryTypeFromFirestore(String value) =>
    KhataEntryType.values.firstWhere((e) => e.name == value);

String _entryTypeToFirestore(KhataEntryType type) => type.name;

enum KhataEntryType { creditGiven, repaymentReceived }

@freezed
abstract class KhataEntry with _$KhataEntry {
  const factory KhataEntry({
    required String id,
    required String customerId,
    required String userId,
    required int amount,
    @JsonKey(fromJson: _entryTypeFromFirestore, toJson: _entryTypeToFirestore)
    required KhataEntryType entryType,
    String? note,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime entryDate,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
  }) = _KhataEntry;

  factory KhataEntry.fromJson(Map<String, dynamic> json) =>
      _$KhataEntryFromJson(json);
}
