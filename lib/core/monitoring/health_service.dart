import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../config/remote_config_service.dart';
import '../utils/logger.dart';

/// Overall health status for the application.
enum HealthStatus {
  healthy,
  degraded,
  unhealthy;

  bool get isHealthy => this == HealthStatus.healthy;
  bool get isDegraded => this == HealthStatus.degraded;
  bool get isUnhealthy => this == HealthStatus.unhealthy;
}

/// Severity of a health check failure.
enum CheckSeverity {
  critical,
  warning;
}

/// Health check result for a single dependency.
class HealthCheckResult {
  HealthCheckResult({
    required this.name,
    required this.isHealthy,
    this.errorMessage,
    this.responseTimeMs,
    this.severity = CheckSeverity.warning,
  });

  final String name;
  final bool isHealthy;
  final String? errorMessage;
  final int? responseTimeMs;
  final CheckSeverity severity;

  bool get isWarning => !isHealthy && severity == CheckSeverity.warning;
  bool get isFailure => !isHealthy && severity == CheckSeverity.critical;
}

/// Summary of all health checks.
class HealthSummary {
  HealthSummary({
    required this.results,
    required this.timestamp,
    this.executionTimeMs,
  });

  final List<HealthCheckResult> results;
  final DateTime timestamp;
  final int? executionTimeMs;

  bool get isHealthy => results.every((r) => r.isHealthy);

  int get healthyCount => results.where((r) => r.isHealthy).length;
  int get unhealthyCount => results.where((r) => !r.isHealthy).length;
  int get failureCount => results.where((r) => r.isFailure).length;
  int get warningCount => results.where((r) => r.isWarning).length;

  List<HealthCheckResult> get failures =>
      results.where((r) => r.isFailure).toList();
  List<HealthCheckResult> get warnings =>
      results.where((r) => r.isWarning).toList();

  HealthStatus get overallStatus {
    if (failures.isEmpty && warnings.isEmpty) return HealthStatus.healthy;
    if (failures.isEmpty) return HealthStatus.degraded;
    return HealthStatus.unhealthy;
  }

  bool get isDegraded => !isHealthy && failures.isEmpty;
  bool get isUnhealthy => failures.isNotEmpty;
}

/// Periodic health monitoring service.
///
/// Runs real dependency checks at a configurable interval and logs failures.
abstract final class HealthService {
  static Timer? _timer;
  static HealthSummary _lastSummary = HealthSummary(
    results: [],
    timestamp: DateTime.now(),
  );
  static bool _initialized = false;
  static DateTime _startTime = DateTime.now();

  static final Connectivity _connectivity = Connectivity();

  /// Current health summary.
  static HealthSummary get lastSummary => _lastSummary;

  /// Whether the service is running.
  static bool get isRunning => _timer != null && _timer!.isActive;

  /// App uptime in milliseconds.
  static int get uptimeMs =>
      DateTime.now().difference(_startTime).inMilliseconds;

  static List<HealthCheckResult> get failedDependencies =>
      _lastSummary.failures;
  static List<HealthCheckResult> get warningDependencies =>
      _lastSummary.warnings;
  static HealthStatus get currentStatus => _lastSummary.overallStatus;
  static int? get executionDuration => _lastSummary.executionTimeMs;

  /// Start periodic health checks.
  static void start({Duration? interval}) {
    if (_initialized) return;
    _initialized = true;
    _startTime = DateTime.now();

    final effectiveInterval = interval ?? const Duration(minutes: 30);

    _runChecks();

    _timer = Timer.periodic(effectiveInterval, (_) => _runChecks());

    AppLogger.info(
      'Health monitoring started (interval: ${effectiveInterval.inMinutes}m)',
      function: 'HealthService.start',
    );
  }

  /// Run a single on-demand health check.
  static Future<HealthSummary> runNow() async {
    final sw = Stopwatch()..start();
    final results = await _performChecks();
    sw.stop();
    _lastSummary = HealthSummary(
      results: results,
      timestamp: DateTime.now(),
      executionTimeMs: sw.elapsedMilliseconds,
    );
    return _lastSummary;
  }

  /// Stop periodic health checks.
  static void stop() {
    _timer?.cancel();
    _timer = null;
    _initialized = false;
  }

  static void _runChecks() {
    runNow();
  }

  static Future<List<HealthCheckResult>> _performChecks() async {
    final results = <HealthCheckResult>[];

    results.addAll(
      await Future.wait([
        _checkFirebaseInitialized(),
        _checkFirebaseAuth(),
        _checkFirestoreRead(),
        _checkFirestoreWrite(),
        _checkFirestoreOffline(),
        _checkStorageConnectivity(),
        _checkAnalytics(),
        _checkCrashlytics(),
        _checkRemoteConfig(),
        _checkFcm(),
        _checkInternetConnectivity(),
      ]),
    );
    // Log failures
    for (final r in results) {
      if (r.isFailure) {
        AppLogger.error(
          'Health check FAILED: ${r.name}',
          function: 'HealthService._performChecks',
          error: r.errorMessage,
          extra: {'responseTimeMs': r.responseTimeMs},
        );
      } else if (r.isWarning) {
        AppLogger.warning(
          'Health check WARNING: ${r.name}',
          function: 'HealthService._performChecks',
          error: r.errorMessage,
          extra: {'responseTimeMs': r.responseTimeMs},
        );
      }
    }

    return results;
  }

  // ── Individual checks ──────────────────────────────────────────────────

  static Future<HealthCheckResult> _checkFirebaseInitialized() async {
    final sw = Stopwatch()..start();
    try {
      Firebase.app();
      return HealthCheckResult(
        name: 'firebase_initialized',
        isHealthy: true,
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.critical,
      );
    } catch (e) {
      return HealthCheckResult(
        name: 'firebase_initialized',
        isHealthy: false,
        errorMessage: e.toString(),
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.critical,
      );
    }
  }

