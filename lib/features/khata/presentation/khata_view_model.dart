import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../../core/errors/error_codes.dart';
import '../../../core/utils/phone_validator.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/entities/khata_customer.dart';
import '../khata_providers.dart';

part 'khata_view_model.freezed.dart';

@freezed
abstract class KhataListState with _$KhataListState {
  const factory KhataListState({
    required List<KhataCustomer> customers,
    required bool isLoading,
    String? error,
  }) = _KhataListState;
}

final khataListViewModelProvider =
    StreamProvider.autoDispose<List<KhataCustomer>>((ref) {
  final profile = ref.watch(currentProfileProvider);
  if (profile == null) return const Stream.empty();
  return ref
      .watch(khataRepositoryProvider)
      .watchCustomers(userId: profile.userId, profileId: profile.id);
});

@freezed
abstract class AddCustomerState with _$AddCustomerState {
  const factory AddCustomerState({
    required String name,
    required String phone,
    String? nameError,
    String? phoneError,
    required bool isSaving,
  }) = _AddCustomerState;
}

class AddCustomerViewModel extends Notifier<AddCustomerState> {
  @override
  AddCustomerState build() {
    return const AddCustomerState(
      name: '',
      phone: '',
      isSaving: false,
    );
  }

  void setName(String value) {
    state = state.copyWith(name: value, nameError: null);
  }

  void setPhone(String value) {
    state = state.copyWith(phone: value, phoneError: null);
  }

  String? _validateName(String name) {
    if (name.trim().length < 2) return ErrorCodes.nameMinLength;
    if (name.trim().length > 200) return ErrorCodes.nameMaxLength;
    return null;
  }

  String? _validatePhone(String phone) => PhoneValidator.validate(phone);

  Future<KhataCustomer?> saveCustomer() async {
    final nameError = _validateName(state.name);
    final phoneError = _validatePhone(state.phone);

    if (nameError != null || phoneError != null) {
      state = state.copyWith(nameError: nameError, phoneError: phoneError);
      return null;
    }

    state = state.copyWith(isSaving: true);

    final profile = ref.read(currentProfileProvider);
    if (profile == null) {
      state = state.copyWith(isSaving: false);
      return null;
    }

    final now = DateTime.now();
    final customer = KhataCustomer(
      id: const Uuid().v4(),
      userId: profile.userId,
      profileId: profile.id,
      name: state.name.trim(),
      phone: state.phone.isEmpty ? null : state.phone.trim(),
      createdAt: now,
      updatedAt: now,
    );

    final result =
        await ref.read(khataRepositoryProvider).createCustomer(customer);

    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false);
        return null;
      },
      (created) {
        ref.read(analyticsServiceProvider).logKhataCustomerAdded();
        state = state.copyWith(isSaving: false);
        return created;
      },
    );
  }
}

final addCustomerViewModelProvider =
    NotifierProvider<AddCustomerViewModel, AddCustomerState>(
  AddCustomerViewModel.new,
);

@freezed
abstract class AddEntryFormState with _$AddEntryFormState {
  const factory AddEntryFormState({
    required String amountString,
    required String note,
    String? amountError,
    required bool isSaving,
    String? saveError,
  }) = _AddEntryFormState;
}

class AddEntryViewModel extends Notifier<AddEntryFormState> {
  @override
  AddEntryFormState build() {
    return const AddEntryFormState(
      amountString: '0',
      note: '',
      isSaving: false,
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

  void setNote(String value) {
    if (value.length > 500) return;
    state = state.copyWith(note: value);
  }

  int? _parseAmountPaise() {
    final cleaned = state.amountString.replaceAll(',', '').trim();
    if (cleaned.isEmpty || cleaned == '0') return null;
    final parts = cleaned.split('.');
    final rupees = int.tryParse(parts[0]);
    if (rupees == null || rupees < 0) return null;
    if (parts.length == 1) {
      final paise = rupees * 100;
      if (paise <= 0 || paise > 10000000) return null;
      return paise;
    }
    if (parts.length != 2) return null;
    final paiseStr = parts[1].padRight(2, '0').substring(0, 2);
    final paiseVal = int.tryParse(paiseStr);
    if (paiseVal == null) return null;
    final totalPaise = rupees * 100 + paiseVal;
    if (totalPaise <= 0 || totalPaise > 10000000) return null;
    return totalPaise;
  }

  Future<bool> save({
    required String customerId,
    required bool isCredit,
  }) async {
    if (state.amountString.isEmpty || state.amountString == '0') {
      state = state.copyWith(amountError: ErrorCodes.amountRequired);
      return false;
    }

    final paise = _parseAmountPaise();
    if (paise == null) {
      state = state.copyWith(
        amountError: ErrorCodes.invalidAmount,
      );
      return false;
    }

    state = state.copyWith(isSaving: true, saveError: null);

    final repository = ref.read(khataRepositoryProvider);
    final result = isCredit
        ? await repository.addCreditEntry(
            customerId: customerId,
            amountPaise: paise,
            note: state.note.trim().isEmpty ? null : state.note.trim(),
          )
        : await repository.addRepaymentEntry(
            customerId: customerId,
            amountPaise: paise,
            note: state.note.trim().isEmpty ? null : state.note.trim(),
          );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isSaving: false,
          saveError: ErrorCodes.couldNotSave,
        );
        return false;
      },
      (_) {
        state = state.copyWith(isSaving: false);
        return true;
      },
    );
  }
}

final addEntryViewModelProvider =
    NotifierProvider<AddEntryViewModel, AddEntryFormState>(
  AddEntryViewModel.new,
);
