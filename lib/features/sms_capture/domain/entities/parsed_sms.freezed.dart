// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parsed_sms.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParsedSms {
  int get amount;
  TransactionType get type;
  String? get merchantName;
  DateTime get transactionDate;
  String get smsHash;
  String get senderId;
  String get rawSmsText;
  String? get accountLast4;
  String get currencyCode;
  String? get mpesaCode;

  /// Create a copy of ParsedSms
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ParsedSmsCopyWith<ParsedSms> get copyWith =>
      _$ParsedSmsCopyWithImpl<ParsedSms>(this as ParsedSms, _$identity);

  /// Serializes this ParsedSms to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ParsedSms &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.smsHash, smsHash) || other.smsHash == smsHash) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.rawSmsText, rawSmsText) ||
                other.rawSmsText == rawSmsText) &&
            (identical(other.accountLast4, accountLast4) ||
                other.accountLast4 == accountLast4) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.mpesaCode, mpesaCode) ||
                other.mpesaCode == mpesaCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      amount,
      type,
      merchantName,
      transactionDate,
      smsHash,
      senderId,
      rawSmsText,
      accountLast4,
      currencyCode,
      mpesaCode);

  @override
  String toString() {
    return 'ParsedSms(amount: $amount, type: $type, merchantName: $merchantName, transactionDate: $transactionDate, smsHash: $smsHash, senderId: $senderId, rawSmsText: $rawSmsText, accountLast4: $accountLast4, currencyCode: $currencyCode, mpesaCode: $mpesaCode)';
  }
}

/// @nodoc
abstract mixin class $ParsedSmsCopyWith<$Res> {
  factory $ParsedSmsCopyWith(ParsedSms value, $Res Function(ParsedSms) _then) =
      _$ParsedSmsCopyWithImpl;
  @useResult
  $Res call(
      {int amount,
      TransactionType type,
      String? merchantName,
      DateTime transactionDate,
      String smsHash,
      String senderId,
      String rawSmsText,
      String? accountLast4,
      String currencyCode,
      String? mpesaCode});
}

/// @nodoc
class _$ParsedSmsCopyWithImpl<$Res> implements $ParsedSmsCopyWith<$Res> {
  _$ParsedSmsCopyWithImpl(this._self, this._then);

  final ParsedSms _self;
  final $Res Function(ParsedSms) _then;

