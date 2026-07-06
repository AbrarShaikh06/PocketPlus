// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_transaction_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddTransactionState {
  String get amountString;
  TransactionType get type;
  String? get selectedCategoryId;
  DateTime get transactionDate;
  String get note;
  String? get merchantName;
  List<Category> get categories;
  bool get isLoadingCategories;
  bool get isSaving;
  String? get saveError;
  bool get isRecording;
  bool get isProcessingVoice;
  String? get voiceError;
  bool get isScanningReceipt;
  String? get ocrError;
  OcrParseResult? get pendingOcrResult;
  TransactionSource get source;

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddTransactionStateCopyWith<AddTransactionState> get copyWith =>
      _$AddTransactionStateCopyWithImpl<AddTransactionState>(
          this as AddTransactionState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddTransactionState &&
            (identical(other.amountString, amountString) ||
                other.amountString == amountString) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            (identical(other.isLoadingCategories, isLoadingCategories) ||
                other.isLoadingCategories == isLoadingCategories) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError) &&
            (identical(other.isRecording, isRecording) ||
                other.isRecording == isRecording) &&
            (identical(other.isProcessingVoice, isProcessingVoice) ||
                other.isProcessingVoice == isProcessingVoice) &&
            (identical(other.voiceError, voiceError) ||
                other.voiceError == voiceError) &&
            (identical(other.isScanningReceipt, isScanningReceipt) ||
                other.isScanningReceipt == isScanningReceipt) &&
            (identical(other.ocrError, ocrError) ||
                other.ocrError == ocrError) &&
            (identical(other.pendingOcrResult, pendingOcrResult) ||
                other.pendingOcrResult == pendingOcrResult) &&
            (identical(other.source, source) || other.source == source));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      amountString,
      type,
      selectedCategoryId,
      transactionDate,
      note,
      merchantName,
      const DeepCollectionEquality().hash(categories),
      isLoadingCategories,
      isSaving,
      saveError,
      isRecording,
      isProcessingVoice,
      voiceError,
      isScanningReceipt,
      ocrError,
      pendingOcrResult,
      source);

  @override
  String toString() {
    return 'AddTransactionState(amountString: $amountString, type: $type, selectedCategoryId: $selectedCategoryId, transactionDate: $transactionDate, note: $note, merchantName: $merchantName, categories: $categories, isLoadingCategories: $isLoadingCategories, isSaving: $isSaving, saveError: $saveError, isRecording: $isRecording, isProcessingVoice: $isProcessingVoice, voiceError: $voiceError, isScanningReceipt: $isScanningReceipt, ocrError: $ocrError, pendingOcrResult: $pendingOcrResult, source: $source)';
  }
}

/// @nodoc
abstract mixin class $AddTransactionStateCopyWith<$Res> {
  factory $AddTransactionStateCopyWith(
          AddTransactionState value, $Res Function(AddTransactionState) _then) =
      _$AddTransactionStateCopyWithImpl;
  @useResult
  $Res call(
      {String amountString,
      TransactionType type,
      String? selectedCategoryId,
      DateTime transactionDate,
      String note,
      String? merchantName,
      List<Category> categories,
      bool isLoadingCategories,
      bool isSaving,
      String? saveError,
      bool isRecording,
      bool isProcessingVoice,
      String? voiceError,
      bool isScanningReceipt,
      String? ocrError,
      OcrParseResult? pendingOcrResult,
      TransactionSource source});

  $OcrParseResultCopyWith<$Res>? get pendingOcrResult;
}

