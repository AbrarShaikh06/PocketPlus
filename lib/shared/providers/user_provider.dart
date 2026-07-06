import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/supported_region.dart';
import 'firebase_providers.dart';

/// Streams the current authenticated user's `users/{uid}` document.
///
/// Emits `null` while signed out. Consumers read `.value?.data()` for fields
/// such as `plan`, `role`, `businessName`, `language`, and `tutorialCompleted`.
final userDocProvider =
    StreamProvider<DocumentSnapshot<Map<String, dynamic>>?>((ref) {
  final user = ref.watch(authStateChangesProvider).asData?.value;
  if (user == null) {
    return Stream.value(null);
  }
  return ref
      .watch(firestoreProvider)
      .collection('users')
      .doc(user.uid)
      .snapshots();
});

/// The user's officially-supported region, derived from their stored `country`
/// (currency code). Drives currency + the prices shown in the upgrade section.
final userRegionProvider = Provider<SupportedRegion>((ref) {
  final data = ref.watch(userDocProvider).value?.data();
  return SupportedRegion.fromCurrencyCode(data?['country'] as String?);
});
