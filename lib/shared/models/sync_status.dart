enum SyncStatus {
  pending,
  synced,
  failed,
}

extension SyncStatusX on SyncStatus {
  String get firestoreValue => name.toUpperCase();

  static SyncStatus fromFirestore(String value) {
    return SyncStatus.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => SyncStatus.pending,
    );
  }
}
