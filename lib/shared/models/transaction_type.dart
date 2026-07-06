enum TransactionType {
  income,
  expense,
}

extension TransactionTypeX on TransactionType {
  String get firestoreValue => name.toUpperCase();

  static TransactionType fromFirestore(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => TransactionType.expense,
    );
  }
}
