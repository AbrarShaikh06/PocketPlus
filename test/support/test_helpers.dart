import 'package:flutter/material.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';

/// Wraps a screen in a [MaterialApp] configured with the app's localization
/// delegates and supported locales, so `AppLocalizations.of(context)` resolves
/// in widget tests instead of throwing a null-check error.
Widget testApp(Widget home) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
    builder: disableTestAnimations,
  );
}

/// Disables animations in widget tests. Several widgets (AnimatedFab,
/// AnimatedCounter) honor [MediaQueryData.disableAnimations] by rendering their
/// final/static state. This both stops perpetual animations (which make
/// pumpAndSettle hang) and lets counters show their final value immediately.
/// Use directly as a [MaterialApp.builder] for router-based test apps.
Widget disableTestAnimations(BuildContext context, Widget? child) {
  return MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: true),
    child: child!,
  );
}
