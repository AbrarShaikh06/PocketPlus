import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/ai/gemini_rate_limiter.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/errors/error_codes.dart';
import '../../../shared/models/models.dart';
import '../../categories/categories_providers.dart';
import '../../categories/domain/entities/category.dart';
import '../../home/presentation/home_providers.dart';
import '../data/gemini_voice_parser.dart';
import '../data/gemini_ocr_parser.dart';
import '../data/voice_permission_service.dart';
import '../data/speech_service.dart';
import '../domain/entities/transaction.dart';
import '../transactions_providers.dart';

part 'add_transaction_view_model.freezed.dart';

@freezed
abstract class AddTransactionState with _$AddTransactionState {
  const factory AddTransactionState({
    // Form fields
    required String amountString,
    required TransactionType type,
    String? selectedCategoryId,
    required DateTime transactionDate,
    required String note,
    String? merchantName,

    // Categories and states
    required List<Category> categories,
    required bool isLoadingCategories,
    required bool isSaving,
    String? saveError,

    // Voice Input State
    required bool isRecording,
    required bool isProcessingVoice,
    String? voiceError,

    // OCR State
    required bool isScanningReceipt,
    String? ocrError,
    OcrParseResult? pendingOcrResult,

    // Original transaction source
    required TransactionSource source,
  }) = _AddTransactionState;
}

class AddTransactionViewModel extends Notifier<AddTransactionState> {
  String _lastTranscript = '';
  bool _seededCategories = false;

  @override
  AddTransactionState build() {
    ref.listen(categoriesProvider, (previous, next) {
      next.whenOrNull(
        data: (list) {
          state = state.copyWith(categories: list, isLoadingCategories: false);
          if (list.isEmpty && !_seededCategories) {
            _seedCategories();
          }
        },
      );
      next.whenOrNull(
        error: (error, _) {
          state = state.copyWith(isLoadingCategories: false);
          if (!_seededCategories) {
            _seedCategories();
          }
        },
      );
    });

    final categoriesAsync = ref.read(categoriesProvider);
    final initialCategories = categoriesAsync.value ?? [];

    // If provider already emitted empty data before listener was attached,
    // seed proactively (listener won't fire on unchanged value).
    if (initialCategories.isEmpty &&
        categoriesAsync is AsyncData<List<Category>> &&
        !_seededCategories) {
      _seedCategories();
    }

    return AddTransactionState(
      amountString: '0',
      type: TransactionType.expense,
      selectedCategoryId: null,
      transactionDate: DateTime.now(),
      note: '',
      merchantName: null,
      categories: initialCategories,
      isLoadingCategories: initialCategories.isEmpty,
      isSaving: false,
      isRecording: false,
      isProcessingVoice: false,
      isScanningReceipt: false,
      ocrError: null,
      pendingOcrResult: null,
      source: TransactionSource.manual,
    );
  }

  bool _isSaveEnabled(AddTransactionState s) {
    final amount = double.tryParse(s.amountString) ?? 0.0;
    return amount > 0;
  }

  void _logSaveState(String source) {
    final amount = double.tryParse(state.amountString) ?? 0.0;
    developer.log(
      '[AddTx] $source | amount=$amount amountStr=${state.amountString} '
      'category=${state.selectedCategoryId} '
      'saveEnabled=${_isSaveEnabled(state)}',
      name: 'PocketPlus.Debug',
    );
  }

  void _seedCategories() {
    _seededCategories = true;
    final userId = ref.read(currentBookUserIdProvider);
    if (userId != null) {
      ref
          .read(categoryRepositoryProvider)
          .seedSystemCategoriesIfEmpty(userId: userId);
    }
  }

  void pressKey(String key) {
    // Clear voice error
    state = state.copyWith(voiceError: null);

    if (key == 'backspace') {
      if (state.amountString.isEmpty || state.amountString == '0') {
        state = state.copyWith(amountString: '0');
        _logSaveState('pressKey(backspace-zero)');
        return;
      }
      final newString =
          state.amountString.substring(0, state.amountString.length - 1);
      state = state.copyWith(amountString: newString.isEmpty ? '0' : newString);
      _logSaveState('pressKey(backspace)');
      return;
    }

    if (key == '.') {
      if (state.amountString.contains('.')) {
        _logSaveState('pressKey(dot-rejected)');
        return;
      }
      state = state.copyWith(amountString: '${state.amountString}.');
      _logSaveState('pressKey(dot)');
      return;
    }

    // Key is a digit (0-9)
    // Validate maximum 8 digits (excluding decimal point)
    final digitsCount = state.amountString.replaceAll('.', '').length;
    if (digitsCount >= 8) {
      _logSaveState('pressKey(max-digits)');
      return;
    }

    // Validate maximum 2 decimal places
    if (state.amountString.contains('.')) {
      final parts = state.amountString.split('.');
      if (parts.length > 1 && parts[1].length >= 2) {
        _logSaveState('pressKey(max-decimals)');
        return;
      }
    }

    if (state.amountString == '0') {
      if (key == '0') {
        _logSaveState('pressKey(leading-zero)');
        return;
      }
      state = state.copyWith(amountString: key);
    } else {
      state = state.copyWith(amountString: '${state.amountString}$key');
    }
    _logSaveState('pressKey(digit)');
  }

