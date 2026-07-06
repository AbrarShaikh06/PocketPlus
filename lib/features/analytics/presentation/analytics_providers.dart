import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../profiles/domain/entities/profile.dart';
import '../../profiles/presentation/active_profile_provider.dart';
import '../../profiles/profiles_providers.dart';
import '../../reports/domain/entities/report_summary.dart';
import '../../reports/reports_providers.dart';
import '../../../shared/providers/firebase_providers.dart';

final analyticsProfilesProvider = StreamProvider<List<Profile>>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final userId = auth.currentUser?.uid;
  if (userId == null) return Stream.value([]);
  return ref.watch(profileRepositoryProvider).watchProfiles(userId);
});

final analyticsProfileProvider = Provider<Profile?>((ref) {
  final profilesAsync = ref.watch(analyticsProfilesProvider);
  final activeId = ref.watch(activeProfileProvider);
  return profilesAsync.when(
    data: (profiles) {
      if (profiles.isEmpty) return null;
      if (activeId == null) {
        final defaultProfile = profiles.firstWhere(
          (p) => p.isDefault,
          orElse: () => profiles.first,
        );
        return defaultProfile;
      }
      return profiles.firstWhere(
        (p) => p.id == activeId,
        orElse: () => profiles.first,
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

final analyticsChartProvider = StreamProvider<List<ReportSummary>>((ref) {
  final activeProfile = ref.watch(analyticsProfileProvider);
  if (activeProfile == null) return Stream.value([]);
  return ref.watch(reportRepositoryProvider).watchMonthlyChart(
        userId: activeProfile.userId,
        profileId: activeProfile.id,
      );
});
