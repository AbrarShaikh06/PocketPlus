import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../budgets/domain/entities/budget.dart';
import '../../budgets/presentation/providers/budget_providers.dart';
import '../../categories/categories_providers.dart';
import '../../categories/domain/entities/category.dart';
import '../../profiles/domain/entities/profile.dart';
import '../../profiles/presentation/active_profile_provider.dart';
import '../../profiles/profiles_providers.dart';
import '../../reports/domain/entities/report_summary.dart';
import '../../reports/reports_providers.dart';
import '../../transactions/domain/entities/transaction.dart';
import '../../transactions/transactions_providers.dart';
import '../../../shared/providers/firebase_providers.dart';

final userProfilesProvider = StreamProvider<List<Profile>>((ref) {
  // Watch the auth *stream* (not FirebaseAuth.instance, which never notifies)
  // so this rebuilds and starts the real query once the user resolves. Reading
  // currentUser off the stable instance provider would cache an empty result
  // if it happened to run before sign-in completed — leaving the home screen
  // stuck on its loading skeleton forever.
  final userId = ref.watch(authStateChangesProvider).asData?.value?.uid;
  if (userId == null) return Stream.value([]);
  return ref.watch(profileRepositoryProvider).watchProfiles(userId);
});

final currentProfileProvider = Provider<Profile?>((ref) {
  final profilesAsync = ref.watch(userProfilesProvider);
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
    error: (error, _) {
      // Don't silently swallow: the home screen renders an explicit error/retry
      // state by watching userProfilesProvider directly. Logging here keeps the
      // underlying cause (e.g. Firestore UNAVAILABLE) visible in diagnostics.
      AppLogger.error('Failed to resolve current profile', error: error);
      return null;
    },
  );
});

final currentBookUserIdProvider = Provider<String?>((ref) {
  final activeProfile = ref.watch(currentProfileProvider);
  return activeProfile?.userId;
});

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final userId = ref.watch(currentBookUserIdProvider);
  if (userId == null) return Stream.value([]);
  return ref.watch(categoryRepositoryProvider).watchCategories(userId: userId);
});

final recentTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final activeProfile = ref.watch(currentProfileProvider);
  final userId = ref.watch(currentBookUserIdProvider);
  if (userId == null || activeProfile == null) {
    return Stream.value([]);
  }
  final stream = ref
      .watch(transactionRepositoryProvider)
      .watchTransactions(userId: userId, profileId: activeProfile.id);

  return stream.map((txns) {
    final sorted = List<Transaction>.from(txns)
      ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    return sorted.take(5).toList();
  });
});

final transactionsTodayProvider = StreamProvider<List<Transaction>>((ref) {
  final activeProfile = ref.watch(currentProfileProvider);
  final userId = ref.watch(currentBookUserIdProvider);
  if (userId == null || activeProfile == null) {
    return Stream.value([]);
  }
  final stream = ref
      .watch(transactionRepositoryProvider)
      .watchTransactions(userId: userId, profileId: activeProfile.id);

  return stream.map((txns) {
    final now = DateTime.now();
    return txns.where((txn) {
      final d = txn.transactionDate;
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }).toList();
  });
});

final reportSummaryProvider =
    StreamProvider.family<ReportSummary, DateTime>((ref, month) {
  final activeProfile = ref.watch(currentProfileProvider);
  final userId = ref.watch(currentBookUserIdProvider);
  if (activeProfile == null || userId == null) {
    return Stream.value(
      ReportSummary(
        totalIncome: 0,
        totalExpense: 0,
        netProfit: 0,
        changePercent: 0.0,
        month: month,
        profileId: '',
      ),
    );
  }
  return ref.watch(reportRepositoryProvider).watchMonthlyReport(
        userId: userId,
        profileId: activeProfile.id,
        month: month,
      );
});

final budgetOverviewProvider = Provider.autoDispose<
    ({List<Budget> topBudgets, int totalRemaining, bool hasBudgets})>((ref) {
  final budgets = ref.watch(topBudgetsProvider);
  final totalRemaining = budgets.fold(0, (sum, b) => sum + b.remainingAmount);
  return (
    topBudgets: budgets,
    totalRemaining: totalRemaining,
    hasBudgets: budgets.isNotEmpty
  );
});

final homeMonthlyChartProvider = StreamProvider<List<ReportSummary>>((ref) {
  final activeProfile = ref.watch(currentProfileProvider);
  final userId = ref.watch(currentBookUserIdProvider);
  if (activeProfile == null || userId == null) return Stream.value([]);
  return ref.watch(reportRepositoryProvider).watchMonthlyChart(
        userId: userId,
        profileId: activeProfile.id,
      );
});