/// @nodoc
class _$AddTransactionStateCopyWithImpl<$Res>
    implements $AddTransactionStateCopyWith<$Res> {
  _$AddTransactionStateCopyWithImpl(this._self, this._then);

  final AddTransactionState _self;
  final $Res Function(AddTransactionState) _then;

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amountString = null,
    Object? type = null,
    Object? selectedCategoryId = freezed,
    Object? transactionDate = null,
    Object? note = null,
    Object? merchantName = freezed,
    Object? categories = null,
    Object? isLoadingCategories = null,
    Object? isSaving = null,
    Object? saveError = freezed,
    Object? isRecording = null,
    Object? isProcessingVoice = null,
    Object? voiceError = freezed,
    Object? isScanningReceipt = null,
    Object? ocrError = freezed,
    Object? pendingOcrResult = freezed,
    Object? source = null,
  }) {
    return _then(_self.copyWith(
      amountString: null == amountString
          ? _self.amountString
          : amountString // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      selectedCategoryId: freezed == selectedCategoryId
          ? _self.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionDate: null == transactionDate
          ? _self.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: null == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      merchantName: freezed == merchantName
          ? _self.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      isLoadingCategories: null == isLoadingCategories
          ? _self.isLoadingCategories
          : isLoadingCategories // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      saveError: freezed == saveError
          ? _self.saveError
          : saveError // ignore: cast_nullable_to_non_nullable
              as String?,
      isRecording: null == isRecording
          ? _self.isRecording
          : isRecording // ignore: cast_nullable_to_non_nullable
              as bool,
      isProcessingVoice: null == isProcessingVoice
          ? _self.isProcessingVoice
          : isProcessingVoice // ignore: cast_nullable_to_non_nullable
              as bool,
      voiceError: freezed == voiceError
          ? _self.voiceError
          : voiceError // ignore: cast_nullable_to_non_nullable
              as String?,
      isScanningReceipt: null == isScanningReceipt
          ? _self.isScanningReceipt
          : isScanningReceipt // ignore: cast_nullable_to_non_nullable
              as bool,
      ocrError: freezed == ocrError
          ? _self.ocrError
          : ocrError // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingOcrResult: freezed == pendingOcrResult
          ? _self.pendingOcrResult
          : pendingOcrResult // ignore: cast_nullable_to_non_nullable
              as OcrParseResult?,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as TransactionSource,
    ));
  }

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OcrParseResultCopyWith<$Res>? get pendingOcrResult {
    if (_self.pendingOcrResult == null) {
      return null;
    }

    return $OcrParseResultCopyWith<$Res>(_self.pendingOcrResult!, (value) {
      return _then(_self.copyWith(pendingOcrResult: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AddTransactionState].
extension AddTransactionStatePatterns on AddTransactionState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AddTransactionState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddTransactionState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AddTransactionState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddTransactionState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AddTransactionState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddTransactionState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String amountString,
            TransactionType type,
            String? selectedCategoryId,
            DateTime transactionDate,
            String note,
            String? merchantName,
            List<Category> categories,
            bool isLoadingCategories,
            bool isSaving,
            String? saveError,
            bool isRecording,
            bool isProcessingVoice,
            String? voiceError,
            bool isScanningReceipt,
            String? ocrError,
            OcrParseResult? pendingOcrResult,
            TransactionSource source)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddTransactionState() when $default != null:
        return $default(
            _that.amountString,
            _that.type,
            _that.selectedCategoryId,
            _that.transactionDate,
            _that.note,
            _that.merchantName,
            _that.categories,
            _that.isLoadingCategories,
            _that.isSaving,
            _that.saveError,
            _that.isRecording,
            _that.isProcessingVoice,
            _that.voiceError,
            _that.isScanningReceipt,
            _that.ocrError,
            _that.pendingOcrResult,
            _that.source);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String amountString,
            TransactionType type,
            String? selectedCategoryId,
            DateTime transactionDate,
            String note,
            String? merchantName,
            List<Category> categories,
            bool isLoadingCategories,
            bool isSaving,
            String? saveError,
            bool isRecording,
            bool isProcessingVoice,
            String? voiceError,
            bool isScanningReceipt,
            String? ocrError,
            OcrParseResult? pendingOcrResult,
            TransactionSource source)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddTransactionState():
        return $default(
            _that.amountString,
            _that.type,
            _that.selectedCategoryId,
            _that.transactionDate,
            _that.note,
            _that.merchantName,
            _that.categories,
            _that.isLoadingCategories,
            _that.isSaving,
            _that.saveError,
            _that.isRecording,
            _that.isProcessingVoice,
            _that.voiceError,
            _that.isScanningReceipt,
            _that.ocrError,
            _that.pendingOcrResult,
            _that.source);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String amountString,
            TransactionType type,
            String? selectedCategoryId,
            DateTime transactionDate,
            String note,
            String? merchantName,
            List<Category> categories,
            bool isLoadingCategories,
            bool isSaving,
            String? saveError,
            bool isRecording,
            bool isProcessingVoice,
            String? voiceError,
            bool isScanningReceipt,
            String? ocrError,
            OcrParseResult? pendingOcrResult,
            TransactionSource source)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddTransactionState() when $default != null:
        return $default(
            _that.amountString,
            _that.type,
            _that.selectedCategoryId,
            _that.transactionDate,
            _that.note,
            _that.merchantName,
            _that.categories,
            _that.isLoadingCategories,
            _that.isSaving,
            _that.saveError,
            _that.isRecording,
            _that.isProcessingVoice,
            _that.voiceError,
            _that.isScanningReceipt,
            _that.ocrError,
            _that.pendingOcrResult,
            _that.source);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AddTransactionState implements AddTransactionState {
  const _AddTransactionState(
      {required this.amountString,
      required this.type,
      this.selectedCategoryId,
      required this.transactionDate,
      required this.note,
      this.merchantName,
      required final List<Category> categories,
      required this.isLoadingCategories,
      required this.isSaving,
      this.saveError,
      required this.isRecording,
      required this.isProcessingVoice,
      this.voiceError,
      required this.isScanningReceipt,
      this.ocrError,
      this.pendingOcrResult,
      required this.source})
      : _categories = categories;

  @override
  final String amountString;
  @override
  final TransactionType type;
  @override
  final String? selectedCategoryId;
  @override
  final DateTime transactionDate;
  @override
  final String note;
  @override
  final String? merchantName;
  final List<Category> _categories;
  @override
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final bool isLoadingCategories;
  @override
  final bool isSaving;
  @override
  final String? saveError;
  @override
  final bool isRecording;
  @override
  final bool isProcessingVoice;
  @override
  final String? voiceError;
  @override
  final bool isScanningReceipt;
  @override
  final String? ocrError;
  @override
  final OcrParseResult? pendingOcrResult;
  @override
  final TransactionSource source;

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddTransactionStateCopyWith<_AddTransactionState> get copyWith =>
      __$AddTransactionStateCopyWithImpl<_AddTransactionState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddTransactionState &&
            (identical(other.amountString, amountString) ||
                other.amountString == amountString) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.isLoadingCategories, isLoadingCategories) ||
                other.isLoadingCategories == isLoadingCategories) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError) &&
            (identical(other.isRecording, isRecording) ||
                other.isRecording == isRecording) &&
            (identical(other.isProcessingVoice, isProcessingVoice) ||
                other.isProcessingVoice == isProcessingVoice) &&
            (identical(other.voiceError, voiceError) ||
                other.voiceError == voiceError) &&
            (identical(other.isScanningReceipt, isScanningReceipt) ||
                other.isScanningReceipt == isScanningReceipt) &&
            (identical(other.ocrError, ocrError) ||
                other.ocrError == ocrError) &&
            (identical(other.pendingOcrResult, pendingOcrResult) ||
                other.pendingOcrResult == pendingOcrResult) &&
            (identical(other.source, source) || other.source == source));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      amountString,
      type,
      selectedCategoryId,
      transactionDate,
      note,
      merchantName,
      const DeepCollectionEquality().hash(_categories),
      isLoadingCategories,
      isSaving,
      saveError,
      isRecording,
      isProcessingVoice,
      voiceError,
      isScanningReceipt,
      ocrError,
      pendingOcrResult,
      source);

  @override
  String toString() {
    return 'AddTransactionState(amountString: $amountString, type: $type, selectedCategoryId: $selectedCategoryId, transactionDate: $transactionDate, note: $note, merchantName: $merchantName, categories: $categories, isLoadingCategories: $isLoadingCategories, isSaving: $isSaving, saveError: $saveError, isRecording: $isRecording, isProcessingVoice: $isProcessingVoice, voiceError: $voiceError, isScanningReceipt: $isScanningReceipt, ocrError: $ocrError, pendingOcrResult: $pendingOcrResult, source: $source)';
  }
}

