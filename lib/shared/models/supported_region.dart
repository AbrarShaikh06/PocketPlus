import 'profile_currency.dart';

/// A region PocketPlus officially supports. Drives the user's currency and the
/// prices shown in the upgrade (Pro) section. Prices are static display
/// strings so the Pro section renders instantly and works fully offline; the
/// live store price is only fetched at checkout.
class SupportedRegion {
  /// Stable key persisted/derived from the currency code (`INR`/`AED`/`KES`).
  final String currencyCode;
  final String displayName;
  final String flag;
  final String dialCode;
  final ProfileCurrency currency;
  final String basicMonthlyPrice;
  final String proMonthlyPrice;

  const SupportedRegion({
    required this.currencyCode,
    required this.displayName,
    required this.flag,
    required this.dialCode,
    required this.currency,
    required this.basicMonthlyPrice,
    required this.proMonthlyPrice,
  });

  static const SupportedRegion india = SupportedRegion(
    currencyCode: 'INR',
    displayName: 'India',
    flag: '🇮🇳',
    dialCode: '+91',
    currency: ProfileCurrency.inr,
    basicMonthlyPrice: '₹100/month',
    proMonthlyPrice: '₹200/month',
  );

  static const SupportedRegion dubai = SupportedRegion(
    currencyCode: 'AED',
    displayName: 'Dubai (UAE)',
    flag: '🇦🇪',
    dialCode: '+971',
    currency: ProfileCurrency.aed,
    basicMonthlyPrice: 'AED 5/month',
    proMonthlyPrice: 'AED 10/month',
  );

  static const SupportedRegion kenya = SupportedRegion(
    currencyCode: 'KES',
    displayName: 'Kenya',
    flag: '🇰🇪',
    dialCode: '+254',
    currency: ProfileCurrency.kes,
    basicMonthlyPrice: 'KSh 150/month',
    proMonthlyPrice: 'KSh 300/month',
  );

  /// All regions in the order shown in pickers. India first (default).
  static const List<SupportedRegion> all = [india, dubai, kenya];

  static SupportedRegion fromCurrencyCode(String? code) {
    switch (code) {
      case 'AED':
        return dubai;
      case 'KES':
        return kenya;
      default:
        return india;
    }
  }
}
