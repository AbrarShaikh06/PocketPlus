import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography scale from Engineering Spec B1.2 — updated with display face pairing.
///
/// Display / Title styles use **Plus Jakarta Sans** (characterful, geometric).
/// Body / Label styles use **Noto Sans** (disciplined, Indic-script support).
///
/// Font sizes respect [MediaQuery.textScalerOf] when applied via [Text] widgets.
abstract final class AppTextStyles {
  static const String _bodyFamily = 'Noto Sans';
  static const String _displayFamily = 'Plus Jakarta Sans';
  static const String _codeFamily = 'Courier New';

  // ── Display / Hero ───────────────────────────────────────────────────────

  static TextStyle displayHero(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: _displayFamily,
      fontSize: 40,
      fontWeight: FontWeight.w800,
      color: color ?? AppColors.primary,
    );
  }

  static TextStyle displayLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: _displayFamily,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.primary,
    );
  }

  static TextStyle titleLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: _displayFamily,
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: color ?? AppColors.primary,
    );
  }

  static TextStyle titleMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: _displayFamily,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.primary,
    );
  }

  // ── Body / Label (Noto Sans — Indic-script safe) ─────────────────────────

  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: _bodyFamily,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.onSurface,
    );
  }

  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: _bodyFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.onSurface,
    );
  }

  static TextStyle labelLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: _bodyFamily,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.onSurface,
    );
  }

  static TextStyle labelSmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: _bodyFamily,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.onSurfaceMuted,
    );
  }

  static TextStyle codeFont(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: _codeFamily,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.onSurface,
    );
  }
}
