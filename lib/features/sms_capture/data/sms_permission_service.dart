import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class SmsPermissionService {
  Future<PermissionStatus> requestPermission() async {
    debugPrint('[SmsPermissionService] Requesting SMS permission');
    final status = await Permission.sms.request();
    debugPrint('[SmsPermissionService] Permission result: ${status.name}');
    return status;
  }

  Future<bool> isGranted() async {
    final isGranted = await Permission.sms.isGranted;
    debugPrint('[SmsPermissionService] isGranted: $isGranted');
    return isGranted;
  }

  Future<PermissionStatus> status() async {
    final status = await Permission.sms.status;
    debugPrint('[SmsPermissionService] status: ${status.name}');
    return status;
  }

  Future<bool> openSettings() async {
    debugPrint('[SmsPermissionService] Opening app settings');
    return await openAppSettings();
  }
}

final smsPermissionServiceProvider = Provider<SmsPermissionService>((ref) {
  return SmsPermissionService();
});
