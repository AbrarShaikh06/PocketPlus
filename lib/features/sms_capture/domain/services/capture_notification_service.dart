import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/notifications/local_notification_service.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/models/models.dart';
import '../entities/parsed_sms.dart';

class CaptureNotificationService {
  GoRouter? _router;

  void setRouter(GoRouter router) {
    _router = router;
  }

  void triggerNotification(ParsedSms parsedSms) {
    final amountFormatted = (parsedSms.amount / 100).toStringAsFixed(0);
    final typeLabel =
        parsedSms.type == TransactionType.expense ? 'Debit' : 'Credit';

    final title = '₹$amountFormatted $typeLabel detected';
    final body = parsedSms.merchantName != null
        ? '₹$amountFormatted at ${parsedSms.merchantName} — tap to confirm'
        : '₹$amountFormatted $typeLabel — tap to confirm';

    // Build payload matching FCM sms_capture format for navigation
    final payload = json.encode({
      'type': 'sms_capture',
      'captureId': parsedSms.smsHash,
      'amount': parsedSms.amount.toString(),
      'transactionType':
          parsedSms.type == TransactionType.income ? 'income' : 'expense',
      'merchantName': parsedSms.merchantName,
      'transactionDate': parsedSms.transactionDate.toIso8601String(),
      'smsHash': parsedSms.smsHash,
      'senderId': parsedSms.senderId,
      'rawSmsText': parsedSms.rawSmsText,
      'accountLast4': parsedSms.accountLast4,
    });

    try {
      LocalNotificationService.show(title, body, payload);
      debugPrint('Notification shown: $title');
    } catch (e) {
      debugPrint('Failed to show notification: $e');
    }
  }

  void navigateToConfirmation(ParsedSms parsedSms) {
    if (_router == null) {
      debugPrint('Cannot navigate: router not set');
      return;
    }
    final smsId = parsedSms.smsHash;
    _router!.go(RouteNames.captureConfirm(smsId), extra: parsedSms);
  }
}

final captureNotificationServiceProvider =
    Provider<CaptureNotificationService>((ref) {
  return CaptureNotificationService();
});
