import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/providers/firebase_providers.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/entities/budget.dart';
import '../budgets_providers.dart';

part 'budget_view_model.freezed.dart';

@freezed
abstract class BudgetListState with _$BudgetListState {
  const factory BudgetListState({
    @Default([]) List<Budget> budgets,
    @Default(false) bool isLoading,
    String? error,
  }) = _BudgetListState;
}

@freezed
abstract class CreateBudgetState with _$CreateBudgetState {
  const factory CreateBudgetState({
    required String name,
    required BudgetType budgetType,
    required List<String> selectedCategoryIds,
    required String amountString,
    required BudgetPeriod period,
    required DateTime startDate,
    DateTime? endDate,
    @Default('#4CAF50') String colorHex,
    @Default('account_balance_wallet') String icon,
    @Default(80.0) double alertThreshold,
    @Default(true) bool notificationsEnabled,
    String? notes,
    @Default(false) bool isSaving,
    @Default(false) bool isEditing,
    String? saveError,
    String? nameError,
    String? amountError,
  }) = _CreateBudgetState;
}

class BudgetListViewModel extends Notifier<BudgetListState> {
  @override
  BudgetListState build() {
    return const BudgetListState();
  }

  void updateBudgets(List<Budget> budgets) {
    state = state.copyWith(budgets: budgets, isLoading: false);
  }

  void setError(String error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  void navigateToCreate(BuildContext context) {
    context.push('/budgets/new');
  }

  void navigateToDetail(BuildContext context, String budgetId) {
    context.push('/budgets/$budgetId');
  }
}

final budgetListViewModelProvider =
    NotifierProvider<BudgetListViewModel, BudgetListState>(
  BudgetListViewModel.new,
);

class CreateBudgetViewModel extends Notifier<CreateBudgetState> {
  DateTime _calculateEndDate(DateTime start, BudgetPeriod period) {
    return switch (period) {
      BudgetPeriod.weekly => start.add(const Duration(days: 7)),
      BudgetPeriod.monthly => start.add(const Duration(days: 30)),
      BudgetPeriod.yearly => start.add(const Duration(days: 365)),
    };
  }

  @override
  CreateBudgetState build() {
    final start = DateTime.now();
    return CreateBudgetState(
      name: '',
      budgetType: BudgetType.overall,
      selectedCategoryIds: [],
      amountString: '',
      period: BudgetPeriod.monthly,
      startDate: start,
      endDate: _calculateEndDate(start, BudgetPeriod.monthly),
    );
  }

  void editFrom(Budget budget) {
    state = CreateBudgetState(
      name: budget.name,
      budgetType: budget.budgetType,
      selectedCategoryIds: budget.categoryIds,
      amountString: (budget.amount / 100).toStringAsFixed(0),
      period: budget.period,
      startDate: budget.startDate,
      endDate: budget.endDate,
      colorHex: budget.colorHex,
      icon: budget.icon,
      alertThreshold: budget.alertThreshold.toDouble(),
      notificationsEnabled: budget.notificationsEnabled,
      notes: budget.notes,
      isEditing: true,
    );
  }

  void setName(String value) =>
      state = state.copyWith(name: value, nameError: null);
  void setAmount(String value) =>
      state = state.copyWith(amountString: value, amountError: null);
  void setPeriod(BudgetPeriod value) {
    state = state.copyWith(
      period: value,
      endDate: _calculateEndDate(state.startDate, value),
    );
  }

  void setStartDate(DateTime value) {
    state = state.copyWith(
      startDate: value,
      endDate: _calculateEndDate(value, state.period),
    );
  }

  void setEndDate(DateTime? value) => state = state.copyWith(endDate: value);
  void setColorHex(String value) => state = state.copyWith(colorHex: value);
  void setIcon(String value) => state = state.copyWith(icon: value);
  void setAlertThreshold(double value) =>
      state = state.copyWith(alertThreshold: value);

  bool _validate() {
    String? nameError;
    String? amountError;

    if (state.name.trim().isEmpty) {
      nameError = 'Budget name is required';
    }
    final amount = int.tryParse(state.amountString.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      amountError = 'Enter a valid amount greater than 0';
    }

    state = state.copyWith(
      nameError: nameError,
      amountError: amountError,
    );
    return nameError == null && amountError == null;
  }

  Future<bool> save() async {
    if (!_validate()) return false;

    state = state.copyWith(isSaving: true, saveError: null);

    final userId = ref.read(currentBookUserIdProvider);
    final profile = ref.read(currentProfileProvider);

    if (userId == null) {
      state = state.copyWith(
          isSaving: false,
          saveError: 'You must be signed in to create a budget.');
      return false;
    }
    if (profile == null) {
      state = state.copyWith(
          isSaving: false,
          saveError:
              'No active profile selected. Please create a profile first.');
      return false;
    }

    final firestore = ref.read(firestoreProvider);
    final docId = firestore.collection('budgets').doc().id;

    final amount =
        (int.tryParse(state.amountString.replaceAll(',', '')) ?? 0) * 100;

    final budgetRepository = ref.read(budgetRepositoryProvider);

    final budget = Budget(
      id: docId,
      userId: userId,
      profileId: profile.id,
      name: state.name.trim(),
      budgetType: state.budgetType,
      categoryIds: state.selectedCategoryIds,
      amount: amount,
      period: state.period,
      startDate: state.startDate,
      endDate: state.endDate,
      colorHex: state.colorHex,
      icon: state.icon,
      alertThreshold: state.alertThreshold.round(),
      notificationsEnabled: state.notificationsEnabled,
      notes: state.notes?.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = state.isEditing
        ? await budgetRepository.updateBudget(budget)
        : await budgetRepository.createBudget(budget);

    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false, saveError: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isSaving: false);
        return true;
      },
    );
  }
}

final createBudgetViewModelProvider =
    NotifierProvider<CreateBudgetViewModel, CreateBudgetState>(
  CreateBudgetViewModel.new,
);

// Budget detail actions
enum BudgetAction { edit, delete, pause, resume, duplicate }

class BudgetDetailActionNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> delete(String budgetId) async {
    state = const AsyncValue.loading();
    final result =
        await ref.read(budgetRepositoryProvider).softDeleteBudget(budgetId);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }

  Future<void> togglePause(String budgetId, bool isPaused) async {
    state = const AsyncValue.loading();
    final result = await ref
        .read(budgetRepositoryProvider)
        .togglePauseBudget(budgetId, isPaused);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }

  Future<void> duplicate(Budget budget, BuildContext context) async {
    state = const AsyncValue.loading();
    final result =
        await ref.read(budgetRepositoryProvider).duplicateBudget(budget);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) {
        context.pop();
        return const AsyncValue.data(null);
      },
    );
  }
}

final budgetDetailActionProvider =
    NotifierProvider.autoDispose<BudgetDetailActionNotifier, AsyncValue<void>>(
  BudgetDetailActionNotifier.new,
);
