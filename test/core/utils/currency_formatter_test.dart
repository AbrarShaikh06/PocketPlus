import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('formatRupees formats paise as Indian rupees', () {
      expect(CurrencyFormatter.formatRupees(45050), '₹450.50');
      expect(CurrencyFormatter.formatRupees(4505000), '₹45,050.00');
    });

    test('parseToPaise converts decimal string to integer paise', () {
      expect(CurrencyFormatter.parseToPaise('450.50'), 45050);
    });

    test('parseToPaise returns null for invalid input', () {
      expect(CurrencyFormatter.parseToPaise(''), isNull);
      expect(CurrencyFormatter.parseToPaise('abc'), isNull);
    });
  });
}
