import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:pocket_plus/core/errors/error_codes.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/savings_entry.dart';
import '../domain/savings_goal.dart';
import 'savings_providers.dart';

part 'savings_view_model.freezed.dart';

@freezed
abstract class CreateSavingsGoalState with _$CreateSavingsGoalState {
  const factory CreateSavingsGoalState({
    @Default('') String name,
    @Default(SavingsCategory.OTHER) SavingsCategory category,
    @Default('0') String targetAmountString,
    DateTime? targetDate,
    @Default('') String notes,
    String? nameError,
    String? targetAmountError,
    String? targetDateError,
    @Default(false) bool isSaving,
    String? saveError,
  }) = _CreateSavingsGoalState;
}

class CreateSavingsGoalViewModel extends Notifier<CreateSavingsGoalState> {
  @override
  CreateSavingsGoalState build() {
    return const CreateSavingsGoalState();
  }

  void setName(String name) {
    state = state.copyWith(name: name, nameError: null);
  }

  void setCategory(SavingsCategory category) {
    state = state.copyWith(category: category);
  }

  void setTargetAmountString(String amount) {
    state = state.copyWith(targetAmountString: amount, targetAmountError: null);
  }

  void setTargetDate(DateTime? date) {
    state = state.copyWith(targetDate: date, targetDateError: null);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  String? _validateName(String name) {
    if (name.trim().length < 2 || name.trim().length > 100) {
      return ErrorCodes.nameLength2to100;
    }
    return null;
  }

  int? _parseAmountPaise(String amountString) {
    final cleaned = amountString.replaceAll(',', '').trim();
    if (cleaned.isEmpty || cleaned == '0') return null;
    final parts = cleaned.split('.');
    final rupees = int.tryParse(parts[0]);
    if (rupees == null || rupees < 0) return null;
    if (parts.length == 1) {
      final paise = rupees * 100;
      if (paise <= 0 || paise > 1000000000000) return null;
      return paise;
    }
    if (parts.length != 2) return null;
    final paiseStr = parts[1].padRight(2, '0').substring(0, 2);
    final paiseVal = int.tryParse(paiseStr);
    if (paiseVal == null) return null;
    final totalPaise = rupees * 100 + paiseVal;
    if (totalPaise <= 0 || totalPaise > 1000000000000) return null;
    return totalPaise;
  }

  String? _validateTargetDate(DateTime? date) {
    if (date == null) return null;
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    final compareDateOnly = DateTime(date.year, date.month, date.day);
    if (!compareDateOnly.isAfter(todayDateOnly)) {
      return ErrorCodes.targetDateFuture;
    }
    return null;
  }

  Future<SavingsGoal?> save() async {
    final nameError = _validateName(state.name);
    final parsedAmount = _parseAmountPaise(state.targetAmountString);
    final targetAmountError =
        parsedAmount == null ? ErrorCodes.invalidTargetAmount : null;
    final targetDateError = _validateTargetDate(state.targetDate);

    if (nameError != null ||
        targetAmountError != null ||
        targetDateError != null) {
      state = state.copyWith(
        nameError: nameError,
        targetAmountError: targetAmountError,
        targetDateError: targetDateError,
      );
      return null;
    }

    state = state.copyWith(isSaving: true, saveError: null);

    final profile = ref.read(currentProfileProvider);
    if (profile == null) {
      state = state.copyWith(
        isSaving: false,
        saveError: ErrorCodes.noActiveProfile,
      );
      return null;
    }

    final now = DateTime.now();
    final goal = SavingsGoal(
      id: const Uuid().v4(),
      userId: profile.userId,
      profileId: profile.id,
      name: state.name.trim(),
      category: state.category,
      targetAmount: parsedAmount!,
      savedAmount: 0,
      targetDate: state.targetDate,
      notes: state.notes.trim().isEmpty ? null : state.notes.trim(),
      createdAt: now,
      updatedAt: now,
    );

    final result = await ref.read(savingsRepositoryProvider).createGoal(goal);

    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false, saveError: failure.message);
        return null;
      },
      (created) {
        state = const CreateSavingsGoalState(); // Reset
        return created;
      },
    );
  }
}

final createSavingsGoalViewModelProvider =
    NotifierProvider<CreateSavingsGoalViewModel, CreateSavingsGoalState>(
  CreateSavingsGoalViewModel.new,
);