  /// Create a copy of ParsedSms
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? type = null,
    Object? merchantName = freezed,
    Object? transactionDate = null,
    Object? smsHash = null,
    Object? senderId = null,
    Object? rawSmsText = null,
    Object? accountLast4 = freezed,
    Object? currencyCode = null,
    Object? mpesaCode = freezed,
  }) {
    return _then(_self.copyWith(
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      merchantName: freezed == merchantName
          ? _self.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionDate: null == transactionDate
          ? _self.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      smsHash: null == smsHash
          ? _self.smsHash
          : smsHash // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _self.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      rawSmsText: null == rawSmsText
          ? _self.rawSmsText
          : rawSmsText // ignore: cast_nullable_to_non_nullable
              as String,
      accountLast4: freezed == accountLast4
          ? _self.accountLast4
          : accountLast4 // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      mpesaCode: freezed == mpesaCode
          ? _self.mpesaCode
          : mpesaCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ParsedSms].
extension ParsedSmsPatterns on ParsedSms {
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
    TResult Function(_ParsedSms value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParsedSms() when $default != null:
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
    TResult Function(_ParsedSms value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParsedSms():
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
    TResult? Function(_ParsedSms value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParsedSms() when $default != null:
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
            int amount,
            TransactionType type,
            String? merchantName,
            DateTime transactionDate,
            String smsHash,
            String senderId,
            String rawSmsText,
            String? accountLast4,
            String currencyCode,
            String? mpesaCode)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ParsedSms() when $default != null:
        return $default(
            _that.amount,
            _that.type,
            _that.merchantName,
            _that.transactionDate,
            _that.smsHash,
            _that.senderId,
            _that.rawSmsText,
            _that.accountLast4,
            _that.currencyCode,
            _that.mpesaCode);
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
            int amount,
            TransactionType type,
            String? merchantName,
            DateTime transactionDate,
            String smsHash,
            String senderId,
            String rawSmsText,
            String? accountLast4,
            String currencyCode,
            String? mpesaCode)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParsedSms():
        return $default(
            _that.amount,
            _that.type,
            _that.merchantName,
            _that.transactionDate,
            _that.smsHash,
            _that.senderId,
            _that.rawSmsText,
            _that.accountLast4,
            _that.currencyCode,
            _that.mpesaCode);
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
            int amount,
            TransactionType type,
            String? merchantName,
            DateTime transactionDate,
            String smsHash,
            String senderId,
            String rawSmsText,
            String? accountLast4,
            String currencyCode,
            String? mpesaCode)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ParsedSms() when $default != null:
        return $default(
            _that.amount,
            _that.type,
            _that.merchantName,
            _that.transactionDate,
            _that.smsHash,
            _that.senderId,
            _that.rawSmsText,
            _that.accountLast4,
            _that.currencyCode,
            _that.mpesaCode);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ParsedSms implements ParsedSms {
  const _ParsedSms(
      {required this.amount,
      required this.type,
      this.merchantName,
      required this.transactionDate,
      required this.smsHash,
      required this.senderId,
      required this.rawSmsText,
      this.accountLast4,
      this.currencyCode = 'INR',
      this.mpesaCode});
  factory _ParsedSms.fromJson(Map<String, dynamic> json) =>
      _$ParsedSmsFromJson(json);

  @override
  final int amount;
  @override
  final TransactionType type;
  @override
  final String? merchantName;
  @override
  final DateTime transactionDate;
  @override
  final String smsHash;
  @override
  final String senderId;
  @override
  final String rawSmsText;
  @override
  final String? accountLast4;
  @override
  @JsonKey()
  final String currencyCode;
  @override
  final String? mpesaCode;

  /// Create a copy of ParsedSms
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ParsedSmsCopyWith<_ParsedSms> get copyWith =>
      __$ParsedSmsCopyWithImpl<_ParsedSms>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ParsedSmsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ParsedSms &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.merchantName, merchantName) ||
                other.merchantName == merchantName) &&
            (identical(other.transactionDate, transactionDate) ||
                other.transactionDate == transactionDate) &&
            (identical(other.smsHash, smsHash) || other.smsHash == smsHash) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.rawSmsText, rawSmsText) ||
                other.rawSmsText == rawSmsText) &&
            (identical(other.accountLast4, accountLast4) ||
                other.accountLast4 == accountLast4) &&
            (identical(other.currencyCode, currencyCode) ||
                other.currencyCode == currencyCode) &&
            (identical(other.mpesaCode, mpesaCode) ||
                other.mpesaCode == mpesaCode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      amount,
      type,
      merchantName,
      transactionDate,
      smsHash,
      senderId,
      rawSmsText,
      accountLast4,
      currencyCode,
      mpesaCode);

  @override
  String toString() {
    return 'ParsedSms(amount: $amount, type: $type, merchantName: $merchantName, transactionDate: $transactionDate, smsHash: $smsHash, senderId: $senderId, rawSmsText: $rawSmsText, accountLast4: $accountLast4, currencyCode: $currencyCode, mpesaCode: $mpesaCode)';
  }
}

/// @nodoc
abstract mixin class _$ParsedSmsCopyWith<$Res>
    implements $ParsedSmsCopyWith<$Res> {
  factory _$ParsedSmsCopyWith(
          _ParsedSms value, $Res Function(_ParsedSms) _then) =
      __$ParsedSmsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int amount,
      TransactionType type,
      String? merchantName,
      DateTime transactionDate,
      String smsHash,
      String senderId,
      String rawSmsText,
      String? accountLast4,
      String currencyCode,
      String? mpesaCode});
}

/// @nodoc
class __$ParsedSmsCopyWithImpl<$Res> implements _$ParsedSmsCopyWith<$Res> {
  __$ParsedSmsCopyWithImpl(this._self, this._then);

  final _ParsedSms _self;
  final $Res Function(_ParsedSms) _then;

  /// Create a copy of ParsedSms
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? amount = null,
    Object? type = null,
    Object? merchantName = freezed,
    Object? transactionDate = null,
    Object? smsHash = null,
    Object? senderId = null,
    Object? rawSmsText = null,
    Object? accountLast4 = freezed,
    Object? currencyCode = null,
    Object? mpesaCode = freezed,
  }) {
    return _then(_ParsedSms(
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      merchantName: freezed == merchantName
          ? _self.merchantName
          : merchantName // ignore: cast_nullable_to_non_nullable
              as String?,
      transactionDate: null == transactionDate
          ? _self.transactionDate
          : transactionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      smsHash: null == smsHash
          ? _self.smsHash
          : smsHash // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _self.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      rawSmsText: null == rawSmsText
          ? _self.rawSmsText
          : rawSmsText // ignore: cast_nullable_to_non_nullable
              as String,
      accountLast4: freezed == accountLast4
          ? _self.accountLast4
          : accountLast4 // ignore: cast_nullable_to_non_nullable
              as String?,
      currencyCode: null == currencyCode
          ? _self.currencyCode
          : currencyCode // ignore: cast_nullable_to_non_nullable
              as String,
      mpesaCode: freezed == mpesaCode
          ? _self.mpesaCode
          : mpesaCode // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
