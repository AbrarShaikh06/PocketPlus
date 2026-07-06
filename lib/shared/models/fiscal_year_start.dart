enum FiscalYearStart {
  jan,
  apr,
}

extension FiscalYearStartX on FiscalYearStart {
  String get firestoreValue => name.toUpperCase();

  static FiscalYearStart fromFirestore(String value) {
    return FiscalYearStart.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => FiscalYearStart.apr,
    );
  }
}
