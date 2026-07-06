import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_lock_service.dart';

final appLockServiceProvider = Provider<AppLockService>((ref) {
  return AppLockService();
});

/// Immutable app-lock state consumed by the router guard and lock screen.
class AppLockState {
  const AppLockState({
    this.initialized = false,
    this.isEnabled = false,
    this.isLocked = false,
    this.biometricEnabled = false,
  });

  /// True once the initial async read from secure storage has completed. The
  /// router must not gate navigation until this is true, or it would flash the
  /// lock screen (or skip it) before we know whether a lock is configured.
  final bool initialized;
  final bool isEnabled;
  final bool isLocked;
  final bool biometricEnabled;

  AppLockState copyWith({
    bool? initialized,
    bool? isEnabled,
    bool? isLocked,
    bool? biometricEnabled,
  }) {
    return AppLockState(
      initialized: initialized ?? this.initialized,
      isEnabled: isEnabled ?? this.isEnabled,
      isLocked: isLocked ?? this.isLocked,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}

/// Re-lock the app after this long in the background (CLAUDE.md: 5 minutes).
const kAutoLockThreshold = Duration(minutes: 5);

/// Pure decision helper — extracted so the auto-lock policy is unit-testable
/// without a live [WidgetsBinding].
bool shouldAutoLock({
  required bool enabled,
  required DateTime? backgroundedAt,
  required DateTime now,
  Duration threshold = kAutoLockThreshold,
}) {
  if (!enabled || backgroundedAt == null) return false;
  return now.difference(backgroundedAt) >= threshold;
}

class AppLockController extends Notifier<AppLockState>
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  @override
  AppLockState build() {
    final binding = WidgetsBinding.instance;
    binding.addObserver(this);
    ref.onDispose(() => binding.removeObserver(this));
    _load(lockIfEnabled: true);
    return const AppLockState();
  }

  Future<void> _load({required bool lockIfEnabled}) async {
    final service = ref.read(appLockServiceProvider);
    final enabled = await service.isLockEnabled();
    final biometric = await service.isBiometricEnabled();
    state = state.copyWith(
      initialized: true,
      isEnabled: enabled,
      biometricEnabled: biometric,
      // On cold start, a configured lock starts locked.
      isLocked: lockIfEnabled ? enabled : state.isLocked,
    );
  }

  /// Re-read enable/biometric flags after Settings changes them, without
  /// forcing a re-lock of the currently-open session.
  Future<void> refresh() => _load(lockIfEnabled: false);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!this.state.isEnabled) return;
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        _backgroundedAt ??= DateTime.now();
      case AppLifecycleState.resumed:
        if (shouldAutoLock(
          enabled: this.state.isEnabled,
          backgroundedAt: _backgroundedAt,
          now: DateTime.now(),
        )) {
          this.state = this.state.copyWith(isLocked: true);
        }
        _backgroundedAt = null;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<bool> unlockWithPin(String pin) async {
    final ok = await ref.read(appLockServiceProvider).verifyPin(pin);
    if (ok) state = state.copyWith(isLocked: false);
    return ok;
  }

  Future<bool> unlockWithBiometric() async {
    final ok = await ref.read(appLockServiceProvider).authenticateBiometric();
    if (ok) state = state.copyWith(isLocked: false);
    return ok;
  }

  /// Called after a PIN is set in Settings so the app reflects the new lock.
  void markEnabled({required bool biometric}) {
    state = state.copyWith(
      isEnabled: true,
      biometricEnabled: biometric,
      isLocked: false,
    );
  }

  void markDisabled() {
    state = state.copyWith(
      isEnabled: false,
      biometricEnabled: false,
      isLocked: false,
    );
  }
}

final appLockControllerProvider =
    NotifierProvider<AppLockController, AppLockState>(AppLockController.new);