@freezed
abstract class AddSavingsEntryFormState with _$AddSavingsEntryFormState {
  const factory AddSavingsEntryFormState({
    @Default('0') String amountString,
    @Default('') String note,
    DateTime? entryDate,
    String? amountError,
    @Default(false) bool isSaving,
    String? saveError,
  }) = _AddSavingsEntryFormState;
}

/// Outcome of adding a savings entry, so callers can celebrate goal
/// completion regardless of which screen initiated the entry.
enum AddEntryOutcome { failed, added, goalCompleted }

class AddSavingsEntryViewModel extends Notifier<AddSavingsEntryFormState> {
  @override
  AddSavingsEntryFormState build() {
    return AddSavingsEntryFormState(
      entryDate: DateTime.now(),
    );
  }

  void pressKey(String key) {
    if (key == 'backspace') {
      if (state.amountString.isEmpty || state.amountString == '0') {
        state = state.copyWith(amountString: '0', amountError: null);
        return;
      }
      final newString =
          state.amountString.substring(0, state.amountString.length - 1);
      state = state.copyWith(
        amountString: newString.isEmpty ? '0' : newString,
        amountError: null,
      );
      return;
    }

    if (key == '.') {
      if (state.amountString.contains('.')) return;
      state = state.copyWith(
        amountString: '${state.amountString}.',
        amountError: null,
      );
      return;
    }

    final digitsCount = state.amountString.replaceAll('.', '').length;
    if (digitsCount >= 8) return;

    if (state.amountString.contains('.')) {
      final parts = state.amountString.split('.');
      if (parts.length > 1 && parts[1].length >= 2) return;
    }

    if (state.amountString == '0') {
      if (key == '0') return;
      state = state.copyWith(amountString: key, amountError: null);
    } else {
      state = state.copyWith(
        amountString: '${state.amountString}$key',
        amountError: null,
      );
    }
  }

  void setNote(String note) {
    state = state.copyWith(note: note);
  }

  void setEntryDate(DateTime date) {
    state = state.copyWith(entryDate: date);
  }

  int? _parseAmountPaise() {
    final cleaned = state.amountString.replaceAll(',', '').trim();
    if (cleaned.isEmpty || cleaned == '0') return null;
    final value = double.tryParse(cleaned);
    if (value == null || value <= 0) return null;
    final paise = (value * 100).round();
    if (paise <= 0 || paise > 1000000000000) return null;
    return paise;
  }

  Future<AddEntryOutcome> save({required SavingsGoal goal}) async {
    if (state.amountString.isEmpty || state.amountString == '0') {
      state = state.copyWith(amountError: ErrorCodes.amountRequiredGeneric);
      return AddEntryOutcome.failed;
    }

    final paise = _parseAmountPaise();
    if (paise == null) {
      state = state.copyWith(amountError: ErrorCodes.invalidAmountGeneric);
      return AddEntryOutcome.failed;
    }

    final remaining = goal.targetAmount - goal.savedAmount;
    if (paise > remaining) {
      state = state.copyWith(amountError: ErrorCodes.amountExceedsRemaining);
      return AddEntryOutcome.failed;
    }

    state = state.copyWith(isSaving: true, saveError: null);

    final profile = ref.read(currentProfileProvider);
    if (profile == null) {
      state = state.copyWith(
        isSaving: false,
        saveError: ErrorCodes.noActiveProfile,
      );
      return AddEntryOutcome.failed;
    }

    final now = DateTime.now();
    final entry = SavingsEntry(
      id: const Uuid().v4(),
      goalId: goal.id,
      userId: profile.userId,
      profileId: profile.id,
      amount: paise,
      note: state.note.trim().isEmpty ? null : state.note.trim(),
      entryDate: state.entryDate ?? now,
      createdAt: now,
    );

    final result = await ref.read(savingsRepositoryProvider).addEntry(entry);

    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false, saveError: failure.message);
        return AddEntryOutcome.failed;
      },
      (_) {
        final completed = goal.savedAmount + paise >= goal.targetAmount;
        state = AddSavingsEntryFormState(entryDate: DateTime.now()); // Reset
        return completed
            ? AddEntryOutcome.goalCompleted
            : AddEntryOutcome.added;
      },
    );
  }
}

final addSavingsEntryViewModelProvider =
    NotifierProvider<AddSavingsEntryViewModel, AddSavingsEntryFormState>(
  AddSavingsEntryViewModel.new,
);
