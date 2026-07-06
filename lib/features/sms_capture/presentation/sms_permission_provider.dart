import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/sms_permission_service.dart';

part 'sms_permission_provider.freezed.dart';

@freezed
abstract class SmsPermissionState with _$SmsPermissionState {
  const factory SmsPermissionState({
    required PermissionStatus status,
    required bool hasPermanentlyDenied,
  }) = _SmsPermissionState;
}

class SmsPermissionNotifier extends Notifier<SmsPermissionState> {
  @override
  SmsPermissionState build() {
    _checkInitialStatus();
    return const SmsPermissionState(
      status: PermissionStatus.denied,
      hasPermanentlyDenied: false,
    );
  }

  Future<void> _checkInitialStatus() async {
    final service = ref.read(smsPermissionServiceProvider);
    final status = await service.status();
    if (state.status != status ||
        state.hasPermanentlyDenied != status.isPermanentlyDenied) {
      state = SmsPermissionState(
        status: status,
        hasPermanentlyDenied: status.isPermanentlyDenied,
      );
    }
  }

  Future<PermissionStatus> requestPermission() async {
    final service = ref.read(smsPermissionServiceProvider);
    final status = await service.requestPermission();
    state = SmsPermissionState(
      status: status,
      hasPermanentlyDenied: status.isPermanentlyDenied,
    );
    return status;
  }
}

final smsPermissionProvider =
    NotifierProvider<SmsPermissionNotifier, SmsPermissionState>(
  SmsPermissionNotifier.new,
);
