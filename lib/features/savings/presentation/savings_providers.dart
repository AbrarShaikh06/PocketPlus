import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/firebase_providers.dart';
import '../../home/presentation/home_providers.dart';
import '../data/savings_data_source.dart';
import '../data/savings_repository_impl.dart';
import '../domain/savings_entry.dart';
import '../domain/savings_goal.dart';
import '../domain/savings_repository.dart';

final savingsDataSourceProvider = Provider<FirestoreSavingsDataSource>((ref) {
  return FirestoreSavingsDataSourceImpl(ref.watch(firestoreProvider));
});

final savingsRepositoryProvider = Provider<SavingsRepository>((ref) {
  return SavingsRepositoryImpl(ref.watch(savingsDataSourceProvider));
});

final savingsGoalsStreamProvider =
    StreamProvider.autoDispose<List<SavingsGoal>>((ref) {
  final profile = ref.watch(currentProfileProvider);
  if (profile == null) return const Stream.empty();
  return ref.watch(savingsRepositoryProvider).watchGoals(
        userId: profile.userId,
        profileId: profile.id,
      );
});

final activeGoalsProvider = Provider.autoDispose<List<SavingsGoal>>((ref) {
  final goals = ref.watch(savingsGoalsStreamProvider).value ?? [];
  return goals.where((g) => !g.isAchieved && g.deletedAt == null).toList();
});

final achievedGoalsProvider = Provider.autoDispose<List<SavingsGoal>>((ref) {
  final goals = ref.watch(savingsGoalsStreamProvider).value ?? [];
  return goals.where((g) => g.isAchieved && g.deletedAt == null).toList();
});

final savingsEntriesStreamProvider = StreamProvider.autoDispose
    .family<List<SavingsEntry>, String>((ref, goalId) {
  return ref.watch(savingsRepositoryProvider).watchEntries(goalId: goalId);
});
