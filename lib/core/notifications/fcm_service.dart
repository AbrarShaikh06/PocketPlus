import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

/// Firebase Cloud Messaging setup. Static so it can be initialised from
/// `main()` before the widget tree exists.
class FcmService {
  FcmService._();

  static GoRouter? _router;

  static Future<void> init() async {
    final messaging = FirebaseMessaging.instance;
    try {
      await messaging.requestPermission();
      await messaging.getToken();

      // Deep-link when a notification carrying a `route` is tapped.
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        final route = message.data['route'];
        if (route is String && route.isNotEmpty) {
          _router?.go(route);
        }
      });
    } catch (e) {
      debugPrint('FCM init failed: $e');
    }
  }

  static void setRouter(GoRouter router) {
    _router = router;
  }

  static Future<void> removeToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}
  }
}
