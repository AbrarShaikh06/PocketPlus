import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/firebase_providers.dart';
import '../../features/home/presentation/home_providers.dart';
import 'data/dashboard_repository_impl.dart';
import 'data/firestore_dashboard_data_source.dart';
import 'domain/dashboard_data.dart';
import 'domain/dashboard_repository.dart';
import 'presentation/dashboard_view_model.dart';

final firestoreDashboardDataSourceProvider =
    Provider<FirestoreDashboardDataSource>((ref) {
  return FirestoreDashboardDataSourceImpl(ref.watch(firestoreProvider));
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    ref.watch(firestoreDashboardDataSourceProvider),
  );
});

final dashboardDataProvider = StreamProvider<DashboardData>((ref) {
  final currentProfile = ref.watch(currentProfileProvider);
  final userId = ref.watch(currentBookUserIdProvider);
  if (userId == null || currentProfile == null) {
    return Stream.value(
      DashboardData(
        netProfit: 0,
        totalIncome: 0,
        totalExpense: 0,
        transactionCount: 0,
        recentTransactions: [],
        month: DateTime(2000),
      ),
    );
  }
  return ref
      .watch(dashboardRepositoryProvider)
      .watchDashboardData(
        userId: userId,
        profileId: currentProfile.id,
      )
      .map(
        (result) => result.fold(
          (failure) => DashboardData(
            netProfit: 0,
            totalIncome: 0,
            totalExpense: 0,
            transactionCount: 0,
            recentTransactions: [],
            month: DateTime(2000),
          ),
          (data) => data,
        ),
      );
});

final dashboardViewModelProvider =
    NotifierProvider<DashboardViewModel, AsyncValue<DashboardData>>(
  DashboardViewModel.new,
);
