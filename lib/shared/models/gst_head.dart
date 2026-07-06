enum GstHead {
  exempt,
  zero,
  five,
  twelve,
  eighteen,
  twentyeight,
}

extension GstHeadX on GstHead {
  String get firestoreValue => name.toUpperCase();

  /// Display label: "GST 5%" for India, "VAT 5%" for UAE
  String displayLabel(String currencyCode) {
    final taxLabel = currencyCode == 'AED' ? 'VAT' : 'GST';
    switch (this) {
      case GstHead.exempt:
        return '$taxLabel Exempt';
      case GstHead.zero:
        return '$taxLabel 0%';
      case GstHead.five:
        return '$taxLabel 5%';
      case GstHead.twelve:
        return 'GST 12%';
      case GstHead.eighteen:
        return 'GST 18%';
      case GstHead.twentyeight:
        return 'GST 28%';
    }
  }

  static GstHead fromFirestore(String value) {
    return GstHead.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => GstHead.exempt,
    );
  }

  static List<double> taxRates(String currencyCode) {
    switch (currencyCode) {
      case 'AED':
        return [0, 5];
      case 'KES':
        return [0];
      default:
        return [0, 5, 12, 18, 28];
    }
  }
}
