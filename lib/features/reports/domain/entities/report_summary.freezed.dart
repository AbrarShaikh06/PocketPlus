// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportSummary {
  int get totalIncome;
  int get totalExpense;
  int get netProfit;
  double get changePercent;
  DateTime get month;
  String get profileId;

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportSummaryCopyWith<ReportSummary> get copyWith =>
      _$ReportSummaryCopyWithImpl<ReportSummary>(
          this as ReportSummary, _$identity);

  /// Serializes this ReportSummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReportSummary &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.netProfit, netProfit) ||
                other.netProfit == netProfit) &&
            (identical(other.changePercent, changePercent) ||
                other.changePercent == changePercent) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalIncome, totalExpense,
      netProfit, changePercent, month, profileId);

  @override
  String toString() {
    return 'ReportSummary(totalIncome: $totalIncome, totalExpense: $totalExpense, netProfit: $netProfit, changePercent: $changePercent, month: $month, profileId: $profileId)';
  }
}

/// @nodoc
abstract mixin class $ReportSummaryCopyWith<$Res> {
  factory $ReportSummaryCopyWith(
          ReportSummary value, $Res Function(ReportSummary) _then) =
      _$ReportSummaryCopyWithImpl;
  @useResult
  $Res call(
      {int totalIncome,
      int totalExpense,
      int netProfit,
      double changePercent,
      DateTime month,
      String profileId});
}

/// @nodoc
class _$ReportSummaryCopyWithImpl<$Res>
    implements $ReportSummaryCopyWith<$Res> {
  _$ReportSummaryCopyWithImpl(this._self, this._then);

  final ReportSummary _self;
  final $Res Function(ReportSummary) _then;

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? netProfit = null,
    Object? changePercent = null,
    Object? month = null,
    Object? profileId = null,
  }) {
    return _then(_self.copyWith(
      totalIncome: null == totalIncome
          ? _self.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpense: null == totalExpense
          ? _self.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int,
      netProfit: null == netProfit
          ? _self.netProfit
          : netProfit // ignore: cast_nullable_to_non_nullable
              as int,
      changePercent: null == changePercent
          ? _self.changePercent
          : changePercent // ignore: cast_nullable_to_non_nullable
              as double,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profileId: null == profileId
          ? _self.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReportSummary].
extension ReportSummaryPatterns on ReportSummary {
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
    TResult Function(_ReportSummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReportSummary() when $default != null:
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
    TResult Function(_ReportSummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReportSummary():
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
    TResult? Function(_ReportSummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReportSummary() when $default != null:
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
    TResult Function(int totalIncome, int totalExpense, int netProfit,
            double changePercent, DateTime month, String profileId)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReportSummary() when $default != null:
        return $default(_that.totalIncome, _that.totalExpense, _that.netProfit,
            _that.changePercent, _that.month, _that.profileId);
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
    TResult Function(int totalIncome, int totalExpense, int netProfit,
            double changePercent, DateTime month, String profileId)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReportSummary():
        return $default(_that.totalIncome, _that.totalExpense, _that.netProfit,
            _that.changePercent, _that.month, _that.profileId);
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
    TResult? Function(int totalIncome, int totalExpense, int netProfit,
            double changePercent, DateTime month, String profileId)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReportSummary() when $default != null:
        return $default(_that.totalIncome, _that.totalExpense, _that.netProfit,
            _that.changePercent, _that.month, _that.profileId);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReportSummary implements ReportSummary {
  const _ReportSummary(
      {required this.totalIncome,
      required this.totalExpense,
      required this.netProfit,
      required this.changePercent,
      required this.month,
      required this.profileId});
  factory _ReportSummary.fromJson(Map<String, dynamic> json) =>
      _$ReportSummaryFromJson(json);

  @override
  final int totalIncome;
  @override
  final int totalExpense;
  @override
  final int netProfit;
  @override
  final double changePercent;
  @override
  final DateTime month;
  @override
  final String profileId;

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReportSummaryCopyWith<_ReportSummary> get copyWith =>
      __$ReportSummaryCopyWithImpl<_ReportSummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReportSummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReportSummary &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.netProfit, netProfit) ||
                other.netProfit == netProfit) &&
            (identical(other.changePercent, changePercent) ||
                other.changePercent == changePercent) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalIncome, totalExpense,
      netProfit, changePercent, month, profileId);

  @override
  String toString() {
    return 'ReportSummary(totalIncome: $totalIncome, totalExpense: $totalExpense, netProfit: $netProfit, changePercent: $changePercent, month: $month, profileId: $profileId)';
  }
}

/// @nodoc
abstract mixin class _$ReportSummaryCopyWith<$Res>
    implements $ReportSummaryCopyWith<$Res> {
  factory _$ReportSummaryCopyWith(
          _ReportSummary value, $Res Function(_ReportSummary) _then) =
      __$ReportSummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int totalIncome,
      int totalExpense,
      int netProfit,
      double changePercent,
      DateTime month,
      String profileId});
}

/// @nodoc
class __$ReportSummaryCopyWithImpl<$Res>
    implements _$ReportSummaryCopyWith<$Res> {
  __$ReportSummaryCopyWithImpl(this._self, this._then);

  final _ReportSummary _self;
  final $Res Function(_ReportSummary) _then;

  /// Create a copy of ReportSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? netProfit = null,
    Object? changePercent = null,
    Object? month = null,
    Object? profileId = null,
  }) {
    return _then(_ReportSummary(
      totalIncome: null == totalIncome
          ? _self.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpense: null == totalExpense
          ? _self.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int,
      netProfit: null == netProfit
          ? _self.netProfit
          : netProfit // ignore: cast_nullable_to_non_nullable
              as int,
      changePercent: null == changePercent
          ? _self.changePercent
          : changePercent // ignore: cast_nullable_to_non_nullable
              as double,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
      profileId: null == profileId
          ? _self.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
