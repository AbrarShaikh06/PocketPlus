import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/logger.dart';

/// Centralized error monitoring that captures Flutter errors, async exceptions,
/// Riverpod errors, and platform errors — all with user/screen context.
///
/// Call [initialize] once at startup (after Firebase is ready).
abstract final class ErrorMonitor {
  static bool _initialized = false;

  /// Current screen name for error context.
  static String _currentScreen = 'unknown';

  /// Current route path for error context.
  static String _currentRoute = 'unknown';

  /// Provider observer for capturing ProviderExceptions.
  static RiverpodErrorObserver? _riverpodObserver;

  /// Initialize all global error handlers.
  ///
  /// [appRunner] must call `runApp()` inside the zone so all async errors
  /// are captured.
  static void initialize(void Function() appRunner) {
    if (_initialized) return;
    _initialized = true;

    FlutterError.onError = _onFlutterError;
    PlatformDispatcher.instance.onError = _onPlatformError;

    runZonedGuarded(appRunner, _onZoneError);
  }

  /// Set current screen for error context.
  static void setCurrentScreen(String screen, {String? route}) {
    _currentScreen = screen;
    if (route != null) _currentRoute = route;
    AppLogger.setCrashlyticsKey('current_screen', screen);
    if (route != null) AppLogger.setCrashlyticsKey('current_route', route);
  }

  /// Get the Riverpod provider observer for capturing ProviderExceptions.
  static RiverpodErrorObserver get riverpodObserver =>
      _riverpodObserver ??= RiverpodErrorObserver();

  static String get currentScreen => _currentScreen;
  static String get currentRoute => _currentRoute;

  // ── Error handlers ──────────────────────────────────────────────────────

  static void _onFlutterError(FlutterErrorDetails details) {
    final contextMsg = details.context?.toDescription() ?? 'unknown';
    final stack = details.stack ?? StackTrace.current;

    AppLogger.error(
      details.exceptionAsString(),
      screen: _currentScreen,
      function: 'FlutterError.onError',
      error: details.exception,
      stackTrace: stack,
      extra: {'context': contextMsg, 'silent': details.silent},
    );

    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
  }

  static bool _onPlatformError(Object error, StackTrace stack) {
    AppLogger.fatal(
      'Platform unhandled error',
      screen: _currentScreen,
      function: 'PlatformDispatcher.onError',
      error: error,
      stackTrace: stack,
    );
    return true;
  }

  static void _onZoneError(Object error, StackTrace stack) {
    AppLogger.fatal(
      'Unhandled zone error',
      screen: _currentScreen,
      function: 'runZonedGuarded',
      error: error,
      stackTrace: stack,
    );
  }
}

/// Riverpod [ProviderObserver] that captures ProviderExceptions and logs them.
base class RiverpodErrorObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    AppLogger.error(
      'Provider error: ${context.provider.name ?? context.provider.runtimeType}',
      screen: ErrorMonitor.currentScreen,
      function: 'Riverpod.${context.provider.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Mixin for [ConsumerState] widgets to automatically track screen name for
/// error context.
///
/// ```dart
/// class MyScreen extends ConsumerState<MyScreenWidget> with ScreenTracker {
///   @override String get screenName => 'MyScreen';
/// }
/// ```
mixin ScreenTracker<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  String get screenName;

  @override
  void initState() {
    super.initState();
    ErrorMonitor.setCurrentScreen(screenName);
  }
}
