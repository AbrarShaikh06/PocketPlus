import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/models/models.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

DateTime _dateTimeFromTimestamp(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is String) {
    return DateTime.parse(value);
  }
  return DateTime.now();
}

dynamic _dateTimeToTimestamp(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}

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

TransactionType _typeFromFirestore(String value) =>
    TransactionTypeX.fromFirestore(value);

String _typeToFirestore(TransactionType type) => type.firestoreValue;

TransactionSource _sourceFromFirestore(String value) =>
    TransactionSourceX.fromFirestore(value);

String _sourceToFirestore(TransactionSource source) => source.firestoreValue;

SyncStatus _syncStatusFromFirestore(String value) =>
    SyncStatusX.fromFirestore(value);

String _syncStatusToFirestore(SyncStatus status) => status.firestoreValue;

@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String userId,
    required String profileId,
    required int amount, // stored in paise
    @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
    required TransactionType type,
    @JsonKey(fromJson: _sourceFromFirestore, toJson: _sourceToFirestore)
    required TransactionSource source,
    String? categoryId,
    String? merchantName,
    String? note,
    @Default('INR') String currency,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime transactionDate,
    String? rawSmsText,
    String? smsHash,
    String? geminiCategory,
    double? geminiConfidence,

    /// True when the transaction was saved with a placeholder category (e.g.
    /// saved offline or before Gemini could categorise it). The background
    /// deferred-categorization service picks these up once the device is back
    /// online and attempts to assign a real category.
    @Default(false) bool needsCategorization,
    String? invoiceId,
    String? recurringId,
    @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
    @Default(SyncStatus.pending)
    SyncStatus syncStatus,
    @Default(false) bool isDeleted,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime updatedAt,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    DateTime? deletedAt,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}
