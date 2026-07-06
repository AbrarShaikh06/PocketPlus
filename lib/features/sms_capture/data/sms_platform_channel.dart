import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RawSms {
  final String text;
  final String senderId;

  /// Epoch milliseconds the SMS was received on the device, when known
  /// (from the Android inbox `date` column / the broadcast timestamp).
  /// Used as the transaction time when the SMS body has no embedded time.
  final int? timestampMillis;

  const RawSms({
    required this.text,
    required this.senderId,
    this.timestampMillis,
  });
}

class SmsPlatformChannel {
  final MethodChannel _channel = const MethodChannel('pocketplus/sms');
  final StreamController<RawSms> _smsStreamController =
      StreamController<RawSms>.broadcast();

  SmsPlatformChannel() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Stream<RawSms> get smsStream => _smsStreamController.stream;

  Future<dynamic> scanInbox() async {
    try {
      debugPrint('[SmsPlatformChannel] Requesting inbox scan from native');
      final result = await _channel.invokeMethod('scanInbox');
      debugPrint('[SmsPlatformChannel] Inbox scan returned: $result');
      return result;
    } catch (e) {
      debugPrint('[SmsPlatformChannel] scanInbox failed: $e');
      return null;
    }
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onSmsReceived') {
      try {
        final arguments = call.arguments;
        if (arguments is Map) {
          final text = arguments['text'] as String?;
          final senderId = arguments['senderId'] as String?;
          final timestamp = (arguments['timestamp'] as num?)?.toInt();
          if (text != null &&
              text.isNotEmpty &&
              senderId != null &&
              senderId.isNotEmpty) {
            _smsStreamController.add(
              RawSms(
                text: text,
                senderId: senderId,
                timestampMillis: timestamp,
              ),
            );
          }
        }
      } catch (e) {
        // Handle gracefully, ensuring nulls/errors are caught.
      }
    }
  }

  void dispose() {
    _smsStreamController.close();
  }
}

final smsPlatformChannelProvider = Provider<SmsPlatformChannel>((ref) {
  final channel = SmsPlatformChannel();
  ref.onDispose(() => channel.dispose());
  return channel;
});