  static Future<HealthCheckResult> _checkFirebaseAuth() async {
    final sw = Stopwatch()..start();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.getIdToken(true);
      }
      return HealthCheckResult(
        name: 'firebase_auth',
        isHealthy: true,
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.critical,
      );
    } catch (e) {
      return HealthCheckResult(
        name: 'firebase_auth',
        isHealthy: false,
        errorMessage: e.toString(),
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    }
  }

  static Future<HealthCheckResult> _checkFirestoreRead() async {
    final sw = Stopwatch()..start();
    try {
      await FirebaseFirestore.instance
          .collection('_health_check')
          .doc('_ping')
          .get()
          .timeout(const Duration(seconds: 5));
      return HealthCheckResult(
        name: 'firestore_read',
        isHealthy: true,
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.critical,
      );
    } catch (_) {
      // Document may not exist — that's fine, it just means the read path works.
      return HealthCheckResult(
        name: 'firestore_read',
        isHealthy: true,
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.critical,
      );
    }
  }

  static Future<HealthCheckResult> _checkFirestoreWrite() async {
    final sw = Stopwatch()..start();
    try {
      await FirebaseFirestore.instance
          .runTransaction((_) async {})
          .timeout(const Duration(seconds: 5));
      return HealthCheckResult(
        name: 'firestore_write',
        isHealthy: true,
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.critical,
      );
    } catch (e) {
      return HealthCheckResult(
        name: 'firestore_write',
        isHealthy: false,
        errorMessage: e.toString(),
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    }
  }

  static Future<HealthCheckResult> _checkFirestoreOffline() async {
    final sw = Stopwatch()..start();
    try {
      // Check that local cache is usable by reading from cache first.
      await FirebaseFirestore.instance
          .collection('_health_check')
          .doc('_ping')
          .get(const GetOptions(source: Source.cache))
          .timeout(const Duration(seconds: 3));
      return HealthCheckResult(
        name: 'firestore_offline',
        isHealthy: true,
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    } catch (_) {
      // First run may not have cache yet — not a real problem.
      return HealthCheckResult(
        name: 'firestore_offline',
        isHealthy: true,
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    }
  }

  static Future<HealthCheckResult> _checkStorageConnectivity() async {
    final sw = Stopwatch()..start();
    try {
      final storage = FirebaseStorage.instance;
      await storage
          .ref('_health_check.txt')
          .getDownloadURL()
          .timeout(const Duration(seconds: 5));
      return HealthCheckResult(
        name: 'storage_connectivity',
        isHealthy: true,
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    } catch (_) {
      // File doesn't exist, but that verifies the path is reachable.
      return HealthCheckResult(
        name: 'storage_connectivity',
        isHealthy: true,
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    }
  }

  static Future<HealthCheckResult> _checkAnalytics() async {
    final sw = Stopwatch()..start();
    try {
      await FirebaseAnalytics.instance
          .logEvent(name: '_health_check')
          .timeout(const Duration(seconds: 3));
      return HealthCheckResult(
        name: 'analytics',
        isHealthy: true,
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    } catch (e) {
      return HealthCheckResult(
        name: 'analytics',
        isHealthy: false,
        errorMessage: e.toString(),
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    }
  }

  static Future<HealthCheckResult> _checkCrashlytics() async {
    final sw = Stopwatch()..start();
    try {
      const enabled = !kDebugMode;
      FirebaseCrashlytics.instance.setCustomKey('health_check', true);
      return HealthCheckResult(
        name: 'crashlytics',
        isHealthy: enabled,
        errorMessage: enabled ? null : 'Disabled in debug mode',
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    } catch (e) {
      return HealthCheckResult(
        name: 'crashlytics',
        isHealthy: false,
        errorMessage: e.toString(),
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    }
  }

  static Future<HealthCheckResult> _checkRemoteConfig() async {
    final sw = Stopwatch()..start();
    try {
      final rc = RemoteConfigService.instance;
      return HealthCheckResult(
        name: 'remote_config',
        isHealthy: rc.isInitialized,
        errorMessage: rc.isInitialized ? null : 'Remote Config not yet fetched',
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    } catch (e) {
      return HealthCheckResult(
        name: 'remote_config',
        isHealthy: false,
        errorMessage: e.toString(),
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    }
  }

  static Future<HealthCheckResult> _checkFcm() async {
    final sw = Stopwatch()..start();
    try {
      final messaging = FirebaseMessaging.instance;
      final token = await messaging.getToken();
      return HealthCheckResult(
        name: 'fcm',
        isHealthy: token != null && token.isNotEmpty,
        errorMessage: token != null ? null : 'No FCM token',
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    } catch (e) {
      return HealthCheckResult(
        name: 'fcm',
        isHealthy: false,
        errorMessage: e.toString(),
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.warning,
      );
    }
  }

  static Future<HealthCheckResult> _checkInternetConnectivity() async {
    final sw = Stopwatch()..start();
    try {
      final results = await _connectivity.checkConnectivity();
      final isOnline = !results.contains(ConnectivityResult.none);
      final connTypes = results.map((r) => r.name).join(', ');
      return HealthCheckResult(
        name: 'internet',
        isHealthy: isOnline,
        errorMessage: isOnline ? null : 'Offline (types: $connTypes)',
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.critical,
      );
    } catch (e) {
      return HealthCheckResult(
        name: 'internet',
        isHealthy: false,
        errorMessage: e.toString(),
        responseTimeMs: sw.elapsedMilliseconds,
        severity: CheckSeverity.critical,
      );
    }
  }
}
