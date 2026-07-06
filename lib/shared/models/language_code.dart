import 'package:flutter/material.dart';

enum LanguageCode {
  en,
  hi,
  mr,
  ar,
  sw,
}

extension LanguageCodeX on LanguageCode {
  String get firestoreValue => name.toUpperCase();

  Locale get flutterLocale {
    switch (this) {
      case LanguageCode.ar:
        return const Locale('ar');
      case LanguageCode.hi:
        return const Locale('hi');
      case LanguageCode.mr:
        return const Locale('mr');
      case LanguageCode.sw:
        return const Locale('sw');
      default:
        return const Locale('en');
    }
  }

  String get displayLabel => switch (this) {
        LanguageCode.en => 'English',
        LanguageCode.hi => 'Hindi',
        LanguageCode.mr => 'Marathi',
        LanguageCode.ar => 'العربية',
        LanguageCode.sw => 'Kiswahili',
      };

  static LanguageCode fromFirestore(String value) {
    return LanguageCode.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => LanguageCode.en,
    );
  }
}
