import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/transaction_type.dart';

part 'parsed_sms.freezed.dart';
part 'parsed_sms.g.dart';

@freezed
abstract class ParsedSms with _$ParsedSms {
  const factory ParsedSms({
    required int amount,
    required TransactionType type,
    String? merchantName,
    required DateTime transactionDate,
    required String smsHash,
    required String senderId,
    required String rawSmsText,
    String? accountLast4,
    @Default('INR') String currencyCode,
    String? mpesaCode,
  }) = _ParsedSms;

  factory ParsedSms.fromJson(Map<String, dynamic> json) =>
      _$ParsedSmsFromJson(json);
}
