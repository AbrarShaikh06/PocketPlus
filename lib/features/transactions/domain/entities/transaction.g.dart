// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
      id: json['id'] as String,
      userId: json['userId'] as String,
      profileId: json['profileId'] as String,
      amount: (json['amount'] as num).toInt(),
      type: _typeFromFirestore(json['type'] as String),
      source: _sourceFromFirestore(json['source'] as String),
      categoryId: json['categoryId'] as String?,
      merchantName: json['merchantName'] as String?,
      note: json['note'] as String?,
      currency: json['currency'] as String? ?? 'INR',
      transactionDate: _dateTimeFromTimestamp(json['transactionDate']),
      rawSmsText: json['rawSmsText'] as String?,
      smsHash: json['smsHash'] as String?,
      geminiCategory: json['geminiCategory'] as String?,
      geminiConfidence: (json['geminiConfidence'] as num?)?.toDouble(),
      needsCategorization: json['needsCategorization'] as bool? ?? false,
      invoiceId: json['invoiceId'] as String?,
      recurringId: json['recurringId'] as String?,
      syncStatus: json['syncStatus'] == null
          ? SyncStatus.pending
          : _syncStatusFromFirestore(json['syncStatus'] as String),
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: _dateTimeFromTimestamp(json['createdAt']),
      updatedAt: _dateTimeFromTimestamp(json['updatedAt']),
      deletedAt: _nullableDateTimeFromTimestamp(json['deletedAt']),
    );

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'profileId': instance.profileId,
      'amount': instance.amount,
      'type': _typeToFirestore(instance.type),
      'source': _sourceToFirestore(instance.source),
      'categoryId': instance.categoryId,
      'merchantName': instance.merchantName,
      'note': instance.note,
      'currency': instance.currency,
      'transactionDate': _dateTimeToTimestamp(instance.transactionDate),
      'rawSmsText': instance.rawSmsText,
      'smsHash': instance.smsHash,
      'geminiCategory': instance.geminiCategory,
      'geminiConfidence': instance.geminiConfidence,
      'needsCategorization': instance.needsCategorization,
      'invoiceId': instance.invoiceId,
      'recurringId': instance.recurringId,
      'syncStatus': _syncStatusToFirestore(instance.syncStatus),
      'isDeleted': instance.isDeleted,
      'createdAt': _dateTimeToTimestamp(instance.createdAt),
      'updatedAt': _dateTimeToTimestamp(instance.updatedAt),
      'deletedAt': _dateTimeToTimestamp(instance.deletedAt),
    };