  void toggleType() {
    final nextType = state.type == TransactionType.income
        ? TransactionType.expense
        : TransactionType.income;
    state = state.copyWith(
      type: nextType,
      selectedCategoryId: null,
      voiceError: null,
    );
    _logSaveState('toggleType');
  }

  void selectCategory(String? categoryId) {
    state = state.copyWith(
      selectedCategoryId: categoryId,
      voiceError: null,
    );
    _logSaveState('selectCategory');
  }

  void changeDate(DateTime date) {
    // Acceptance criterion: Future dates rejected with error.
    final now = DateTime.now();
    // Allow today + 1 day tolerance per spec (today plus 24 hours)
    final tomorrowEnd = DateTime(now.year, now.month, now.day)
        .add(const Duration(days: 1, hours: 23, minutes: 59));
    if (date.isAfter(tomorrowEnd)) {
      state = state.copyWith(voiceError: ErrorCodes.futureDatesNotAllowed);
      return;
    }

    state = state.copyWith(
      transactionDate: date,
      voiceError: null,
    );
  }

  void changeNote(String note) {
    if (note.length > 500) return;
    state = state.copyWith(
      note: note,
      voiceError: null,
    );
  }

  void clearVoiceError() {
    state = state.copyWith(voiceError: null);
  }

  Future<void> startRecording() async {
    state = state.copyWith(voiceError: null);

    final permissionService = ref.read(voicePermissionServiceProvider);
    final status = await permissionService.requestPermission();

    if (status.isDenied) {
      state = state.copyWith(voiceError: 'permission_denied');
      return;
    }
    if (status.isPermanentlyDenied) {
      state = state.copyWith(voiceError: 'permission_permanently_denied');
      return;
    }

    // Permission is granted
    state = state.copyWith(isRecording: true, voiceError: null);
    _lastTranscript = '';

    final speechService = ref.read(speechServiceProvider);
    final initialized = await speechService.initialize(
      onStatus: (status) {
        if (status == 'notListening' && state.isRecording) {
          stopRecording();
        }
      },
      onError: (error) {
        if (ref.mounted) {
          state = state.copyWith(
            isRecording: false,
            voiceError: 'Speech error: $error',
          );
        }
      },
    );

    if (initialized) {
      await speechService.startListening(
        onResult: (text) {
          _lastTranscript = text;
        },
      );
    } else {
      state = state.copyWith(
        isRecording: false,
        voiceError: ErrorCodes.couldNotInitializeSpeech,
      );
    }
  }

  Future<void> stopRecording() async {
    if (!state.isRecording) return;

    state = state.copyWith(isRecording: false);
    await ref.read(speechServiceProvider).stopListening();

    await _processTranscript(_lastTranscript);
  }

