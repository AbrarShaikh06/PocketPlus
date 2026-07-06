// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvoiceLineItem _$InvoiceLineItemFromJson(Map<String, dynamic> json) =>
    _InvoiceLineItem(
      description: json['description'] as String,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      unitPrice: (json['unitPrice'] as num).toInt(),
      gstPercent: (json['gstPercent'] as num?)?.toDouble() ?? 0.0,
      gstAmount: (json['gstAmount'] as num?)?.toInt() ?? 0,
      lineTotal: (json['lineTotal'] as num).toInt(),
    );

Map<String, dynamic> _$InvoiceLineItemToJson(_InvoiceLineItem instance) =>
    <String, dynamic>{
      'description': instance.description,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'gstPercent': instance.gstPercent,
      'gstAmount': instance.gstAmount,
      'lineTotal': instance.lineTotal,
    };

_Invoice _$InvoiceFromJson(Map<String, dynamic> json) => _Invoice(
      id: json['id'] as String,
      userId: json['userId'] as String,
      profileId: json['profileId'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      customerName: json['customerName'] as String,
      customerPhone: json['customerPhone'] as String?,
      customerEmail: json['customerEmail'] as String?,
      issueDate: _dateTimeFromTimestamp(json['issueDate']),
      dueDate: _nullableDateTimeFromTimestamp(json['dueDate']),
      lineItems: (json['lineItems'] as List<dynamic>)
          .map((e) => InvoiceLineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toInt(),
      totalGst: (json['totalGst'] as num?)?.toInt() ?? 0,
      discount: (json['discount'] as num?)?.toInt() ?? 0,
      grandTotal: (json['grandTotal'] as num).toInt(),
      status: json['status'] == null
          ? InvoiceStatus.draft
          : _statusFromFirestore(json['status'] as String),
      paidAmount: (json['paidAmount'] as num?)?.toInt() ?? 0,
      paidAt: _nullableDateTimeFromTimestamp(json['paidAt']),
      transactionId: json['transactionId'] as String?,
      notes: json['notes'] as String?,
      createdAt: _dateTimeFromTimestamp(json['createdAt']),
      updatedAt: _dateTimeFromTimestamp(json['updatedAt']),
      deletedAt: _nullableDateTimeFromTimestamp(json['deletedAt']),
    );

Map<String, dynamic> _$InvoiceToJson(_Invoice instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'profileId': instance.profileId,
      'invoiceNumber': instance.invoiceNumber,
      'customerName': instance.customerName,
      'customerPhone': instance.customerPhone,
      'customerEmail': instance.customerEmail,
      'issueDate': _dateTimeToTimestamp(instance.issueDate),
      'dueDate': _dateTimeToTimestamp(instance.dueDate),
      'lineItems': instance.lineItems,
      'subtotal': instance.subtotal,
      'totalGst': instance.totalGst,
      'discount': instance.discount,
      'grandTotal': instance.grandTotal,
      'status': _statusToFirestore(instance.status),
      'paidAmount': instance.paidAmount,
      'paidAt': _dateTimeToTimestamp(instance.paidAt),
      'transactionId': instance.transactionId,
      'notes': instance.notes,
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
      'updatedAt': _dateTimeToTimestamp(instance.updatedAt),
      'deletedAt': _dateTimeToTimestamp(instance.deletedAt),
    };
