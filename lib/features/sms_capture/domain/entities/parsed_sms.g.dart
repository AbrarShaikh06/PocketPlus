// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parsed_sms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParsedSms _$ParsedSmsFromJson(Map<String, dynamic> json) => _ParsedSms(
      amount: (json['amount'] as num).toInt(),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      merchantName: json['merchantName'] as String?,
      transactionDate: DateTime.parse(json['transactionDate'] as String),
      smsHash: json['smsHash'] as String,
      senderId: json['senderId'] as String,
      rawSmsText: json['rawSmsText'] as String,
      accountLast4: json['accountLast4'] as String?,
      currencyCode: json['currencyCode'] as String? ?? 'INR',
      mpesaCode: json['mpesaCode'] as String?,
    );

Map<String, dynamic> _$ParsedSmsToJson(_ParsedSms instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'merchantName': instance.merchantName,
      'transactionDate': instance.transactionDate.toIso8601String(),
      'smsHash': instance.smsHash,
      'senderId': instance.senderId,
      'rawSmsText': instance.rawSmsText,
      'accountLast4': instance.accountLast4,
      'currencyCode': instance.currencyCode,
      'mpesaCode': instance.mpesaCode,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.income: 'income',
  TransactionType.expense: 'expense',
};
