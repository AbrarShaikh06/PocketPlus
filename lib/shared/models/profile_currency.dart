class ProfileCurrency {
  final String code;
  final String symbol;
  final String locale;
  final int decimalDigits;
  final String smallestUnit;

  const ProfileCurrency({
    required this.code,
    required this.symbol,
    required this.locale,
    required this.decimalDigits,
    required this.smallestUnit,
  });

  static const ProfileCurrency inr = ProfileCurrency(
    code: 'INR',
    symbol: '\u20b9',
    locale: 'en_IN',
    decimalDigits: 2,
    smallestUnit: 'paise',
  );

  static const ProfileCurrency aed = ProfileCurrency(
    code: 'AED',
    symbol: 'AED ',
    locale: 'en_AE',
    decimalDigits: 2,
    smallestUnit: 'fils',
  );

  static const ProfileCurrency kes = ProfileCurrency(
    code: 'KES',
    symbol: 'KSh ',
    locale: 'en_KE',
    decimalDigits: 2,
    smallestUnit: 'cents',
  );

  static ProfileCurrency fromCode(String code) {
    switch (code) {
      case 'AED':
        return aed;
      case 'KES':
        return kes;
      default:
        return inr;
    }
  }
}
