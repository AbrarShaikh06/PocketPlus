import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Global Material theme using PocketPlus design tokens.
abstract final class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.primaryDark,
        error: AppColors.error,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        outline: AppColors.outline,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      cardColor: AppColors.card,
      dividerColor: AppColors.outline,
      textTheme: _buildTextTheme(AppColors.onSurface),
    );
  }

  static ThemeData dark() {
    const darkSurface = Color(0xFF121212);
    const darkCard = Color(0xFF1E1E1E);
    const darkOnSurface = Color(0xFFE0E0E0);
    const darkOutline = Color(0xFF424242);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.primaryDark,
        error: AppColors.error,
        surface: darkSurface,
        onSurface: darkOnSurface,
        outline: darkOutline,
      ),
      scaffoldBackgroundColor: darkSurface,
      cardColor: darkCard,
      dividerColor: darkOutline,
      textTheme: _buildTextTheme(darkOnSurface),
    );
  }

  static TextTheme _buildTextTheme(Color color) {
    const primary = AppColors.primary;
    return TextTheme(
      displayLarge: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 57,
        fontWeight: FontWeight.w800,
        color: primary,
      ),
      displayMedium: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      displaySmall: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineLarge: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineMedium: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      headlineSmall: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleLarge: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      titleMedium: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Noto Sans',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Noto Sans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Noto Sans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Noto Sans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Noto Sans',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Noto Sans',
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}
