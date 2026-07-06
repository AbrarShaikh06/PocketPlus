import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../utils/logger.dart';

/// Feature flags that can be toggled remotely via Firebase Remote Config.
///
/// Default values are set inline so the app works offline without Remote
/// Config. Once Remote Config fetches activate, the server values override.
class FeatureFlags {
  const FeatureFlags({
    this.geminiEnabled = true,
    this.smsAutoCaptureEnabled = true,
    this.exportPdfEnabled = true,
    this.analyticsEnabled = true,
    this.rateLimitSmsParser = true,
    this.enableAi = true,
    this.enableAds = true,
    this.enableExports = true,
    this.enableNotifications = true,
    this.enableSmsCapture = true,
    this.enableBackup = false,
    this.enableSync = true,
    this.killSwitchEnabled = false,
    this.killSwitchMessage = '',
    this.minimumAppVersion = '0.0.0',
    this.maxTransactionsFreeTier = 500,
    this.maxTransactionsBasicTier = 5000,
    this.geminiConfidenceThreshold = 0.60,
    this.geminiModel = 'gemini-2.5-flash',
    this.debugMenuEnabled = false,
  });

  /// Whether Gemini AI features are enabled (legacy).
  final bool geminiEnabled;

  /// Whether SMS auto-capture is enabled (legacy).
  final bool smsAutoCaptureEnabled;

  /// Whether PDF export is enabled (legacy).
  final bool exportPdfEnabled;

  /// Whether analytics events are sent.
  final bool analyticsEnabled;

  /// Whether the SMS parser rate limiter is active.
  final bool rateLimitSmsParser;

  /// Master toggle for all AI/ML features.
  final bool enableAi;

  /// Master toggle for all advertisements.
  final bool enableAds;

  /// Master toggle for all export features (PDF, CSV, etc.).
  final bool enableExports;

  /// Master toggle for push and local notifications.
  final bool enableNotifications;

  /// Master toggle for SMS auto-capture.
  final bool enableSmsCapture;

  /// Master toggle for cloud backup/restore.
  final bool enableBackup;

  /// Master toggle for Firestore real-time sync.
  final bool enableSync;

  /// Master kill switch — when true the app shows a maintenance screen.
  final bool killSwitchEnabled;

  /// If non-empty, show a kill-switch dialog with this message and prevent
  /// usage.
  final String killSwitchMessage;

  /// Minimum required app version. If the installed version is less, show
  /// a forced update dialog.
  final String minimumAppVersion;

  /// Maximum transactions for FREE tier users.
  final int maxTransactionsFreeTier;

  /// Maximum transactions for BASIC tier users.
  final int maxTransactionsBasicTier;

  /// Confidence threshold below which Gemini results require user confirmation.
  final double geminiConfidenceThreshold;

  /// Gemini model id used by voice/OCR parsers. Remote-configurable so a
  /// model retirement (gemini-1.5-flash died in 2025) can be fixed without
  /// shipping a new APK.
  final String geminiModel;

  /// Whether debug tools (like the Flutter dev overlay) are available.
  final bool debugMenuEnabled;
}

/// Singleton service wrapping Firebase Remote Config with type-safe access,
/// caching, and offline default to [FeatureFlags] defaults.
///
/// Usage:
/// ```dart
/// await RemoteConfigService.instance.ensureInitialized();
/// final flags = RemoteConfigService.instance.flags;
/// if (flags.geminiEnabled) { ... }
/// ```
class RemoteConfigService {
  RemoteConfigService._();

  static final RemoteConfigService instance = RemoteConfigService._();

  bool _initialized = false;
  FirebaseRemoteConfig? _remoteConfig;
  FeatureFlags _flags = const FeatureFlags();

  /// Fetch interval. In debug, always fetch; in release, every 4 hours.
  Duration get _fetchInterval =>
      kDebugMode ? const Duration(minutes: 0) : const Duration(hours: 4);

  /// Whether the service has been initialized.
  bool get isInitialized => _initialized;

  /// Current feature flags (always returns the latest activated values).
  FeatureFlags get flags => _flags;

  /// Initialize Remote Config with defaults and fetch activation.
  Future<void> ensureInitialized() async {
    if (_initialized) return;

    try {
      _remoteConfig = FirebaseRemoteConfig.instance;

      await _remoteConfig!.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: _fetchInterval,
        ),
      );

      await _remoteConfig!.setDefaults(const {
        'gemini_enabled': true,
        'sms_auto_capture_enabled': true,
        'export_pdf_enabled': true,
        'analytics_enabled': true,
        'rate_limit_sms_parser': true,
        'enable_ai': true,
        'enable_ads': true,
        'enable_exports': true,
        'enable_notifications': true,
        'enable_sms_capture': true,
        'enable_backup': false,
        'enable_sync': true,
        'kill_switch_enabled': false,
        'kill_switch_message': '',
        'minimum_app_version': '0.0.0',
        'max_transactions_free_tier': 500,
        'max_transactions_basic_tier': 5000,
        'gemini_confidence_threshold': 0.60,
        'gemini_model': 'gemini-2.5-flash',
        'debug_menu_enabled': false,
      });

      await _remoteConfig!.fetchAndActivate();
      _applyConfig();
      _initialized = true;

      AppLogger.info(
        'Remote Config initialized',
        function: 'RemoteConfigService.ensureInitialized',
        extra: {'flags': _flags.toString()},
      );
    } catch (e, s) {
      AppLogger.error(
        'Remote Config initialization failed (using defaults)',
        function: 'RemoteConfigService.ensureInitialized',
        error: e,
        stackTrace: s,
      );
      _initialized = true; // continue with defaults
    }
  }

  /// Manually fetch and activate new config values (e.g., pull-to-refresh).
  Future<void> refresh() async {
    if (_remoteConfig == null) return;
    try {
      await _remoteConfig!.fetchAndActivate();
      _applyConfig();
    } catch (e) {
      AppLogger.warning('Remote Config refresh failed');
    }
  }

  void _applyConfig() {
    final rc = _remoteConfig!;
    _flags = FeatureFlags(
      geminiEnabled: rc.getBool('gemini_enabled'),
      smsAutoCaptureEnabled: rc.getBool('sms_auto_capture_enabled'),
      exportPdfEnabled: rc.getBool('export_pdf_enabled'),
      analyticsEnabled: rc.getBool('analytics_enabled'),
      rateLimitSmsParser: rc.getBool('rate_limit_sms_parser'),
      enableAi: rc.getBool('enable_ai'),
      enableAds: rc.getBool('enable_ads'),
      enableExports: rc.getBool('enable_exports'),
      enableNotifications: rc.getBool('enable_notifications'),
      enableSmsCapture: rc.getBool('enable_sms_capture'),
      enableBackup: rc.getBool('enable_backup'),
      enableSync: rc.getBool('enable_sync'),
      killSwitchEnabled: rc.getBool('kill_switch_enabled'),
      killSwitchMessage: rc.getString('kill_switch_message'),
      minimumAppVersion: rc.getString('minimum_app_version'),
      maxTransactionsFreeTier: rc.getInt('max_transactions_free_tier'),
      maxTransactionsBasicTier: rc.getInt('max_transactions_basic_tier'),
      geminiConfidenceThreshold: rc.getDouble('gemini_confidence_threshold'),
      geminiModel: rc.getString('gemini_model').isEmpty
          ? 'gemini-2.5-flash'
          : rc.getString('gemini_model'),
      debugMenuEnabled: rc.getBool('debug_menu_enabled'),
    );
  }
}
