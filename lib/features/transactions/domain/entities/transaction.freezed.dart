// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Transaction {
  String get id;
  String get userId;
  String get profileId;
  int get amount;
  @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
  TransactionType get type;
  @JsonKey(fromJson: _sourceFromFirestore, toJson: _sourceToFirestore)
  TransactionSource get source;
  String? get categoryId;
  String? get merchantName;
  String? get note;
  String get currency;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get transactionDate;
  String? get rawSmsText;
  String? get smsHash;
  String? get geminiCategory;
  double? get geminiConfidence;

  /// True when the transaction was saved with a placeholder category (e.g.
  /// saved offline or before Gemini could categorise it). The background
  /// deferred-categorization service picks these up once the device is back
  /// online and attempts to assign a real category.
  bool get needsCategorization;
  String? get invoiceId;
  String? get recurringId;
  @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
  SyncStatus get syncStatus;
  bool get isDeleted;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get createdAt;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get updatedAt;
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? get deletedAt;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionCopyWith<Transaction> get copyWith =>
      _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Transaction &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.rawSmsText, rawSmsText) ||
                other.rawSmsText == rawSmsText) &&
            (identical(other.smsHash, smsHash) || other.smsHash == smsHash) &&
            (identical(other.geminiCategory, geminiCategory) ||
                other.geminiCategory == geminiCategory) &&
            (identical(other.geminiConfidence, geminiConfidence) ||
                other.geminiConfidence == geminiConfidence) &&
            (identical(other.needsCategorization, needsCategorization) ||
                other.needsCategorization == needsCategorization) &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.recurringId, recurringId) ||
                other.recurringId == recurringId) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        profileId,
        amount,
        type,
        source,
        categoryId,
        merchantName,
        note,
        currency,
        transactionDate,
        rawSmsText,
        smsHash,
        geminiCategory,
        geminiConfidence,
        needsCategorization,
        invoiceId,
        recurringId,
        syncStatus,
        isDeleted,
        createdAt,
        updatedAt,
        deletedAt
      ]);

  @override
  String toString() {
    return 'Transaction(id: $id, userId: $userId, profileId: $profileId, amount: $amount, type: $type, source: $source, categoryId: $categoryId, merchantName: $merchantName, note: $note, currency: $currency, transactionDate: $transactionDate, rawSmsText: $rawSmsText, smsHash: $smsHash, geminiCategory: $geminiCategory, geminiConfidence: $geminiConfidence, needsCategorization: $needsCategorization, invoiceId: $invoiceId, recurringId: $recurringId, syncStatus: $syncStatus, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) _then) =
      _$TransactionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String profileId,
      int amount,
      @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
      TransactionType type,
      @JsonKey(fromJson: _sourceFromFirestore, toJson: _sourceToFirestore)
      TransactionSource source,
      String? categoryId,
      String? merchantName,
      String? note,
      String currency,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime transactionDate,
      String? rawSmsText,
      String? smsHash,
      String? geminiCategory,
      double? geminiConfidence,
      bool needsCategorization,
      String? invoiceId,
      String? recurringId,
      @JsonKey(
          fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
      SyncStatus syncStatus,
      bool isDeleted,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime updatedAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? deletedAt});
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res> implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileId = null,
    Object? amount = null,
    Object? type = null,
    Object? source = null,
    Object? categoryId = freezed,
    Object? merchantName = freezed,
    Object? note = freezed,
    Object? currency = null,
    Object? transactionDate = null,
    Object? rawSmsText = freezed,
    Object? smsHash = freezed,
    Object? geminiCategory = freezed,
    Object? geminiConfidence = freezed,
    Object? needsCategorization = null,
    Object? invoiceId = freezed,
    Object? recurringId = freezed,
    Object? syncStatus = null,
    Object? isDeleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: null == profileId
          ? _self.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as TransactionSource,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantName: freezed == merchantName
          ? _self.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _self.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rawSmsText: freezed == rawSmsText
          ? _self.rawSmsText
          : rawSmsText // ignore: cast_nullable_to_non_nullable
              as String?,
      smsHash: freezed == smsHash
          ? _self.smsHash
          : smsHash // ignore: cast_nullable_to_non_nullable
              as String?,
      geminiCategory: freezed == geminiCategory
          ? _self.geminiCategory
          : geminiCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      geminiConfidence: freezed == geminiConfidence
          ? _self.geminiConfidence
          : geminiConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      needsCategorization: null == needsCategorization
          ? _self.needsCategorization
          : needsCategorization // ignore: cast_nullable_to_non_nullable
              as bool,
      invoiceId: freezed == invoiceId
          ? _self.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      recurringId: freezed == recurringId
          ? _self.recurringId
          : recurringId // ignore: cast_nullable_to_non_nullable
              as String?,
      syncStatus: null == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
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
    TResult Function(_Transaction value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Transaction() when $default != null:
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
    TResult Function(_Transaction value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Transaction():
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
    TResult? Function(_Transaction value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Transaction() when $default != null:
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
            String id,
            String userId,
            String profileId,
            int amount,
            @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
            TransactionType type,
            @JsonKey(fromJson: _sourceFromFirestore, toJson: _sourceToFirestore)
            TransactionSource source,
            String? categoryId,
            String? merchantName,
            String? note,
            String currency,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime transactionDate,
            String? rawSmsText,
            String? smsHash,
            String? geminiCategory,
            double? geminiConfidence,
            bool needsCategorization,
            String? invoiceId,
            String? recurringId,
            @JsonKey(
                fromJson: _syncStatusFromFirestore,
                toJson: _syncStatusToFirestore)
            SyncStatus syncStatus,
            bool isDeleted,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime updatedAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Transaction() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.amount,
            _that.type,
            _that.source,
            _that.categoryId,
            _that.merchantName,
            _that.note,
            _that.currency,
            _that.transactionDate,
            _that.rawSmsText,
            _that.smsHash,
            _that.geminiCategory,
            _that.geminiConfidence,
            _that.needsCategorization,
            _that.invoiceId,
            _that.recurringId,
            _that.syncStatus,
            _that.isDeleted,
            _that.createdAt,
            _that.updatedAt,
            _that.deletedAt);
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
            String id,
            String userId,
            String profileId,
            int amount,
            @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
            TransactionType type,
            @JsonKey(fromJson: _sourceFromFirestore, toJson: _sourceToFirestore)
            TransactionSource source,
            String? categoryId,
            String? merchantName,
            String? note,
            String currency,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime transactionDate,
            String? rawSmsText,
            String? smsHash,
            String? geminiCategory,
            double? geminiConfidence,
            bool needsCategorization,
            String? invoiceId,
            String? recurringId,
            @JsonKey(
                fromJson: _syncStatusFromFirestore,
                toJson: _syncStatusToFirestore)
            SyncStatus syncStatus,
            bool isDeleted,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime updatedAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Transaction():
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.amount,
            _that.type,
            _that.source,
            _that.categoryId,
            _that.merchantName,
            _that.note,
            _that.currency,
            _that.transactionDate,
            _that.rawSmsText,
            _that.smsHash,
            _that.geminiCategory,
            _that.geminiConfidence,
            _that.needsCategorization,
            _that.invoiceId,
            _that.recurringId,
            _that.syncStatus,
            _that.isDeleted,
            _that.createdAt,
            _that.updatedAt,
            _that.deletedAt);
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
            String id,
            String userId,
            String profileId,
            int amount,
            @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
            TransactionType type,
            @JsonKey(fromJson: _sourceFromFirestore, toJson: _sourceToFirestore)
            TransactionSource source,
            String? categoryId,
            String? merchantName,
            String? note,
            String currency,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime transactionDate,
            String? rawSmsText,
            String? smsHash,
            String? geminiCategory,
            double? geminiConfidence,
            bool needsCategorization,
            String? invoiceId,
            String? recurringId,
            @JsonKey(
                fromJson: _syncStatusFromFirestore,
                toJson: _syncStatusToFirestore)
            SyncStatus syncStatus,
            bool isDeleted,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime updatedAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Transaction() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.amount,
            _that.type,
            _that.source,
            _that.categoryId,
            _that.merchantName,
            _that.note,
            _that.currency,
            _that.transactionDate,
            _that.rawSmsText,
            _that.smsHash,
            _that.geminiCategory,
            _that.geminiConfidence,
            _that.needsCategorization,
            _that.invoiceId,
            _that.recurringId,
            _that.syncStatus,
            _that.isDeleted,
            _that.createdAt,
            _that.updatedAt,
            _that.deletedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Transaction implements Transaction {
  const _Transaction(
      {required this.id,
      required this.userId,
      required this.profileId,
      required this.amount,
      @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
      required this.type,
      @JsonKey(fromJson: _sourceFromFirestore, toJson: _sourceToFirestore)
      required this.source,
      this.categoryId,
      this.merchantName,
      this.note,
      this.currency = 'INR',
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.transactionDate,
      this.rawSmsText,
      this.smsHash,
      this.geminiCategory,
      this.geminiConfidence,
      this.needsCategorization = false,
      this.invoiceId,
      this.recurringId,
      @JsonKey(
          fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
      this.syncStatus = SyncStatus.pending,
      this.isDeleted = false,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.createdAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.updatedAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      this.deletedAt});
  factory _Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String profileId;
  @override
  final int amount;
  @override
  @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
  final TransactionType type;
  @override
  @JsonKey(fromJson: _sourceFromFirestore, toJson: _sourceToFirestore)
  final TransactionSource source;
  @override
  final String? categoryId;
  @override
  final String? merchantName;
  @override
  final String? note;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime transactionDate;
  @override
  final String? rawSmsText;
  @override
  final String? smsHash;
  @override
  final String? geminiCategory;
  @override
  final double? geminiConfidence;

  /// True when the transaction was saved with a placeholder category (e.g.
  /// saved offline or before Gemini could categorise it). The background
  /// deferred-categorization service picks these up once the device is back
  /// online and attempts to assign a real category.
  @override
  @JsonKey()
  final bool needsCategorization;
  @override
  final String? invoiceId;
  @override
  final String? recurringId;
  @override
  @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
  final SyncStatus syncStatus;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime updatedAt;
  @override
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime? deletedAt;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionCopyWith<_Transaction> get copyWith =>
      __$TransactionCopyWithImpl<_Transaction>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Transaction &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.rawSmsText, rawSmsText) ||
                other.rawSmsText == rawSmsText) &&
            (identical(other.smsHash, smsHash) || other.smsHash == smsHash) &&
            (identical(other.geminiCategory, geminiCategory) ||
                other.geminiCategory == geminiCategory) &&
            (identical(other.geminiConfidence, geminiConfidence) ||
                other.geminiConfidence == geminiConfidence) &&
            (identical(other.needsCategorization, needsCategorization) ||
                other.needsCategorization == needsCategorization) &&
            (identical(other.invoiceId, invoiceId) ||
                other.invoiceId == invoiceId) &&
            (identical(other.recurringId, recurringId) ||
                other.recurringId == recurringId) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        profileId,
        amount,
        type,
        source,
        categoryId,
        merchantName,
        note,
        currency,
        transactionDate,
        rawSmsText,
        smsHash,
        geminiCategory,
        geminiConfidence,
        needsCategorization,
        invoiceId,
        recurringId,
        syncStatus,
        isDeleted,
        createdAt,
        updatedAt,
        deletedAt
      ]);

  @override
  String toString() {
    return 'Transaction(id: $id, userId: $userId, profileId: $profileId, amount: $amount, type: $type, source: $source, categoryId: $categoryId, merchantName: $merchantName, note: $note, currency: $currency, transactionDate: $transactionDate, rawSmsText: $rawSmsText, smsHash: $smsHash, geminiCategory: $geminiCategory, geminiConfidence: $geminiConfidence, needsCategorization: $needsCategorization, invoiceId: $invoiceId, recurringId: $recurringId, syncStatus: $syncStatus, isDeleted: $isDeleted, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(
          _Transaction value, $Res Function(_Transaction) _then) =
      __$TransactionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String profileId,
      int amount,
      @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
      TransactionType type,
      @JsonKey(fromJson: _sourceFromFirestore, toJson: _sourceToFirestore)
      TransactionSource source,
      String? categoryId,
      String? merchantName,
      String? note,
      String currency,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime transactionDate,
      String? rawSmsText,
      String? smsHash,
      String? geminiCategory,
      double? geminiConfidence,
      bool needsCategorization,
      String? invoiceId,
      String? recurringId,
      @JsonKey(
          fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
      SyncStatus syncStatus,
      bool isDeleted,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime updatedAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? deletedAt});
}