  Future<void> _processTranscript(String transcript) async {
    if (transcript.trim().isEmpty) {
      state = state.copyWith(
        voiceError: ErrorCodes.couldNotUnderstand,
      );
      return;
    }

    state = state.copyWith(isProcessingVoice: true, voiceError: null);

    // Language detection for analytics: check for Devanagari characters
    final isHindi = RegExp(r'[\u0900-\u097F]').hasMatch(transcript);
    final language = isHindi ? 'hi' : 'en';

    VoiceParseResult? result;
    try {
      // Run Gemini voice parser
      final parser = ref.read(geminiVoiceParserProvider);
      result = await parser.parse(transcript, state.categories);
    } on GeminiRateLimitException catch (e) {
      state = state.copyWith(
        isProcessingVoice: false,
        voiceError: 'AI limit reached — try again in ${e.retryAfterLabel}.',
      );
      return;
    } catch (e) {
      state = state.copyWith(
        isProcessingVoice: false,
        voiceError: ErrorCodes.couldNotProcessVoice,
      );

      // Fire analytics failed due to error
      ref.read(analyticsServiceProvider).logVoiceEntryUsed(
            parsedSuccessfully: false,
            language: language,
          );
      return;
    }

    final voiceResult = result;
    if (voiceResult == null || voiceResult.amount == null) {
      state = state.copyWith(
        isProcessingVoice: false,
        voiceError: ErrorCodes.couldNotUnderstand,
      );

      // Fire analytics failed
      ref.read(analyticsServiceProvider).logVoiceEntryUsed(
            parsedSuccessfully: false,
            language: language,
          );
      return;
    }

    // Successful parse
    // Verify that manual form pre-fill does NOT override manually entered data if user already typed
    final currentAmount = double.tryParse(state.amountString) ?? 0.0;
    final userHasTyped = currentAmount > 0 ||
        state.note.isNotEmpty ||
        state.selectedCategoryId != null;

    if (userHasTyped) {
      // Keep existing data, just set isProcessingVoice to false
      state = state.copyWith(isProcessingVoice: false);

      // Fire analytics
      ref.read(analyticsServiceProvider).logVoiceEntryUsed(
            parsedSuccessfully: true,
            language: language,
          );
      return;
    }

    // Pre-fill the form
    final paise = voiceResult.amount!;
    final doubleVal = paise / 100;
    final amountString = doubleVal % 1 == 0
        ? doubleVal.toInt().toString()
        : doubleVal.toStringAsFixed(2);

    // Match category
    final categoryIdExists =
        state.categories.any((c) => c.id == voiceResult.categoryId);
    final categoryId = categoryIdExists ? voiceResult.categoryId : null;

    state = state.copyWith(
      amountString: amountString,
      type: voiceResult.type,
      selectedCategoryId: categoryId,
      note: voiceResult.note ?? '',
      source: TransactionSource.voice,
      isProcessingVoice: false,
    );

    // Fire analytics
    ref.read(analyticsServiceProvider).logVoiceEntryUsed(
          parsedSuccessfully: true,
          language: language,
        );
  }

  Future<bool> saveTransaction() async {
    final amountDouble = double.tryParse(state.amountString) ?? 0.0;
    final amountPaise = (amountDouble * 100).round();

    if (amountPaise <= 0) {
      state = state.copyWith(saveError: ErrorCodes.enterAmountAndCategory);
      return false;
    }

    // Auto-assign to "Unaccounted" if no category selected. Such transactions
    // are flagged for deferred categorization so the background service can
    // assign a real category once the device is online.
    final hasUserCategory = state.selectedCategoryId != null;
    final categoryId =
        state.selectedCategoryId ?? 'sys_unaccounted_${state.type.name}';

    return _performSave(
      amountPaise,
      categoryId,
      needsCategorization: !hasUserCategory,
    );
  }

