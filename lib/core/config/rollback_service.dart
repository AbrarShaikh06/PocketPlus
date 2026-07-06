import 'dart:async';

import 'package:package_info_plus/package_info_plus.dart';

import '../notifications/local_notification_service.dart';
import '../utils/logger.dart';
import 'remote_config_service.dart';

/// Handles safe rollback when Remote Config disables features.
///
/// Call [evaluate] after Remote Config is initialized to:
/// 1. Check kill switch → show maintenance screen
/// 2. Check minimum app version → force update
/// 3. Dispose resources for disabled features
///
/// ```dart
/// await RemoteConfigService.instance.ensureInitialized();
/// await RollbackService.evaluate();
/// ```
abstract final class RollbackService {
  static bool _evaluated = false;
  static StreamSubscription? _configSubscription;

  /// Rollback evaluation result.
  static late final RollbackDecision decision;

  /// Evaluate all rollback conditions. Must be called after Remote Config init.
  static Future<RollbackDecision> evaluate() async {
    if (_evaluated) return decision;
    _evaluated = true;

    final flags = RemoteConfigService.instance.flags;

    // Check kill switch
    if (flags.killSwitchEnabled && flags.killSwitchMessage.isNotEmpty) {
      decision = RollbackDecision.killSwitch(flags.killSwitchMessage);
      AppLogger.warning(
        'Kill switch activated',
        function: 'RollbackService.evaluate',
        extra: {'message': flags.killSwitchMessage},
      );
      _disableAllFeatures();
      return decision;
    }

    // Check minimum app version
    final version = await _currentVersion();
    if (_isVersionBelow(version, flags.minimumAppVersion)) {
      decision = RollbackDecision.forceUpdate(flags.minimumAppVersion);
      AppLogger.warning(
        'Minimum app version not met',
        function: 'RollbackService.evaluate',
        extra: {
          'current': version,
          'required': flags.minimumAppVersion,
        },
      );
      return decision;
    }

    // Evaluate feature flags — dispose resources for disabled features.
    _applyFeatureFlags(flags);

    decision = RollbackDecision.passed();
    AppLogger.info(
      'Rollback evaluation passed',
      function: 'RollbackService.evaluate',
    );
    return decision;
  }

  /// Listen for Remote Config changes and re-evaluate feature flags.
  static void watchConfigChanges() {
    _configSubscription = Stream.periodic(
      const Duration(minutes: 15),
      (_) => RemoteConfigService.instance.refresh(),
    ).listen((_) => _applyFeatureFlags(RemoteConfigService.instance.flags));
  }

  /// Clean up listeners.
  static void dispose() {
    _configSubscription?.cancel();
    _configSubscription = null;
  }

  // ── Private ──────────────────────────────────────────────────────────────

  static void _disableAllFeatures() {
    _applyFeatureFlags(
      const FeatureFlags(
        enableAi: false,
        enableAds: false,
        enableExports: false,
        enableNotifications: false,
        enableSmsCapture: false,
        enableBackup: false,
        enableSync: false,
        geminiEnabled: false,
        smsAutoCaptureEnabled: false,
        exportPdfEnabled: false,
      ),
    );
  }

  static void _applyFeatureFlags(FeatureFlags flags) {
    // Notifications
    if (!flags.enableNotifications) {
      LocalNotificationService.cancelAll();
    }

    // SMS capture
    if (!flags.enableSmsCapture && !flags.smsAutoCaptureEnabled) {
      // SMS capture listeners are managed by smsCaptureServiceProvider;
      // it checks the feature flag internally.
    }

    if (!flags.enableSync) {
      // Firestore sync is handled by Firestore itself (offline persistence);
      // we don't disable it here to avoid data loss.
      AppLogger.info(
        'Sync disabled by feature flag — writes will be queued locally',
        function: 'RollbackService._applyFeatureFlags',
      );
    }
  }

  static Future<String> _currentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (_) {
      return '0.0.0';
    }
  }

  /// Compare two semantic version strings.
  static bool _isVersionBelow(String current, String required) {
    try {
      final curParts = current.split('.').map(int.parse).toList();
      final reqParts = required.split('.').map(int.parse).toList();
      while (curParts.length < 3) {
        curParts.add(0);
      }
      while (reqParts.length < 3) {
        reqParts.add(0);
      }
      for (int i = 0; i < 3; i++) {
        if (curParts[i] < reqParts[i]) return true;
        if (curParts[i] > reqParts[i]) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

/// Outcome of a rollback evaluation.
sealed class RollbackDecision {
  const RollbackDecision();

  /// All checks passed — app can proceed normally.
  factory RollbackDecision.passed() = _Passed;

  /// Kill switch is active — show maintenance screen.
  factory RollbackDecision.killSwitch(String message) = _KillSwitch;

  /// App version is too old — force update.
  factory RollbackDecision.forceUpdate(String requiredVersion) = _ForceUpdate;

  bool get isPassed => this is _Passed;
  bool get isKillSwitch => this is _KillSwitch;
  bool get isForceUpdate => this is _ForceUpdate;

  /// The kill switch message. Only valid when [isKillSwitch] is true.
  String? get killSwitchMessage {
    return switch (this) {
      _KillSwitch(:final message) => message,
      _ => null,
    };
  }

  /// The required minimum version. Only valid when [isForceUpdate] is true.
  String? get requiredVersion {
    return switch (this) {
      _ForceUpdate(:final requiredVersion) => requiredVersion,
      _ => null,
    };
  }
}

final class _Passed extends RollbackDecision {
  const _Passed();
}

final class _KillSwitch extends RollbackDecision {
  const _KillSwitch(this.message);
  final String message;
}

final class _ForceUpdate extends RollbackDecision {
  const _ForceUpdate(this.requiredVersion);
  @override
  final String? requiredVersion;
}
