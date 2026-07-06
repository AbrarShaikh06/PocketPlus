import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class VoicePermissionService {
  Future<PermissionStatus> requestPermission() async {
    return await Permission.microphone.request();
  }

  Future<bool> isGranted() async {
    return await Permission.microphone.isGranted;
  }

  Future<PermissionStatus> status() async {
    return await Permission.microphone.status;
  }

  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}

final voicePermissionServiceProvider = Provider<VoicePermissionService>((ref) {
  return VoicePermissionService();
});
