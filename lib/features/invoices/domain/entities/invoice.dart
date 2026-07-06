import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

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

InvoiceStatus _statusFromFirestore(String value) =>
    InvoiceStatus.values.firstWhere((e) => e.name == value);

String _statusToFirestore(InvoiceStatus status) => status.name;

enum InvoiceStatus { draft, sent, paid, partial, cancelled }

@freezed
abstract class InvoiceLineItem with _$InvoiceLineItem {
  const factory InvoiceLineItem({
    required String description,
    @Default(1.0) double quantity,
    required int unitPrice,
    @Default(0.0) double gstPercent,
    @Default(0) int gstAmount,
    required int lineTotal,
  }) = _InvoiceLineItem;

  factory InvoiceLineItem.fromJson(Map<String, dynamic> json) =>
      _$InvoiceLineItemFromJson(json);
}

@freezed
abstract class Invoice with _$Invoice {
  const factory Invoice({
    required String id,
    required String userId,
    required String profileId,
    required String invoiceNumber,
    required String customerName,
    String? customerPhone,
    String? customerEmail,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime issueDate,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    DateTime? dueDate,
    required List<InvoiceLineItem> lineItems,
    required int subtotal,
    @Default(0) int totalGst,
    @Default(0) int discount,
    required int grandTotal,
    @JsonKey(fromJson: _statusFromFirestore, toJson: _statusToFirestore)
    @Default(InvoiceStatus.draft)
    InvoiceStatus status,
    @Default(0) int paidAmount,
    @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp,
      toJson: _dateTimeToTimestamp,
    )
    DateTime? paidAt,
    String? transactionId,
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
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
}
