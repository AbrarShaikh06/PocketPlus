import 'package:flutter/widgets.dart';

enum TutorialRole {
  personal,
  business,
}

extension TutorialRoleX on TutorialRole {
  String get firestoreValue => name.toUpperCase();

  static TutorialRole fromString(String value) {
    switch (value.toUpperCase()) {
      case 'PERSONAL':
        return TutorialRole.personal;
      case 'BUSINESS':
        return TutorialRole.business;
      default:
        return TutorialRole.personal;
    }
  }
}

class TutorialStep {
  final GlobalKey key;
  final String title;
  final String description;
  final int stepNumber;

  const TutorialStep({
    required this.key,
    required this.title,
    required this.description,
    required this.stepNumber,
  });
}
