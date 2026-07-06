// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardData {
  int get netProfit;
  int get totalIncome;
  int get totalExpense;
  int get transactionCount;
  List<Transaction> get recentTransactions;
  DateTime get month;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DashboardDataCopyWith<DashboardData> get copyWith =>
      _$DashboardDataCopyWithImpl<DashboardData>(
          this as DashboardData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DashboardData &&
            (identical(other.netProfit, netProfit) ||
                other.netProfit == netProfit) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            const DeepCollectionEquality()
                .equals(other.recentTransactions, recentTransactions) &&
            (identical(other.month, month) || other.month == month));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      netProfit,
      totalIncome,
      totalExpense,
      transactionCount,
      const DeepCollectionEquality().hash(recentTransactions),
      month);

  @override
  String toString() {
    return 'DashboardData(netProfit: $netProfit, totalIncome: $totalIncome, totalExpense: $totalExpense, transactionCount: $transactionCount, recentTransactions: $recentTransactions, month: $month)';
  }
}

/// @nodoc
abstract mixin class $DashboardDataCopyWith<$Res> {
  factory $DashboardDataCopyWith(
          DashboardData value, $Res Function(DashboardData) _then) =
      _$DashboardDataCopyWithImpl;
  @useResult
  $Res call(
      {int netProfit,
      int totalIncome,
      int totalExpense,
      int transactionCount,
      List<Transaction> recentTransactions,
      DateTime month});
}

/// @nodoc
class _$DashboardDataCopyWithImpl<$Res>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._self, this._then);

  final DashboardData _self;
  final $Res Function(DashboardData) _then;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? netProfit = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? transactionCount = null,
    Object? recentTransactions = null,
    Object? month = null,
  }) {
    return _then(_self.copyWith(
      netProfit: null == netProfit
          ? _self.netProfit
          : netProfit // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncome: null == totalIncome
          ? _self.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpense: null == totalExpense
          ? _self.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int,
      transactionCount: null == transactionCount
          ? _self.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      recentTransactions: null == recentTransactions
          ? _self.recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [DashboardData].
extension DashboardDataPatterns on DashboardData {
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
    TResult Function(_DashboardData value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DashboardData() when $default != null:
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
    TResult Function(_DashboardData value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardData():
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
    TResult? Function(_DashboardData value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardData() when $default != null:
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
            int netProfit,
            int totalIncome,
            int totalExpense,
            int transactionCount,
            List<Transaction> recentTransactions,
            DateTime month)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DashboardData() when $default != null:
        return $default(_that.netProfit, _that.totalIncome, _that.totalExpense,
            _that.transactionCount, _that.recentTransactions, _that.month);
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
            int netProfit,
            int totalIncome,
            int totalExpense,
            int transactionCount,
            List<Transaction> recentTransactions,
            DateTime month)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardData():
        return $default(_that.netProfit, _that.totalIncome, _that.totalExpense,
            _that.transactionCount, _that.recentTransactions, _that.month);
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
            int netProfit,
            int totalIncome,
            int totalExpense,
            int transactionCount,
            List<Transaction> recentTransactions,
            DateTime month)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DashboardData() when $default != null:
        return $default(_that.netProfit, _that.totalIncome, _that.totalExpense,
            _that.transactionCount, _that.recentTransactions, _that.month);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _DashboardData extends DashboardData {
  const _DashboardData(
      {required this.netProfit,
      required this.totalIncome,
      required this.totalExpense,
      required this.transactionCount,
      required final List<Transaction> recentTransactions,
      required this.month})
      : _recentTransactions = recentTransactions,
        super._();

  @override
  final int netProfit;
  @override
  final int totalIncome;
  @override
  final int totalExpense;
  @override
  final int transactionCount;
  final List<Transaction> _recentTransactions;
  @override
  List<Transaction> get recentTransactions {
    if (_recentTransactions is EqualUnmodifiableListView)
      return _recentTransactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTransactions);
  }

  @override
  final DateTime month;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DashboardDataCopyWith<_DashboardData> get copyWith =>
      __$DashboardDataCopyWithImpl<_DashboardData>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DashboardData &&
            (identical(other.netProfit, netProfit) ||
                other.netProfit == netProfit) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.transactionCount, transactionCount) ||
                other.transactionCount == transactionCount) &&
            const DeepCollectionEquality()
                .equals(other._recentTransactions, _recentTransactions) &&
            (identical(other.month, month) || other.month == month));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      netProfit,
      totalIncome,
      totalExpense,
      transactionCount,
      const DeepCollectionEquality().hash(_recentTransactions),
      month);

  @override
  String toString() {
    return 'DashboardData(netProfit: $netProfit, totalIncome: $totalIncome, totalExpense: $totalExpense, transactionCount: $transactionCount, recentTransactions: $recentTransactions, month: $month)';
  }
}

/// @nodoc
abstract mixin class _$DashboardDataCopyWith<$Res>
    implements $DashboardDataCopyWith<$Res> {
  factory _$DashboardDataCopyWith(
          _DashboardData value, $Res Function(_DashboardData) _then) =
      __$DashboardDataCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int netProfit,
      int totalIncome,
      int totalExpense,
      int transactionCount,
      List<Transaction> recentTransactions,
      DateTime month});
}

/// @nodoc
class __$DashboardDataCopyWithImpl<$Res>
    implements _$DashboardDataCopyWith<$Res> {
  __$DashboardDataCopyWithImpl(this._self, this._then);

  final _DashboardData _self;
  final $Res Function(_DashboardData) _then;

  /// Create a copy of DashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? netProfit = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? transactionCount = null,
    Object? recentTransactions = null,
    Object? month = null,
  }) {
    return _then(_DashboardData(
      netProfit: null == netProfit
          ? _self.netProfit
          : netProfit // ignore: cast_nullable_to_non_nullable
              as int,
      totalIncome: null == totalIncome
          ? _self.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as int,
      totalExpense: null == totalExpense
          ? _self.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as int,
      transactionCount: null == transactionCount
          ? _self.transactionCount
          : transactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      recentTransactions: null == recentTransactions
          ? _self._recentTransactions
          : recentTransactions // ignore: cast_nullable_to_non_nullable
              as List<Transaction>,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