/// @nodoc
abstract mixin class _$AddTransactionStateCopyWith<$Res>
    implements $AddTransactionStateCopyWith<$Res> {
  factory _$AddTransactionStateCopyWith(_AddTransactionState value,
          $Res Function(_AddTransactionState) _then) =
      __$AddTransactionStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String amountString,
      TransactionType type,
      String? selectedCategoryId,
      DateTime transactionDate,
      String note,
      String? merchantName,
      List<Category> categories,
      bool isLoadingCategories,
      bool isSaving,
      String? saveError,
      bool isRecording,
      bool isProcessingVoice,
      String? voiceError,
      bool isScanningReceipt,
      String? ocrError,
      OcrParseResult? pendingOcrResult,
      TransactionSource source});

  @override
  $OcrParseResultCopyWith<$Res>? get pendingOcrResult;
}

/// @nodoc
class __$AddTransactionStateCopyWithImpl<$Res>
    implements _$AddTransactionStateCopyWith<$Res> {
  __$AddTransactionStateCopyWithImpl(this._self, this._then);

  final _AddTransactionState _self;
  final $Res Function(_AddTransactionState) _then;

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? amountString = null,
    Object? type = null,
    Object? selectedCategoryId = freezed,
    Object? transactionDate = null,
    Object? note = null,
    Object? merchantName = freezed,
    Object? categories = null,
    Object? isLoadingCategories = null,
    Object? isSaving = null,
    Object? saveError = freezed,
    Object? isRecording = null,
    Object? isProcessingVoice = null,
    Object? voiceError = freezed,
    Object? isScanningReceipt = null,
    Object? ocrError = freezed,
    Object? pendingOcrResult = freezed,
    Object? source = null,
  }) {
    return _then(_AddTransactionState(
      amountString: null == amountString
          ? _self.amountString
          : amountString // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      selectedCategoryId: freezed == selectedCategoryId
          ? _self.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionDate: null == transactionDate
          ? _self.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      note: null == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      merchantName: freezed == merchantName
          ? _self.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String?,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      isLoadingCategories: null == isLoadingCategories
          ? _self.isLoadingCategories
          : isLoadingCategories // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      saveError: freezed == saveError
          ? _self.saveError
          : saveError // ignore: cast_nullable_to_non_nullable
              as String?,
      isRecording: null == isRecording
          ? _self.isRecording
          : isRecording // ignore: cast_nullable_to_non_nullable
              as bool,
      isProcessingVoice: null == isProcessingVoice
          ? _self.isProcessingVoice
          : isProcessingVoice // ignore: cast_nullable_to_non_nullable
              as bool,
      voiceError: freezed == voiceError
          ? _self.voiceError
          : voiceError // ignore: cast_nullable_to_non_nullable
              as String?,
      isScanningReceipt: null == isScanningReceipt
          ? _self.isScanningReceipt
          : isScanningReceipt // ignore: cast_nullable_to_non_nullable
              as bool,
      ocrError: freezed == ocrError
          ? _self.ocrError
          : ocrError // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingOcrResult: freezed == pendingOcrResult
          ? _self.pendingOcrResult
          : pendingOcrResult // ignore: cast_nullable_to_non_nullable
              as OcrParseResult?,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as TransactionSource,
    ));
  }

  /// Create a copy of AddTransactionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OcrParseResultCopyWith<$Res>? get pendingOcrResult {
    if (_self.pendingOcrResult == null) {
      return null;
    }

    return $OcrParseResultCopyWith<$Res>(_self.pendingOcrResult!, (value) {
      return _then(_self.copyWith(pendingOcrResult: value));
    });
  }
}

// dart format on
