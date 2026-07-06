import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

/// Log levels ordered by severity.
enum LogLevel {
  debug(0),
  info(1),
  warning(2),
  error(3),
  fatal(4);

  const LogLevel(this.severity);
  final int severity;

  String get label => name.toUpperCase();
}

/// Structured log entry for JSON serialization.
class LogEntry {
  LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.userId,
    this.sessionId,
    this.screen,
    this.function,
    this.appVersion,
    this.environment,
    this.platform,
    this.stackTrace,
    this.exception,
    this.extra,
  });

  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? userId;
  final String? sessionId;
  final String? screen;
  final String? function;
  final String? appVersion;
  final String? environment;
  final String? platform;
  final String? stackTrace;
  final String? exception;
  final Map<String, dynamic>? extra;

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'level': level.label,
        'message': message,
        if (userId != null) 'userId': userId,
        if (sessionId != null) 'sessionId': sessionId,
        if (screen != null) 'screen': screen,
        if (function != null) 'function': function,
        if (appVersion != null) 'appVersion': appVersion,
        if (environment != null) 'environment': environment,
        if (platform != null) 'platform': platform,
        if (stackTrace != null) 'stackTrace': stackTrace,
        if (exception != null) 'exception': exception,
        if (extra != null) 'extra': extra,
      };

  @override
  String toString() {
    final sb = StringBuffer('[$timestamp] [${level.label}] $message');
    if (screen != null) sb.write(' | screen: $screen');
    if (function != null) sb.write(' | fn: $function');
    if (exception != null) sb.write(' | error: $exception');
    return sb.toString();
  }
}

/// Centralized structured logger with JSON output, Crashlytics bridge, and
/// automatic context (user, session, screen, environment, platform).
///
/// Usage:
/// ```dart
/// AppLogger.info('Transaction saved', function: 'saveTx');
/// AppLogger.error('Firestore write failed', exception: e, stackTrace: s);
/// ```
///
/// ERROR and FATAL levels always record to Crashlytics.
/// DEBUG and INFO are suppressed in release builds.
abstract final class AppLogger {
  static String? _userId;
  static String? _sessionId;
  static String _appVersion = 'unknown';
  static String _environment = 'development';
  static String _platform = 'unknown';

  /// Initialize logger with app metadata. Call once at startup.
  static Future<void> init() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _appVersion = '${info.version}+${info.buildNumber}';
    } catch (_) {
      _appVersion = 'unknown';
    }

    _environment = kReleaseMode
        ? 'production'
        : kProfileMode
            ? 'staging'
            : 'development';

    try {
      if (Platform.isAndroid) {
        _platform = 'android';
      } else if (Platform.isIOS) {
        _platform = 'ios';
      } else if (Platform.isMacOS) {
        _platform = 'macos';
      } else if (Platform.isWindows) {
        _platform = 'windows';
      } else if (Platform.isLinux) {
        _platform = 'linux';
      }
    } catch (_) {
      _platform = 'unknown';
    }
  }

  /// Set the current authenticated user ID (for Crashlytics + log context).
  static void setUser(String? userId) {
    _userId = userId;
    if (userId != null && !kDebugMode) {
      FirebaseCrashlytics.instance.setUserIdentifier(userId);
    }
  }

  /// Set a custom key on Crashlytics for the current session.
  static void setCrashlyticsKey(String key, String value) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.setCustomKey(key, value);
    }
  }

  /// Generate a unique session ID for the app lifecycle.
  static String generateSessionId() {
    _sessionId =
        'ses_${DateTime.now().millisecondsSinceEpoch}_${_userId ?? 'anon'}';
    return _sessionId!;
  }

  static String? get sessionId => _sessionId;
  static String get environment => _environment;
  static String get appVersion => _appVersion;
  static String get platform => _platform;
  static String? get userId => _userId;

  // ── Logging methods ──────────────────────────────────────────────────────

  static void debug(
    String message, {
    String? screen,
    String? function,
    Object? error,
    Map<String, dynamic>? extra,
  }) {
    if (!kDebugMode) return;
    _log(
      LogLevel.debug,
      message,
      screen: screen,
      function: function,
      error: error,
      extra: extra,
    );
  }

  static void info(
    String message, {
    String? screen,
    String? function,
    Object? error,
    Map<String, dynamic>? extra,
  }) {
    if (!kDebugMode) return;
    _log(
      LogLevel.info,
      message,
      screen: screen,
      function: function,
      error: error,
      extra: extra,
    );
  }

  static void warning(
    String message, {
    String? screen,
    String? function,
    Object? error,
    Map<String, dynamic>? extra,
  }) {
    _log(
      LogLevel.warning,
      message,
      screen: screen,
      function: function,
      error: error,
      extra: extra,
    );
  }

  static void error(
    String message, {
    String? screen,
    String? function,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    _log(
      LogLevel.error,
      message,
      screen: screen,
      function: function,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );
  }

  static void fatal(
    String message, {
    String? screen,
    String? function,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    _log(
      LogLevel.fatal,
      message,
      screen: screen,
      function: function,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );
  }

  // ── Internal ─────────────────────────────────────────────────────────────

  static void _log(
    LogLevel level,
    String message, {
    String? screen,
    String? function,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      userId: _userId,
      sessionId: _sessionId,
      screen: screen,
      function: function,
      appVersion: _appVersion,
      environment: _environment,
      platform: _platform,
      stackTrace: stackTrace?.toString(),
      exception: error?.toString(),
      extra: extra,
    );

    // Console output
    final line = level.severity >= LogLevel.warning.severity
        ? entry.toString()
        : '[${level.label}] $message';
    debugPrint(line);

    // Crashlytics bridge (release only)
    if (!kDebugMode) {
      _bridgeToCrashlytics(entry);
    }
  }

  static void _bridgeToCrashlytics(LogEntry entry) {
    final crashlytics = FirebaseCrashlytics.instance;

    if (entry.level == LogLevel.fatal) {
      final err = entry.exception != null
          ? Exception(entry.exception)
          : Exception(entry.message);
      final stack = entry.stackTrace != null
          ? StackTrace.fromString(entry.stackTrace!)
          : StackTrace.current;
      crashlytics.recordError(err, stack, fatal: true);
    } else if (entry.level == LogLevel.error) {
      crashlytics.recordError(
        Exception(entry.exception ?? entry.message),
        entry.stackTrace != null
            ? StackTrace.fromString(entry.stackTrace!)
            : StackTrace.current,
        fatal: false,
      );
    } else {
      crashlytics.log(entry.toString());
    }
  }
}
