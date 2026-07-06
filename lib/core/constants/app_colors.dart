import 'package:flutter/material.dart';

/// Design tokens from Engineering Spec B1.1.
///
/// WCAG AA contrast, measured against [card] (#FFFFFF):
/// - [primary] (#0D3A35): 12.6:1 ✓ (AAA)
/// - [error] (#B71C1C): 6.6:1 ✓ (AA, AAA for large/bold)
/// - [onSurface] (#1B1C1C): 16.1:1 ✓ (AAA)
/// - [onSurfaceMuted] (#5A6657): 6.0:1 ✓ (AA; 5.6:1 on [surface])
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF0D3A35);
  static const Color primaryLight = Color(0xFFE2EBEA);
  static const Color primaryDark = Color(0xFF062320);
  static const Color secondary = Color(0xFF0D3A35);
  static const Color secondaryLight = Color(0xFFE2EBEA);

  // Semantic — income/expense
  static const Color income = primary;
  static const Color expense = error;

  // Feedback
  static const Color error = Color(0xFFB71C1C);
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color orange = Color(0xFFE65100);
  static const Color orangeLight = Color(0xFFFFF3E0);
  static const Color warning = orange;
  static const Color warningLight = orangeLight;
  static const Color blue = Color(0xFF1565C0);

  // Transaction-source accents — used to tint source badges/avatars.
  static const Color purple = Color(0xFF7B1FA2);
  static const Color teal = Color(0xFF00897B);
  static const Color indigo = Color(0xFF3949AB);
  static const Color green = Color(0xFF4CAF50);

  // Surfaces
  static const Color surface = Color(0xFFFBF6F0);
  static const Color card = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFFB1B7AB);

  // Text
  static const Color onSurface = Color(0xFF1B1C1C);
  static const Color onSurfaceMuted = Color(0xFF5A6657);
  static const Color onPrimary = Color(0xFFFFFFFF);
}
