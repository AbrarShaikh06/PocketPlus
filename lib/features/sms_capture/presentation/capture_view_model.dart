import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../categories/domain/entities/category.dart';
import '../../home/presentation/home_providers.dart';
import '../../transactions/domain/entities/transaction.dart';
import '../../transactions/transactions_providers.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/errors/error_codes.dart';
import '../../../shared/models/models.dart';
import '../../../shared/providers/firebase_providers.dart';
import '../data/firestore_sms_dedup_data_source.dart';
import '../domain/entities/parsed_sms.dart';

part 'capture_view_model.freezed.dart';

@freezed
abstract class CaptureState with _$CaptureState {
  const factory CaptureState({
    required ParsedSms parsedSms,
    required List<Category> categories,
    String? selectedCategoryId,
    required bool isLoadingCategories,
    required bool isSaving,
    String? error,
  }) = _CaptureState;
}

class CaptureViewModel extends Notifier<CaptureState> {
  final ParsedSms parsedSms;
  CaptureViewModel(this.parsedSms);

  DateTime? _startTime;

  @override
  CaptureState build() {
    return CaptureState(
      parsedSms: parsedSms,
      categories: const [],
      selectedCategoryId: null,
      isLoadingCategories: true,
      isSaving: false,
      error: null,
    );
  }

  void init(ParsedSms sms) {
    _startTime = DateTime.now();
    _loadCategories(sms);
  }

  Future<void> _loadCategories(ParsedSms sms) async {
    state = state.copyWith(isLoadingCategories: true, error: null);
    try {
      final categoriesAsync = ref.read(categoriesProvider);
      final List<Category> categoriesList;
      if (categoriesAsync is AsyncData<List<Category>>) {
        categoriesList = categoriesAsync.value;
      } else {
        categoriesList = await ref.read(categoriesProvider.future);
      }
      if (!ref.mounted) return;

      // Show only categories matching this transaction's type, for manual pick.
      final filtered = categoriesList.where((c) => c.type == sms.type).toList();
      state = state.copyWith(categories: filtered, isLoadingCategories: false);
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoadingCategories: false);
    }
  }

  void selectCategory(String categoryId) {
    state = state.copyWith(selectedCategoryId: categoryId);
  }

  Future<bool> confirm(String merchantName) async {
    final selectedCategoryId = state.selectedCategoryId;
    if (selectedCategoryId == null) {
      state = state.copyWith(error: ErrorCodes.selectCategoryRequired);
      return false;
    }

    state = state.copyWith(isSaving: true, error: null);

    try {
      final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
      final profile = ref.read(currentProfileProvider);
      final profileId = profile?.id;

      if (userId == null || profileId == null) {
        state =
            state.copyWith(isSaving: false, error: ErrorCodes.userNotLoggedIn);
        return false;
      }

      final now = DateTime.now();
      final transactionId = const Uuid().v4();

      final transaction = Transaction(
        id: transactionId,
        userId: userId,
        profileId: profileId,
        amount: state.parsedSms.amount,
        type: state.parsedSms.type,
        source: state.parsedSms.senderId.contains('MPESA')
            ? TransactionSource.mpesa
            : TransactionSource.sms,
        categoryId: selectedCategoryId,
        needsCategorization: selectedCategoryId.startsWith('sys_unaccounted'),
        merchantName: merchantName.trim().isEmpty
            ? 'Unknown Merchant'
            : merchantName.trim(),
        transactionDate: state.parsedSms.transactionDate,
        smsHash: state.parsedSms.smsHash,
        createdAt: now,
        updatedAt: now,
      );

      // Create transaction
      final result = await ref
          .read(transactionRepositoryProvider)
          .createTransaction(transaction);
      if (!ref.mounted) return false;

      return await result.fold(
        (failure) {
          if (!ref.mounted) return false;
          state = state.copyWith(isSaving: false, error: failure.message);
          return false;
        },
        (_) async {
          if (!ref.mounted) return false;
          // Write logged log in dedup
          await ref.read(smsDedupRepositoryProvider).writeDedupLog(
                userId,
                state.parsedSms.smsHash,
                DedupAction.logged,
                transactionId,
              );
          if (!ref.mounted) return false;

          // Log analytics
          final timeToConfirmMs = _startTime != null
              ? DateTime.now().difference(_startTime!).inMilliseconds
              : 0;

          final category = state.categories.firstWhere(
            (c) => c.id == selectedCategoryId,
            orElse: () => Category(
              id: selectedCategoryId,
              name: 'Unknown',
              icon: 'help',
              type: state.parsedSms.type,
            ),
          );

          await ref.read(analyticsServiceProvider).logSmsCaptureConfirmed(
                bank: state.parsedSms.senderId,
                category: category.name,
                timeToConfirmMs: timeToConfirmMs,
              );
          if (!ref.mounted) return false;

          state = state.copyWith(isSaving: false);
          return true;
        },
      );
    } catch (e) {
      if (!ref.mounted) return false;
      state = state.copyWith(isSaving: false, error: e.toString());
      return false;
    }
  }

  Future<void> dismiss() async {
    try {
      final userId = ref.read(firebaseAuthProvider).currentUser?.uid;
      if (userId == null) {
        return;
      }

      await ref.read(smsDedupRepositoryProvider).writeDedupLog(
            userId,
            state.parsedSms.smsHash,
            DedupAction.dismissed,
            null,
          );

      await ref.read(analyticsServiceProvider).logSmsCaptureDismissed(
            bank: state.parsedSms.senderId,
          );
    } catch (_) {
      // Suppress analytics and background log errors if any
    }
  }
}

final captureViewModelProvider = NotifierProvider.autoDispose
    .family<CaptureViewModel, CaptureState, ParsedSms>(
  (arg) => CaptureViewModel(arg),
);
