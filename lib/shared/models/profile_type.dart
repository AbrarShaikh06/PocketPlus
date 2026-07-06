enum ProfileType {
  personal,
  shop,
  freelance,
  contractor,
  salon,
  tutor,
  other,
}

extension ProfileTypeX on ProfileType {
  String get firestoreValue => name.toUpperCase();

  static ProfileType fromFirestore(String value) {
    return ProfileType.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => ProfileType.other,
    );
  }
}