  Future<bool> _performSave(
    int amountPaise,
    String categoryId, {
    bool needsCategorization = false,
  }) async {
    // Validate amount upper limit ₹10,00,000 (1 crore paise)
    if (amountPaise >= 100000000) {
      state = state.copyWith(saveError: ErrorCodes.amountExceedsMax);
      return false;
    }

    state = state.copyWith(isSaving: true, saveError: null);

    try {
      final profile = ref.read(currentProfileProvider);
      final userId = profile?.userId;
      final profileId = profile?.id;

      if (userId == null || profileId == null) {
        state = state.copyWith(
          isSaving: false,
          saveError: ErrorCodes.userNotLoggedIn,
        );
        return false;
      }

      final now = DateTime.now();
      final transaction = Transaction(
        id: const Uuid().v4(),
        userId: userId,
        profileId: profileId,
        amount: amountPaise,
        type: state.type,
        source: state.source,
        categoryId: categoryId,
        needsCategorization: needsCategorization,
        merchantName: state.merchantName?.trim().isEmpty ?? true
            ? null
            : state.merchantName?.trim(),
        note: state.note.trim().isEmpty ? null : state.note.trim(),
        transactionDate: state.transactionDate,
        createdAt: now,
        updatedAt: now,
      );

      final result = await ref
          .read(transactionRepositoryProvider)
          .createTransaction(transaction);

      return await result.fold(
        (failure) {
          state = state.copyWith(isSaving: false, saveError: failure.message);
          return false;
        },
        (_) {
          state = state.copyWith(isSaving: false);
          ref.read(analyticsServiceProvider).logTransactionCreated(
                source: transaction.source.name.toUpperCase(),
                type: transaction.type.name.toUpperCase(),
                categoryId: transaction.categoryId ?? 'none',
                profileId: transaction.profileId,
                amountBucket:
                    AnalyticsService.getAmountBucket(transaction.amount),
              );
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(isSaving: false, saveError: e.toString());
      return false;
    }
  }

  Future<void> scanReceipt() async {
    state = state.copyWith(ocrError: null, pendingOcrResult: null);

    final picker = ref.read(imagePickerProvider);
    XFile? image;
    try {
      image = await picker.pickImage(source: ImageSource.camera);
    } catch (_) {
      state = state.copyWith(
        ocrError: ErrorCodes.cameraAccessFailed,
      );
      return;
    }

    if (image == null) return;

    state = state.copyWith(isScanningReceipt: true, ocrError: null);

    try {
      final parser = ref.read(geminiOcrParserProvider);
      final result = await parser.parseReceipt(File(image.path));

      if (result == null) {
        state = state.copyWith(
          isScanningReceipt: false,
          ocrError: ErrorCodes.couldNotReadAmount,
        );
        ref.read(analyticsServiceProvider).logReceiptScanned(
              parsedSuccessfully: false,
            );
        return;
      }

      if (result.isBlurry) {
        state = state.copyWith(
          isScanningReceipt: false,
          ocrError: ErrorCodes.couldNotReadBill,
        );
        ref.read(analyticsServiceProvider).logReceiptScanned(
              parsedSuccessfully: false,
            );
        return;
      }

      if (result.isNoReceipt) {
        state = state.copyWith(
          isScanningReceipt: false,
          ocrError: ErrorCodes.noReceiptFound,
        );
        ref.read(analyticsServiceProvider).logReceiptScanned(
              parsedSuccessfully: false,
            );
        return;
      }

      if (result.isForeignCurrency) {
        state = state.copyWith(
          isScanningReceipt: false,
          pendingOcrResult: result,
        );
        return;
      }

      if (result.amount == null) {
        state = state.copyWith(
          isScanningReceipt: false,
          ocrError: ErrorCodes.couldNotReadAmount,
        );
        ref.read(analyticsServiceProvider).logReceiptScanned(
              parsedSuccessfully: false,
            );
        return;
      }

      // Success: pre-fill form fields
      final paise = result.amount!;
      final doubleVal = paise / 100;
      final amountString = doubleVal % 1 == 0
          ? doubleVal.toInt().toString()
          : doubleVal.toStringAsFixed(2);

      state = state.copyWith(
        amountString: amountString,
        merchantName: result.merchantName,
        transactionDate: result.transactionDate ?? state.transactionDate,
        source: TransactionSource.ocr,
        isScanningReceipt: false,
      );

      ref.read(analyticsServiceProvider).logReceiptScanned(
            parsedSuccessfully: true,
          );
    } on GeminiRateLimitException catch (e) {
      state = state.copyWith(
        isScanningReceipt: false,
        ocrError: 'AI limit reached — try again in ${e.retryAfterLabel}.',
      );
    } catch (_) {
      state = state.copyWith(
        isScanningReceipt: false,
        ocrError: ErrorCodes.couldNotReadBill,
      );
      ref.read(analyticsServiceProvider).logReceiptScanned(
            parsedSuccessfully: false,
          );
    }
  }

  void acceptPendingOcrResult() {
    final result = state.pendingOcrResult;
    if (result == null) return;

    final amountVal = result.amount;
    String amountString = state.amountString;
    if (amountVal != null) {
      final doubleVal = amountVal / 100;
      amountString = doubleVal % 1 == 0
          ? doubleVal.toInt().toString()
          : doubleVal.toStringAsFixed(2);
    }

    state = state.copyWith(
      amountString: amountString,
      merchantName: result.merchantName,
      transactionDate: result.transactionDate ?? state.transactionDate,
      source: TransactionSource.ocr,
      pendingOcrResult: null,
      ocrError: null,
    );

    ref.read(analyticsServiceProvider).logReceiptScanned(
          parsedSuccessfully: true,
        );
  }

  void rejectPendingOcrResult() {
    state = state.copyWith(
      pendingOcrResult: null,
      ocrError: null,
    );

    ref.read(analyticsServiceProvider).logReceiptScanned(
          parsedSuccessfully: false,
        );
  }

  void clearOcrError() {
    state = state.copyWith(ocrError: null);
  }
}

final addTransactionViewModelProvider =
    NotifierProvider.autoDispose<AddTransactionViewModel, AddTransactionState>(
  AddTransactionViewModel.new,
);

final imagePickerProvider = Provider<ImagePicker>((ref) {
  return ImagePicker();
});
