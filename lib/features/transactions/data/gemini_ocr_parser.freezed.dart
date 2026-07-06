// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gemini_ocr_parser.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OcrLineItem {
  String get description;
  int get amount;

  /// Create a copy of OcrLineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OcrLineItemCopyWith<OcrLineItem> get copyWith =>
      _$OcrLineItemCopyWithImpl<OcrLineItem>(this as OcrLineItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OcrLineItem &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, amount);

  @override
  String toString() {
    return 'OcrLineItem(description: $description, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class $OcrLineItemCopyWith<$Res> {
  factory $OcrLineItemCopyWith(
          OcrLineItem value, $Res Function(OcrLineItem) _then) =
      _$OcrLineItemCopyWithImpl;
  @useResult
  $Res call({String description, int amount});
}

/// @nodoc
class _$OcrLineItemCopyWithImpl<$Res> implements $OcrLineItemCopyWith<$Res> {
  _$OcrLineItemCopyWithImpl(this._self, this._then);

  final OcrLineItem _self;
  final $Res Function(OcrLineItem) _then;

  /// Create a copy of OcrLineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? amount = null,
  }) {
    return _then(_self.copyWith(
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [OcrLineItem].
extension OcrLineItemPatterns on OcrLineItem {
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
    TResult Function(_OcrLineItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OcrLineItem() when $default != null:
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
    TResult Function(_OcrLineItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OcrLineItem():
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
    TResult? Function(_OcrLineItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OcrLineItem() when $default != null:
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
    TResult Function(String description, int amount)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OcrLineItem() when $default != null:
        return $default(_that.description, _that.amount);
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
    TResult Function(String description, int amount) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OcrLineItem():
        return $default(_that.description, _that.amount);
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
    TResult? Function(String description, int amount)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OcrLineItem() when $default != null:
        return $default(_that.description, _that.amount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _OcrLineItem implements OcrLineItem {
  const _OcrLineItem({required this.description, required this.amount});

  @override
  final String description;
  @override
  final int amount;

  /// Create a copy of OcrLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OcrLineItemCopyWith<_OcrLineItem> get copyWith =>
      __$OcrLineItemCopyWithImpl<_OcrLineItem>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OcrLineItem &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, amount);

  @override
  String toString() {
    return 'OcrLineItem(description: $description, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class _$OcrLineItemCopyWith<$Res>
    implements $OcrLineItemCopyWith<$Res> {
  factory _$OcrLineItemCopyWith(
          _OcrLineItem value, $Res Function(_OcrLineItem) _then) =
      __$OcrLineItemCopyWithImpl;
  @override
  @useResult
  $Res call({String description, int amount});
}

/// @nodoc
class __$OcrLineItemCopyWithImpl<$Res> implements _$OcrLineItemCopyWith<$Res> {
  __$OcrLineItemCopyWithImpl(this._self, this._then);

  final _OcrLineItem _self;
  final $Res Function(_OcrLineItem) _then;

  /// Create a copy of OcrLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? description = null,
    Object? amount = null,
  }) {
    return _then(_OcrLineItem(
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$OcrParseResult {
  int? get amount;
  String? get merchantName;
  DateTime? get transactionDate;
  List<OcrLineItem>? get items;
  bool get isForeignCurrency;
  String? get currencyCode;
  bool get isNoReceipt;
  bool get isBlurry;

  /// Create a copy of OcrParseResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OcrParseResultCopyWith<OcrParseResult> get copyWith =>
      _$OcrParseResultCopyWithImpl<OcrParseResult>(
          this as OcrParseResult, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OcrParseResult &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.isForeignCurrency, isForeignCurrency) ||
                other.isForeignCurrency == isForeignCurrency) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.isNoReceipt, isNoReceipt) ||
                other.isNoReceipt == isNoReceipt) &&
            (identical(other.isBlurry, isBlurry) ||
                other.isBlurry == isBlurry));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      amount,
      merchantName,
      transactionDate,
      const DeepCollectionEquality().hash(items),
      isForeignCurrency,
      currencyCode,
      isNoReceipt,
      isBlurry);

  @override
  String toString() {
    return 'OcrParseResult(amount: $amount, merchantName: $merchantName, transactionDate: $transactionDate, items: $items, isForeignCurrency: $isForeignCurrency, currencyCode: $currencyCode, isNoReceipt: $isNoReceipt, isBlurry: $isBlurry)';
  }
}

/// @nodoc
abstract mixin class $OcrParseResultCopyWith<$Res> {
  factory $OcrParseResultCopyWith(
          OcrParseResult value, $Res Function(OcrParseResult) _then) =
      _$OcrParseResultCopyWithImpl;
  @useResult
  $Res call(
      {int? amount,
      String? merchantName,
      DateTime? transactionDate,
      List<OcrLineItem>? items,
      bool isForeignCurrency,
      String? currencyCode,
      bool isNoReceipt,
      bool isBlurry});
}

/// @nodoc
class _$OcrParseResultCopyWithImpl<$Res>
    implements $OcrParseResultCopyWith<$Res> {
  _$OcrParseResultCopyWithImpl(this._self, this._then);

  final OcrParseResult _self;
  final $Res Function(OcrParseResult) _then;

  /// Create a copy of OcrParseResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = freezed,
    Object? merchantName = freezed,
    Object? transactionDate = freezed,
    Object? items = freezed,
    Object? isForeignCurrency = null,
    Object? currencyCode = freezed,
    Object? isNoReceipt = null,
    Object? isBlurry = null,
  }) {
    return _then(_self.copyWith(
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
      merchantName: freezed == merchantName
          ? _self.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionDate: freezed == transactionDate
          ? _self.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: freezed == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OcrLineItem>?,
      isForeignCurrency: null == isForeignCurrency
          ? _self.isForeignCurrency
          : isForeignCurrency // ignore: cast_nullable_to_non_nullable
              as bool,
      currencyCode: freezed == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isNoReceipt: null == isNoReceipt
          ? _self.isNoReceipt
          : isNoReceipt // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlurry: null == isBlurry
          ? _self.isBlurry
          : isBlurry // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [OcrParseResult].
extension OcrParseResultPatterns on OcrParseResult {
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
    TResult Function(_OcrParseResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OcrParseResult() when $default != null:
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
    TResult Function(_OcrParseResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OcrParseResult():
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
    TResult? Function(_OcrParseResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OcrParseResult() when $default != null:
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
            int? amount,
            String? merchantName,
            DateTime? transactionDate,
            List<OcrLineItem>? items,
            bool isForeignCurrency,
            String? currencyCode,
            bool isNoReceipt,
            bool isBlurry)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _OcrParseResult() when $default != null:
        return $default(
            _that.amount,
            _that.merchantName,
            _that.transactionDate,
            _that.items,
            _that.isForeignCurrency,
            _that.currencyCode,
            _that.isNoReceipt,
            _that.isBlurry);
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
            int? amount,
            String? merchantName,
            DateTime? transactionDate,
            List<OcrLineItem>? items,
            bool isForeignCurrency,
            String? currencyCode,
            bool isNoReceipt,
            bool isBlurry)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OcrParseResult():
        return $default(
            _that.amount,
            _that.merchantName,
            _that.transactionDate,
            _that.items,
            _that.isForeignCurrency,
            _that.currencyCode,
            _that.isNoReceipt,
            _that.isBlurry);
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
            int? amount,
            String? merchantName,
            DateTime? transactionDate,
            List<OcrLineItem>? items,
            bool isForeignCurrency,
            String? currencyCode,
            bool isNoReceipt,
            bool isBlurry)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _OcrParseResult() when $default != null:
        return $default(
            _that.amount,
            _that.merchantName,
            _that.transactionDate,
            _that.items,
            _that.isForeignCurrency,
            _that.currencyCode,
            _that.isNoReceipt,
            _that.isBlurry);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _OcrParseResult implements OcrParseResult {
  const _OcrParseResult(
      {this.amount,
      this.merchantName,
      this.transactionDate,
      final List<OcrLineItem>? items,
      required this.isForeignCurrency,
      this.currencyCode,
      required this.isNoReceipt,
      required this.isBlurry})
      : _items = items;

  @override
  final int? amount;
  @override
  final String? merchantName;
  @override
  final DateTime? transactionDate;
  final List<OcrLineItem>? _items;
  @override
  List<OcrLineItem>? get items {
    final value = _items;
    if (value == null) return null;
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool isForeignCurrency;
  @override
  final String? currencyCode;
  @override
  final bool isNoReceipt;
  @override
  final bool isBlurry;

  /// Create a copy of OcrParseResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$OcrParseResultCopyWith<_OcrParseResult> get copyWith =>
      __$OcrParseResultCopyWithImpl<_OcrParseResult>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _OcrParseResult &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.isForeignCurrency, isForeignCurrency) ||
                other.isForeignCurrency == isForeignCurrency) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.isNoReceipt, isNoReceipt) ||
                other.isNoReceipt == isNoReceipt) &&
            (identical(other.isBlurry, isBlurry) ||
                other.isBlurry == isBlurry));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      amount,
      merchantName,
      transactionDate,
      const DeepCollectionEquality().hash(_items),
      isForeignCurrency,
      currencyCode,
      isNoReceipt,
      isBlurry);

  @override
  String toString() {
    return 'OcrParseResult(amount: $amount, merchantName: $merchantName, transactionDate: $transactionDate, items: $items, isForeignCurrency: $isForeignCurrency, currencyCode: $currencyCode, isNoReceipt: $isNoReceipt, isBlurry: $isBlurry)';
  }
}

/// @nodoc
abstract mixin class _$OcrParseResultCopyWith<$Res>
    implements $OcrParseResultCopyWith<$Res> {
  factory _$OcrParseResultCopyWith(
          _OcrParseResult value, $Res Function(_OcrParseResult) _then) =
      __$OcrParseResultCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? amount,
      String? merchantName,
      DateTime? transactionDate,
      List<OcrLineItem>? items,
      bool isForeignCurrency,
      String? currencyCode,
      bool isNoReceipt,
      bool isBlurry});
}

/// @nodoc
class __$OcrParseResultCopyWithImpl<$Res>
    implements _$OcrParseResultCopyWith<$Res> {
  __$OcrParseResultCopyWithImpl(this._self, this._then);

  final _OcrParseResult _self;
  final $Res Function(_OcrParseResult) _then;

  /// Create a copy of OcrParseResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? amount = freezed,
    Object? merchantName = freezed,
    Object? transactionDate = freezed,
    Object? items = freezed,
    Object? isForeignCurrency = null,
    Object? currencyCode = freezed,
    Object? isNoReceipt = null,
    Object? isBlurry = null,
  }) {
    return _then(_OcrParseResult(
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
      merchantName: freezed == merchantName
          ? _self.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionDate: freezed == transactionDate
          ? _self.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      items: freezed == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<OcrLineItem>?,
      isForeignCurrency: null == isForeignCurrency
          ? _self.isForeignCurrency
          : isForeignCurrency // ignore: cast_nullable_to_non_nullable
              as bool,
      currencyCode: freezed == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String?,
      isNoReceipt: null == isNoReceipt
          ? _self.isNoReceipt
          : isNoReceipt // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlurry: null == isBlurry
          ? _self.isBlurry
          : isBlurry // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
