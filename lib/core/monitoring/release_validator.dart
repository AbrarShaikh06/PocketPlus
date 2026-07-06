import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../config/remote_config_service.dart';
import '../utils/logger.dart';
import 'health_service.dart';

/// Status of a single release validation check.
class ValidationCheck {
  ValidationCheck({
    required this.name,
    required this.passed,
    this.message,
  });

  final String name;
  final bool passed;
  final String? message;
}

/// Complete release validation result.
class ValidationReport {
  ValidationReport({
    required this.checks,
    required this.allPassed,
    required this.timestamp,
  });

  final List<ValidationCheck> checks;
  final bool allPassed;
  final DateTime timestamp;

  int get passedCount => checks.where((c) => c.passed).length;
  int get failedCount => checks.where((c) => !c.passed).length;

  List<ValidationCheck> get failures => checks.where((c) => !c.passed).toList();
}

/// Pre-release validator that checks all production dependencies are ready.
///
/// Call [validate] before tagging a release. Returns a detailed report of
/// every validation check.
abstract final class ReleaseValidator {
  /// Run all pre-release validation checks.
  static Future<ValidationReport> validate() async {
    AppLogger.info('Running release validation...',
        function: 'ReleaseValidator.validate');

    final checks = <ValidationCheck>[];

    checks.add(await _checkFirebaseInitialized());
    checks.add(await _checkCrashlyticsActive());
    checks.add(await _checkAnalyticsActive());
    checks.add(await _checkRemoteConfigLoaded());
    checks.add(await _checkFeatureFlagsLoaded());
    checks.add(await _checkHealthChecksPassing());
    checks.add(await _checkLoggingActive());
    checks.add(await _checkNotificationsConfigured());
    checks.add(await _checkFirestoreReachable());
    checks.add(await _checkFcmConfigured());

    final allPassed = checks.every((c) => c.passed);

    final report = ValidationReport(
      checks: checks,
      allPassed: allPassed,
      timestamp: DateTime.now(),
    );

    if (allPassed) {
      AppLogger.info(
        'Release validation PASSED (${checks.length}/${checks.length})',
        function: 'ReleaseValidator.validate',
      );
    } else {
      final failed =
          report.failures.map((f) => '${f.name}: ${f.message}').join('; ');
      AppLogger.error(
        'Release validation FAILED: $failed',
        function: 'ReleaseValidator.validate',
        extra: {'failedCount': report.failedCount, 'total': checks.length},
      );
    }

    return report;
  }

  static Future<ValidationCheck> _checkFirebaseInitialized() async {
    try {
      Firebase.app();
      return ValidationCheck(
        name: 'Firebase initialized',
        passed: true,
      );
    } catch (e) {
      return ValidationCheck(
        name: 'Firebase initialized',
        passed: false,
        message: e.toString(),
      );
    }
  }

  static Future<ValidationCheck> _checkCrashlyticsActive() async {
    try {
      if (kDebugMode) {
        return ValidationCheck(
          name: 'Crashlytics active',
          passed: true,
          message: 'Skipped in debug mode',
        );
      }
      FirebaseCrashlytics.instance.setCustomKey('release_validate', true);
      return ValidationCheck(
        name: 'Crashlytics active',
        passed: true,
      );
    } catch (e) {
      return ValidationCheck(
        name: 'Crashlytics active',
        passed: false,
        message: e.toString(),
      );
    }
  }

  static Future<ValidationCheck> _checkAnalyticsActive() async {
    try {
      await FirebaseAnalytics.instance
          .logEvent(name: '_release_validation')
          .timeout(const Duration(seconds: 3));
      return ValidationCheck(name: 'Analytics active', passed: true);
    } catch (e) {
      return ValidationCheck(
        name: 'Analytics active',
        passed: false,
        message: e.toString(),
      );
    }
  }

  static Future<ValidationCheck> _checkRemoteConfigLoaded() async {
    try {
      final rc = RemoteConfigService.instance;
      return ValidationCheck(
        name: 'Remote Config fetched',
        passed: rc.isInitialized,
        message: rc.isInitialized ? null : 'Not yet initialized',
      );
    } catch (e) {
      return ValidationCheck(
        name: 'Remote Config fetched',
        passed: false,
        message: e.toString(),
      );
    }
  }

  static Future<ValidationCheck> _checkFeatureFlagsLoaded() async {
    try {
      RemoteConfigService.instance.flags;
      return ValidationCheck(
        name: 'Feature flags loaded',
        passed: true,
      );
    } catch (e) {
      return ValidationCheck(
        name: 'Feature flags loaded',
        passed: false,
        message: e.toString(),
      );
    }
  }

  static Future<ValidationCheck> _checkHealthChecksPassing() async {
    try {
      final summary = HealthService.lastSummary;
      final passed = summary.isHealthy || summary.isDegraded;
      return ValidationCheck(
        name: 'Health checks passing',
        passed: passed,
        message: passed
            ? 'Status: ${summary.overallStatus.name}'
            : 'Unhealthy: ${summary.failures.map((f) => f.name).join(', ')}',
      );
    } catch (e) {
      return ValidationCheck(
        name: 'Health checks passing',
        passed: false,
        message: e.toString(),
      );
    }
  }

  static Future<ValidationCheck> _checkLoggingActive() async {
    try {
      AppLogger.info('Release validation log test');
      return ValidationCheck(name: 'Logging active', passed: true);
    } catch (e) {
      return ValidationCheck(
        name: 'Logging active',
        passed: false,
        message: e.toString(),
      );
    }
  }

  static Future<ValidationCheck> _checkNotificationsConfigured() async {
    try {
      await FirebaseMessaging.instance.getNotificationSettings();
      return ValidationCheck(
        name: 'Notifications configured',
        passed: true,
      );
    } catch (e) {
      return ValidationCheck(
        name: 'Notifications configured',
        passed: false,
        message: e.toString(),
      );
    }
  }

  static Future<ValidationCheck> _checkFirestoreReachable() async {
    try {
      await FirebaseFirestore.instance
          .collection('_health_check')
          .doc('_ping')
          .get()
          .timeout(const Duration(seconds: 5));
      return ValidationCheck(name: 'Firestore reachable', passed: true);
    } catch (e) {
      return ValidationCheck(
        name: 'Firestore reachable',
        passed: false,
        message: e.toString(),
      );
    }
  }

  static Future<ValidationCheck> _checkFcmConfigured() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      return ValidationCheck(
        name: 'FCM configured',
        passed: token != null,
        message: token == null ? 'No FCM token' : null,
      );
    } catch (e) {
      return ValidationCheck(
        name: 'FCM configured',
        passed: false,
        message: e.toString(),
      );
    }
  }
}