/// @nodoc
class __$TransactionCopyWithImpl<$Res> implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileId = null,
    Object? amount = null,
    Object? type = null,
    Object? source = null,
    Object? categoryId = freezed,
    Object? merchantName = freezed,
    Object? note = freezed,
    Object? currency = null,
    Object? transactionDate = null,
    Object? rawSmsText = freezed,
    Object? smsHash = freezed,
    Object? geminiCategory = freezed,
    Object? geminiConfidence = freezed,
    Object? needsCategorization = null,
    Object? invoiceId = freezed,
    Object? recurringId = freezed,
    Object? syncStatus = null,
    Object? isDeleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_Transaction(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: null == profileId
          ? _self.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as TransactionSource,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      merchantName: freezed == merchantName
          ? _self.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      transactionDate: null == transactionDate
          ? _self.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      rawSmsText: freezed == rawSmsText
          ? _self.rawSmsText
          : rawSmsText // ignore: cast_nullable_to_non_nullable
              as String?,
      smsHash: freezed == smsHash
          ? _self.smsHash
          : smsHash // ignore: cast_nullable_to_non_nullable
              as String?,
      geminiCategory: freezed == geminiCategory
          ? _self.geminiCategory
          : geminiCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      geminiConfidence: freezed == geminiConfidence
          ? _self.geminiConfidence
          : geminiConfidence // ignore: cast_nullable_to_non_nullable
              as double?,
      needsCategorization: null == needsCategorization
          ? _self.needsCategorization
          : needsCategorization // ignore: cast_nullable_to_non_nullable
              as bool,
      invoiceId: freezed == invoiceId
          ? _self.invoiceId
          : invoiceId // ignore: cast_nullable_to_non_nullable
              as String?,
      recurringId: freezed == recurringId
          ? _self.recurringId
          : recurringId // ignore: cast_nullable_to_non_nullable
              as String?,
      syncStatus: null == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
