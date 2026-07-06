import 'package:intl/intl.dart';

import '../../shared/models/profile_currency.dart';

/// All monetary values stored as smallest unit (integer paise/fils/cents).
/// Display only at UI layer.
abstract final class CurrencyFormatter {
  static String format(
    int amount, {
    String symbol = '\u20b9',
    String locale = 'en_IN',
    int decimalDigits = 2,
  }) {
    final value = amount / 100;
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(value);
  }

  static String formatWithProfile(int amount, ProfileCurrency currency) {
    return format(
      amount,
      symbol: currency.symbol,
      locale: currency.locale,
      decimalDigits: currency.decimalDigits,
    );
  }

  @Deprecated('Use format() with default params or formatWithProfile() instead')
  static String formatRupees(int paise) {
    return format(paise);
  }

  @Deprecated('Use formatWithProfile() with signed prefix instead')
  static String formatRupeesSigned(int paise, {required bool isIncome}) {
    final prefix = isIncome ? '+' : '-';
    return '$prefix${format(paise.abs())}';
  }

  /// Parses user keypad input (e.g. "450.50") to smallest unit integer.
  static int? parseToPaise(String input) {
    final cleaned = input.replaceAll(',', '').trim();
    if (cleaned.isEmpty) return null;
    final value = double.tryParse(cleaned);
    if (value == null || value <= 0) return null;
    return (value * 100).round();
  }
}
