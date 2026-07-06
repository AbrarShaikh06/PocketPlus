enum PlanType {
  free,
  basic,
  pro,
}

extension PlanTypeX on PlanType {
  String get firestoreValue => name.toUpperCase();

  static PlanType fromFirestore(String value) {
    return PlanType.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => PlanType.free,
    );
  }

  int get maxProfiles {
    switch (this) {
      case PlanType.free:
        return 1;
      case PlanType.basic:
        return 3;
      case PlanType.pro:
        return 999;
    }
  }
}
