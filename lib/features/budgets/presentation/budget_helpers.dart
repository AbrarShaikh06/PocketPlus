import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class BudgetHelpers {
  static const List<String> brandColors = [
    '#0D3A35', // primary (Deep Verdigris)
    '#E2EBEA', // primaryLight
    '#062320', // primaryDark
    '#B71C1C', // error (Vermillion Red)
    '#E65100', // warning (Burnt Orange)
    '#1565C0', // source-blue
    '#4CAF50', // source-green
  ];

  static Color parseBudgetColor(String hex) {
    if (hex.isEmpty) return AppColors.primary;
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static IconData budgetIconData(String iconName) {
    return switch (iconName) {
      'restaurant' => Icons.restaurant,
      'directions_car' => Icons.directions_car,
      'home' => Icons.home,
      'shopping_cart' => Icons.shopping_cart,
      'flight' => Icons.flight,
      'local_gas_station' => Icons.local_gas_station,
      'medical_services' => Icons.medical_services,
      'school' => Icons.school,
      'work' => Icons.work,
      'sports_esports' => Icons.sports_esports,
      'subscriptions' => Icons.subscriptions,
      'movie' => Icons.movie,
      'checkroom' => Icons.checkroom,
      'pets' => Icons.pets,
      'fitness_center' => Icons.fitness_center,
      _ => Icons.account_balance_wallet,
    };
  }
}
