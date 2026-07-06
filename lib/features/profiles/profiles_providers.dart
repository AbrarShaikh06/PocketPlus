import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/models.dart';
import '../../shared/providers/firebase_providers.dart';
import 'data/firestore_profile_data_source.dart';
import 'data/profile_repository_impl.dart';
import 'domain/profile_repository.dart';

final firestoreProfileDataSourceProvider =
    Provider<FirestoreProfileDataSource>((ref) {
  return FirestoreProfileDataSourceImpl(ref.watch(firestoreProvider));
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    dataSource: ref.watch(firestoreProfileDataSourceProvider),
    firebaseAuth: ref.watch(firebaseAuthProvider),
  );
});

// Paywalls have been removed — every user has full, unlimited access for free.
// Revenue comes from banner ads only. [PlanType] is retained internally and
// always resolves to [PlanType.pro] so existing plan-aware UI keeps working
// (it simply never gates anything).
final activePlanProvider = Provider<PlanType>((ref) => PlanType.pro);

final userPlanProvider = FutureProvider<PlanType>((ref) async => PlanType.pro);
