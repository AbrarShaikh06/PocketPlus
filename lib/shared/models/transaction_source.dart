enum TransactionSource {
  manual,
  sms,
  voice,
  ocr,
  recurring,
  invoice,
  mpesa,
}

extension TransactionSourceX on TransactionSource {
  String get firestoreValue => name.toUpperCase();

  static TransactionSource fromFirestore(String value) {
    return TransactionSource.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
    );
  }
}
