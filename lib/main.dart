import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:workmanager/workmanager.dart';

import 'core/bootstrap/firebase_bootstrap.dart';
import 'core/config/remote_config_service.dart';
import 'core/config/rollback_service.dart';
import 'core/errors/error_monitor.dart';
import 'core/monitoring/health_service.dart';
import 'core/notifications/background_budget_task.dart';
import 'core/notifications/fcm_service.dart';
import 'core/notifications/local_notification_service.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';
import 'features/sms_capture/data/sms_capture_service.dart';
import 'shared/providers/locale_provider.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(budgetCheckCallback);
  await FirebaseBootstrap.initialize();

  await AppLogger.init();
  AppLogger.generateSessionId();

  await RemoteConfigService.instance.ensureInitialized();
  await RollbackService.evaluate();

  try {
    await GoogleSignIn.instance.initialize();
  } catch (e) {
    AppLogger.warning(
      'Google Sign-In initialization failed',
      function: 'main',
      error: e,
    );
  }

  await LocalNotificationService.init();
  await FcmService.init();
  unawaited(MobileAds.instance.initialize());

  Workmanager().registerPeriodicTask(
    'com.pocketplus.budget_check',
    'budgetBackgroundCheck',
    frequency: const Duration(hours: 1),
    constraints: Constraints(networkType: NetworkType.notRequired),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    backoffPolicy: BackoffPolicy.linear,
    initialDelay: const Duration(minutes: 15),
  );

  HealthService.start();
  RollbackService.watchConfigChanges();

  ErrorMonitor.initialize(
    () => runApp(const ProviderScope(child: PocketPlusApp())),
  );
}

/// Root application widget.
class PocketPlusApp extends ConsumerStatefulWidget {
  const PocketPlusApp({super.key});

  @override
  ConsumerState<PocketPlusApp> createState() => _PocketPlusAppState();
}

class _PocketPlusAppState extends ConsumerState<PocketPlusApp> {
  @override
  Widget build(BuildContext context) {
    ref.watch(smsCaptureServiceProvider);

    final router = ref.watch(appRouterProvider);
    final locale = ref.watch(localeProvider);
    FcmService.setRouter(router);

    return MaterialApp.router(
      title: 'PocketPlus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: (context, child) {
        return Directionality(
          textDirection: locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}
