import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/models.dart';

part 'savings_entry.freezed.dart';
part 'savings_entry.g.dart';

DateTime _dateTimeFromTimestamp(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  return DateTime.now();
}

dynamic _dateTimeToTimestamp(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}

SyncStatus _syncStatusFromFirestore(String value) =>
    SyncStatusX.fromFirestore(value);

String _syncStatusToFirestore(SyncStatus status) => status.firestoreValue;

@freezed
abstract class SavingsEntry with _$SavingsEntry {
  const factory SavingsEntry({
    required String id,
    required String goalId,
    required String userId,
    required String profileId,
    required int amount, // Stored in paise
    String? note,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime entryDate,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
    @Default(SyncStatus.pending)
    SyncStatus syncStatus,
  }) = _SavingsEntry;

  factory SavingsEntry.fromJson(Map<String, dynamic> json) =>
      _$SavingsEntryFromJson(json);
}
