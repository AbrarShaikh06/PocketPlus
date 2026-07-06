// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reports_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportsState {
  PeriodType get periodType;
  DateTimeRange get dateRange;
  bool get isExporting;
  String? get exportError;

  /// Create a copy of ReportsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportsStateCopyWith<ReportsState> get copyWith =>
      _$ReportsStateCopyWithImpl<ReportsState>(
          this as ReportsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReportsState &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.dateRange, dateRange) ||
                other.dateRange == dateRange) &&
            (identical(other.isExporting, isExporting) ||
                other.isExporting == isExporting) &&
            (identical(other.exportError, exportError) ||
                other.exportError == exportError));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, periodType, dateRange, isExporting, exportError);

  @override
  String toString() {
    return 'ReportsState(periodType: $periodType, dateRange: $dateRange, isExporting: $isExporting, exportError: $exportError)';
  }
}

/// @nodoc
abstract mixin class $ReportsStateCopyWith<$Res> {
  factory $ReportsStateCopyWith(
          ReportsState value, $Res Function(ReportsState) _then) =
      _$ReportsStateCopyWithImpl;
  @useResult
  $Res call(
      {PeriodType periodType,
      DateTimeRange dateRange,
      bool isExporting,
      String? exportError});
}

/// @nodoc
class _$ReportsStateCopyWithImpl<$Res> implements $ReportsStateCopyWith<$Res> {
  _$ReportsStateCopyWithImpl(this._self, this._then);

  final ReportsState _self;
  final $Res Function(ReportsState) _then;

  /// Create a copy of ReportsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? periodType = null,
    Object? dateRange = null,
    Object? isExporting = null,
    Object? exportError = freezed,
  }) {
    return _then(_self.copyWith(
      periodType: null == periodType
          ? _self.periodType
          : periodType // ignore: cast_nullable_to_non_nullable
              as PeriodType,
      dateRange: null == dateRange
          ? _self.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange,
      isExporting: null == isExporting
          ? _self.isExporting
          : isExporting // ignore: cast_nullable_to_non_nullable
              as bool,
      exportError: freezed == exportError
          ? _self.exportError
          : exportError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReportsState].
extension ReportsStatePatterns on ReportsState {
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
    TResult Function(_ReportsState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReportsState() when $default != null:
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
    TResult Function(_ReportsState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReportsState():
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
    TResult? Function(_ReportsState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReportsState() when $default != null:
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
    TResult Function(PeriodType periodType, DateTimeRange dateRange,
            bool isExporting, String? exportError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReportsState() when $default != null:
        return $default(_that.periodType, _that.dateRange, _that.isExporting,
            _that.exportError);
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
    TResult Function(PeriodType periodType, DateTimeRange dateRange,
            bool isExporting, String? exportError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReportsState():
        return $default(_that.periodType, _that.dateRange, _that.isExporting,
            _that.exportError);
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
    TResult? Function(PeriodType periodType, DateTimeRange dateRange,
            bool isExporting, String? exportError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReportsState() when $default != null:
        return $default(_that.periodType, _that.dateRange, _that.isExporting,
            _that.exportError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ReportsState implements ReportsState {
  const _ReportsState(
      {this.periodType = PeriodType.month,
      required this.dateRange,
      this.isExporting = false,
      this.exportError});

  @override
  @JsonKey()
  final PeriodType periodType;
  @override
  final DateTimeRange dateRange;
  @override
  @JsonKey()
  final bool isExporting;
  @override
  final String? exportError;

  /// Create a copy of ReportsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReportsStateCopyWith<_ReportsState> get copyWith =>
      __$ReportsStateCopyWithImpl<_ReportsState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReportsState &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.dateRange, dateRange) ||
                other.dateRange == dateRange) &&
            (identical(other.isExporting, isExporting) ||
                other.isExporting == isExporting) &&
            (identical(other.exportError, exportError) ||
                other.exportError == exportError));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, periodType, dateRange, isExporting, exportError);

  @override
  String toString() {
    return 'ReportsState(periodType: $periodType, dateRange: $dateRange, isExporting: $isExporting, exportError: $exportError)';
  }
}

/// @nodoc
abstract mixin class _$ReportsStateCopyWith<$Res>
    implements $ReportsStateCopyWith<$Res> {
  factory _$ReportsStateCopyWith(
          _ReportsState value, $Res Function(_ReportsState) _then) =
      __$ReportsStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {PeriodType periodType,
      DateTimeRange dateRange,
      bool isExporting,
      String? exportError});
}

/// @nodoc
class __$ReportsStateCopyWithImpl<$Res>
    implements _$ReportsStateCopyWith<$Res> {
  __$ReportsStateCopyWithImpl(this._self, this._then);

  final _ReportsState _self;
  final $Res Function(_ReportsState) _then;

  /// Create a copy of ReportsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? periodType = null,
    Object? dateRange = null,
    Object? isExporting = null,
    Object? exportError = freezed,
  }) {
    return _then(_ReportsState(
      periodType: null == periodType
          ? _self.periodType
          : periodType // ignore: cast_nullable_to_non_nullable
              as PeriodType,
      dateRange: null == dateRange
          ? _self.dateRange
          : dateRange // ignore: cast_nullable_to_non_nullable
              as DateTimeRange,
      isExporting: null == isExporting
          ? _self.isExporting
          : isExporting // ignore: cast_nullable_to_non_nullable
              as bool,
      exportError: freezed == exportError
          ? _self.exportError
          : exportError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
