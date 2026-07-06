// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sms_permission_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SmsPermissionState {
  PermissionStatus get status;
  bool get hasPermanentlyDenied;

  /// Create a copy of SmsPermissionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SmsPermissionStateCopyWith<SmsPermissionState> get copyWith =>
      _$SmsPermissionStateCopyWithImpl<SmsPermissionState>(
          this as SmsPermissionState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SmsPermissionState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.hasPermanentlyDenied, hasPermanentlyDenied) ||
                other.hasPermanentlyDenied == hasPermanentlyDenied));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, hasPermanentlyDenied);

  @override
  String toString() {
    return 'SmsPermissionState(status: $status, hasPermanentlyDenied: $hasPermanentlyDenied)';
  }
}

/// @nodoc
abstract mixin class $SmsPermissionStateCopyWith<$Res> {
  factory $SmsPermissionStateCopyWith(
          SmsPermissionState value, $Res Function(SmsPermissionState) _then) =
      _$SmsPermissionStateCopyWithImpl;
  @useResult
  $Res call({PermissionStatus status, bool hasPermanentlyDenied});
}

/// @nodoc
class _$SmsPermissionStateCopyWithImpl<$Res>
    implements $SmsPermissionStateCopyWith<$Res> {
  _$SmsPermissionStateCopyWithImpl(this._self, this._then);

  final SmsPermissionState _self;
  final $Res Function(SmsPermissionState) _then;

  /// Create a copy of SmsPermissionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? hasPermanentlyDenied = null,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PermissionStatus,
      hasPermanentlyDenied: null == hasPermanentlyDenied
          ? _self.hasPermanentlyDenied
          : hasPermanentlyDenied // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [SmsPermissionState].
extension SmsPermissionStatePatterns on SmsPermissionState {
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
    TResult Function(_SmsPermissionState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SmsPermissionState() when $default != null:
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
    TResult Function(_SmsPermissionState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SmsPermissionState():
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
    TResult? Function(_SmsPermissionState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SmsPermissionState() when $default != null:
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
    TResult Function(PermissionStatus status, bool hasPermanentlyDenied)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SmsPermissionState() when $default != null:
        return $default(_that.status, _that.hasPermanentlyDenied);
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
    TResult Function(PermissionStatus status, bool hasPermanentlyDenied)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SmsPermissionState():
        return $default(_that.status, _that.hasPermanentlyDenied);
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
    TResult? Function(PermissionStatus status, bool hasPermanentlyDenied)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SmsPermissionState() when $default != null:
        return $default(_that.status, _that.hasPermanentlyDenied);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _SmsPermissionState implements SmsPermissionState {
  const _SmsPermissionState(
      {required this.status, required this.hasPermanentlyDenied});

  @override
  final PermissionStatus status;
  @override
  final bool hasPermanentlyDenied;

  /// Create a copy of SmsPermissionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SmsPermissionStateCopyWith<_SmsPermissionState> get copyWith =>
      __$SmsPermissionStateCopyWithImpl<_SmsPermissionState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SmsPermissionState &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.hasPermanentlyDenied, hasPermanentlyDenied) ||
                other.hasPermanentlyDenied == hasPermanentlyDenied));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status, hasPermanentlyDenied);

  @override
  String toString() {
    return 'SmsPermissionState(status: $status, hasPermanentlyDenied: $hasPermanentlyDenied)';
  }
}

/// @nodoc
abstract mixin class _$SmsPermissionStateCopyWith<$Res>
    implements $SmsPermissionStateCopyWith<$Res> {
  factory _$SmsPermissionStateCopyWith(
          _SmsPermissionState value, $Res Function(_SmsPermissionState) _then) =
      __$SmsPermissionStateCopyWithImpl;
  @override
  @useResult
  $Res call({PermissionStatus status, bool hasPermanentlyDenied});
}

/// @nodoc
class __$SmsPermissionStateCopyWithImpl<$Res>
    implements _$SmsPermissionStateCopyWith<$Res> {
  __$SmsPermissionStateCopyWithImpl(this._self, this._then);

  final _SmsPermissionState _self;
  final $Res Function(_SmsPermissionState) _then;

  /// Create a copy of SmsPermissionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
    Object? hasPermanentlyDenied = null,
  }) {
    return _then(_SmsPermissionState(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as PermissionStatus,
      hasPermanentlyDenied: null == hasPermanentlyDenied
          ? _self.hasPermanentlyDenied
          : hasPermanentlyDenied // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
