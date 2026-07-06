import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/firebase_providers.dart';
import 'data/budget_repository_impl.dart';
import 'data/firestore_budget_data_source.dart';
import 'domain/budget_calculator.dart';
import 'domain/budget_repository.dart';

final firestoreBudgetDataSourceProvider =
    Provider<FirestoreBudgetDataSource>((ref) {
  return FirestoreBudgetDataSourceImpl(ref.watch(firestoreProvider));
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(ref.watch(firestoreBudgetDataSourceProvider));
});

final budgetCalculatorProvider = Provider<BudgetCalculator>((ref) {
  return BudgetCalculator();
});
