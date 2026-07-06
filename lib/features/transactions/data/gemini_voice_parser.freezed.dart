// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gemini_voice_parser.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VoiceParseResult {
  int? get amount;
  TransactionType get type;
  String? get categoryId;
  String? get note;

  /// Create a copy of VoiceParseResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VoiceParseResultCopyWith<VoiceParseResult> get copyWith =>
      _$VoiceParseResultCopyWithImpl<VoiceParseResult>(
          this as VoiceParseResult, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VoiceParseResult &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amount, type, categoryId, note);

  @override
  String toString() {
    return 'VoiceParseResult(amount: $amount, type: $type, categoryId: $categoryId, note: $note)';
  }
}

/// @nodoc
abstract mixin class $VoiceParseResultCopyWith<$Res> {
  factory $VoiceParseResultCopyWith(
          VoiceParseResult value, $Res Function(VoiceParseResult) _then) =
      _$VoiceParseResultCopyWithImpl;
  @useResult
  $Res call(
      {int? amount, TransactionType type, String? categoryId, String? note});
}

/// @nodoc
class _$VoiceParseResultCopyWithImpl<$Res>
    implements $VoiceParseResultCopyWith<$Res> {
  _$VoiceParseResultCopyWithImpl(this._self, this._then);

  final VoiceParseResult _self;
  final $Res Function(VoiceParseResult) _then;

  /// Create a copy of VoiceParseResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = freezed,
    Object? type = null,
    Object? categoryId = freezed,
    Object? note = freezed,
  }) {
    return _then(_self.copyWith(
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [VoiceParseResult].
extension VoiceParseResultPatterns on VoiceParseResult {
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
    TResult Function(_VoiceParseResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VoiceParseResult() when $default != null:
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
    TResult Function(_VoiceParseResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VoiceParseResult():
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
    TResult? Function(_VoiceParseResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VoiceParseResult() when $default != null:
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
    TResult Function(int? amount, TransactionType type, String? categoryId,
            String? note)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VoiceParseResult() when $default != null:
        return $default(_that.amount, _that.type, _that.categoryId, _that.note);
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
            int? amount, TransactionType type, String? categoryId, String? note)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VoiceParseResult():
        return $default(_that.amount, _that.type, _that.categoryId, _that.note);
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
    TResult? Function(int? amount, TransactionType type, String? categoryId,
            String? note)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VoiceParseResult() when $default != null:
        return $default(_that.amount, _that.type, _that.categoryId, _that.note);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _VoiceParseResult implements VoiceParseResult {
  const _VoiceParseResult(
      {this.amount, required this.type, this.categoryId, this.note});

  @override
  final int? amount;
  @override
  final TransactionType type;
  @override
  final String? categoryId;
  @override
  final String? note;

  /// Create a copy of VoiceParseResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VoiceParseResultCopyWith<_VoiceParseResult> get copyWith =>
      __$VoiceParseResultCopyWithImpl<_VoiceParseResult>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VoiceParseResult &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.note, note) || other.note == note));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amount, type, categoryId, note);

  @override
  String toString() {
    return 'VoiceParseResult(amount: $amount, type: $type, categoryId: $categoryId, note: $note)';
  }
}

/// @nodoc
abstract mixin class _$VoiceParseResultCopyWith<$Res>
    implements $VoiceParseResultCopyWith<$Res> {
  factory _$VoiceParseResultCopyWith(
          _VoiceParseResult value, $Res Function(_VoiceParseResult) _then) =
      __$VoiceParseResultCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int? amount, TransactionType type, String? categoryId, String? note});
}

/// @nodoc
class __$VoiceParseResultCopyWithImpl<$Res>
    implements _$VoiceParseResultCopyWith<$Res> {
  __$VoiceParseResultCopyWithImpl(this._self, this._then);

  final _VoiceParseResult _self;
  final $Res Function(_VoiceParseResult) _then;

  /// Create a copy of VoiceParseResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? amount = freezed,
    Object? type = null,
    Object? categoryId = freezed,
    Object? note = freezed,
  }) {
    return _then(_VoiceParseResult(
      amount: freezed == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
