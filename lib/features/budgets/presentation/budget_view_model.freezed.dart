// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetListState {
  List<Budget> get budgets;
  bool get isLoading;
  String? get error;

  /// Create a copy of BudgetListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetListStateCopyWith<BudgetListState> get copyWith =>
      _$BudgetListStateCopyWithImpl<BudgetListState>(
          this as BudgetListState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetListState &&
            const DeepCollectionEquality().equals(other.budgets, budgets) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(budgets), isLoading, error);

  @override
  String toString() {
    return 'BudgetListState(budgets: $budgets, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class $BudgetListStateCopyWith<$Res> {
  factory $BudgetListStateCopyWith(
          BudgetListState value, $Res Function(BudgetListState) _then) =
      _$BudgetListStateCopyWithImpl;
  @useResult
  $Res call({List<Budget> budgets, bool isLoading, String? error});
}

/// @nodoc
class _$BudgetListStateCopyWithImpl<$Res>
    implements $BudgetListStateCopyWith<$Res> {
  _$BudgetListStateCopyWithImpl(this._self, this._then);

  final BudgetListState _self;
  final $Res Function(BudgetListState) _then;

  /// Create a copy of BudgetListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? budgets = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      budgets: null == budgets
          ? _self.budgets
          : budgets // ignore: cast_nullable_to_non_nullable
              as List<Budget>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [BudgetListState].
extension BudgetListStatePatterns on BudgetListState {
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
    TResult Function(_BudgetListState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetListState() when $default != null:
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
    TResult Function(_BudgetListState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetListState():
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
    TResult? Function(_BudgetListState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetListState() when $default != null:
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
    TResult Function(List<Budget> budgets, bool isLoading, String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetListState() when $default != null:
        return $default(_that.budgets, _that.isLoading, _that.error);
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
    TResult Function(List<Budget> budgets, bool isLoading, String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetListState():
        return $default(_that.budgets, _that.isLoading, _that.error);
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
    TResult? Function(List<Budget> budgets, bool isLoading, String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetListState() when $default != null:
        return $default(_that.budgets, _that.isLoading, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _BudgetListState implements BudgetListState {
  const _BudgetListState(
      {final List<Budget> budgets = const [],
      this.isLoading = false,
      this.error})
      : _budgets = budgets;

  final List<Budget> _budgets;
  @override
  @JsonKey()
  List<Budget> get budgets {
    if (_budgets is EqualUnmodifiableListView) return _budgets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_budgets);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? error;

  /// Create a copy of BudgetListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetListStateCopyWith<_BudgetListState> get copyWith =>
      __$BudgetListStateCopyWithImpl<_BudgetListState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetListState &&
            const DeepCollectionEquality().equals(other._budgets, _budgets) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_budgets), isLoading, error);

  @override
  String toString() {
    return 'BudgetListState(budgets: $budgets, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$BudgetListStateCopyWith<$Res>
    implements $BudgetListStateCopyWith<$Res> {
  factory _$BudgetListStateCopyWith(
          _BudgetListState value, $Res Function(_BudgetListState) _then) =
      __$BudgetListStateCopyWithImpl;
  @override
  @useResult
  $Res call({List<Budget> budgets, bool isLoading, String? error});
}

/// @nodoc
class __$BudgetListStateCopyWithImpl<$Res>
    implements _$BudgetListStateCopyWith<$Res> {
  __$BudgetListStateCopyWithImpl(this._self, this._then);

  final _BudgetListState _self;
  final $Res Function(_BudgetListState) _then;

  /// Create a copy of BudgetListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? budgets = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_BudgetListState(
      budgets: null == budgets
          ? _self._budgets
          : budgets // ignore: cast_nullable_to_non_nullable
              as List<Budget>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$CreateBudgetState {
  String get name;
  BudgetType get budgetType;
  List<String> get selectedCategoryIds;
  String get amountString;
  BudgetPeriod get period;
  DateTime get startDate;
  DateTime? get endDate;
  String get colorHex;
  String get icon;
  double get alertThreshold;
  bool get notificationsEnabled;
  String? get notes;
  bool get isSaving;
  bool get isEditing;
  String? get saveError;
  String? get nameError;
  String? get amountError;

  /// Create a copy of CreateBudgetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateBudgetStateCopyWith<CreateBudgetState> get copyWith =>
      _$CreateBudgetStateCopyWithImpl<CreateBudgetState>(
          this as CreateBudgetState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateBudgetState &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.budgetType, budgetType) ||
                other.budgetType == budgetType) &&
            const DeepCollectionEquality()
                .equals(other.selectedCategoryIds, selectedCategoryIds) &&
            (identical(other.amountString, amountString) ||
                other.amountString == amountString) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.alertThreshold, alertThreshold) ||
                other.alertThreshold == alertThreshold) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError) &&
            (identical(other.nameError, nameError) ||
                other.nameError == nameError) &&
            (identical(other.amountError, amountError) ||
                other.amountError == amountError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      budgetType,
      const DeepCollectionEquality().hash(selectedCategoryIds),
      amountString,
      period,
      startDate,
      endDate,
      colorHex,
      icon,
      alertThreshold,
      notificationsEnabled,
      notes,
      isSaving,
      isEditing,
      saveError,
      nameError,
      amountError);

  @override
  String toString() {
    return 'CreateBudgetState(name: $name, budgetType: $budgetType, selectedCategoryIds: $selectedCategoryIds, amountString: $amountString, period: $period, startDate: $startDate, endDate: $endDate, colorHex: $colorHex, icon: $icon, alertThreshold: $alertThreshold, notificationsEnabled: $notificationsEnabled, notes: $notes, isSaving: $isSaving, isEditing: $isEditing, saveError: $saveError, nameError: $nameError, amountError: $amountError)';
  }
}

/// @nodoc
abstract mixin class $CreateBudgetStateCopyWith<$Res> {
  factory $CreateBudgetStateCopyWith(
          CreateBudgetState value, $Res Function(CreateBudgetState) _then) =
      _$CreateBudgetStateCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      BudgetType budgetType,
      List<String> selectedCategoryIds,
      String amountString,
      BudgetPeriod period,
      DateTime startDate,
      DateTime? endDate,
      String colorHex,
      String icon,
      double alertThreshold,
      bool notificationsEnabled,
      String? notes,
      bool isSaving,
      bool isEditing,
      String? saveError,
      String? nameError,
      String? amountError});
}

/// @nodoc
class _$CreateBudgetStateCopyWithImpl<$Res>
    implements $CreateBudgetStateCopyWith<$Res> {
  _$CreateBudgetStateCopyWithImpl(this._self, this._then);

  final CreateBudgetState _self;
  final $Res Function(CreateBudgetState) _then;

  /// Create a copy of CreateBudgetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? budgetType = null,
    Object? selectedCategoryIds = null,
    Object? amountString = null,
    Object? period = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? colorHex = null,
    Object? icon = null,
    Object? alertThreshold = null,
    Object? notificationsEnabled = null,
    Object? notes = freezed,
    Object? isSaving = null,
    Object? isEditing = null,
    Object? saveError = freezed,
    Object? nameError = freezed,
    Object? amountError = freezed,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      budgetType: null == budgetType
          ? _self.budgetType
          : budgetType // ignore: cast_nullable_to_non_nullable
              as BudgetType,
      selectedCategoryIds: null == selectedCategoryIds
          ? _self.selectedCategoryIds
          : selectedCategoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      amountString: null == amountString
          ? _self.amountString
          : amountString // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as BudgetPeriod,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      colorHex: null == colorHex
          ? _self.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      alertThreshold: null == alertThreshold
          ? _self.alertThreshold
          : alertThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      notificationsEnabled: null == notificationsEnabled
          ? _self.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isEditing: null == isEditing
          ? _self.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
      saveError: freezed == saveError
          ? _self.saveError
          : saveError // ignore: cast_nullable_to_non_nullable
              as String?,
      nameError: freezed == nameError
          ? _self.nameError
          : nameError // ignore: cast_nullable_to_non_nullable
              as String?,
      amountError: freezed == amountError
          ? _self.amountError
          : amountError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CreateBudgetState].
extension CreateBudgetStatePatterns on CreateBudgetState {
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
    TResult Function(_CreateBudgetState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateBudgetState() when $default != null:
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
    TResult Function(_CreateBudgetState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateBudgetState():
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
    TResult? Function(_CreateBudgetState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateBudgetState() when $default != null:
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
            String name,
            BudgetType budgetType,
            List<String> selectedCategoryIds,
            String amountString,
            BudgetPeriod period,
            DateTime startDate,
            DateTime? endDate,
            String colorHex,
            String icon,
            double alertThreshold,
            bool notificationsEnabled,
            String? notes,
            bool isSaving,
            bool isEditing,
            String? saveError,
            String? nameError,
            String? amountError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateBudgetState() when $default != null:
        return $default(
            _that.name,
            _that.budgetType,
            _that.selectedCategoryIds,
            _that.amountString,
            _that.period,
            _that.startDate,
            _that.endDate,
            _that.colorHex,
            _that.icon,
            _that.alertThreshold,
            _that.notificationsEnabled,
            _that.notes,
            _that.isSaving,
            _that.isEditing,
            _that.saveError,
            _that.nameError,
            _that.amountError);
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
            String name,
            BudgetType budgetType,
            List<String> selectedCategoryIds,
            String amountString,
            BudgetPeriod period,
            DateTime startDate,
            DateTime? endDate,
            String colorHex,
            String icon,
            double alertThreshold,
            bool notificationsEnabled,
            String? notes,
            bool isSaving,
            bool isEditing,
            String? saveError,
            String? nameError,
            String? amountError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateBudgetState():
        return $default(
            _that.name,
            _that.budgetType,
            _that.selectedCategoryIds,
            _that.amountString,
            _that.period,
            _that.startDate,
            _that.endDate,
            _that.colorHex,
            _that.icon,
            _that.alertThreshold,
            _that.notificationsEnabled,
            _that.notes,
            _that.isSaving,
            _that.isEditing,
            _that.saveError,
            _that.nameError,
            _that.amountError);
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
            String name,
            BudgetType budgetType,
            List<String> selectedCategoryIds,
            String amountString,
            BudgetPeriod period,
            DateTime startDate,
            DateTime? endDate,
            String colorHex,
            String icon,
            double alertThreshold,
            bool notificationsEnabled,
            String? notes,
            bool isSaving,
            bool isEditing,
            String? saveError,
            String? nameError,
            String? amountError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateBudgetState() when $default != null:
        return $default(
            _that.name,
            _that.budgetType,
            _that.selectedCategoryIds,
            _that.amountString,
            _that.period,
            _that.startDate,
            _that.endDate,
            _that.colorHex,
            _that.icon,
            _that.alertThreshold,
            _that.notificationsEnabled,
            _that.notes,
            _that.isSaving,
            _that.isEditing,
            _that.saveError,
            _that.nameError,
            _that.amountError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CreateBudgetState implements CreateBudgetState {
  const _CreateBudgetState(
      {required this.name,
      required this.budgetType,
      required final List<String> selectedCategoryIds,
      required this.amountString,
      required this.period,
      required this.startDate,
      this.endDate,
      this.colorHex = '#4CAF50',
      this.icon = 'account_balance_wallet',
      this.alertThreshold = 80.0,
      this.notificationsEnabled = true,
      this.notes,
      this.isSaving = false,
      this.isEditing = false,
      this.saveError,
      this.nameError,
      this.amountError})
      : _selectedCategoryIds = selectedCategoryIds;

  @override
  final String name;
  @override
  final BudgetType budgetType;
  final List<String> _selectedCategoryIds;
  @override
  List<String> get selectedCategoryIds {
    if (_selectedCategoryIds is EqualUnmodifiableListView)
      return _selectedCategoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedCategoryIds);
  }

  @override
  final String amountString;
  @override
  final BudgetPeriod period;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final String colorHex;
  @override
  @JsonKey()
  final String icon;
  @override
  @JsonKey()
  final double alertThreshold;
  @override
  @JsonKey()
  final bool notificationsEnabled;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  @JsonKey()
  final bool isEditing;
  @override
  final String? saveError;
  @override
  final String? nameError;
  @override
  final String? amountError;

  /// Create a copy of CreateBudgetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateBudgetStateCopyWith<_CreateBudgetState> get copyWith =>
      __$CreateBudgetStateCopyWithImpl<_CreateBudgetState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateBudgetState &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.budgetType, budgetType) ||
                other.budgetType == budgetType) &&
            const DeepCollectionEquality()
                .equals(other._selectedCategoryIds, _selectedCategoryIds) &&
            (identical(other.amountString, amountString) ||
                other.amountString == amountString) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.alertThreshold, alertThreshold) ||
                other.alertThreshold == alertThreshold) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.isEditing, isEditing) ||
                other.isEditing == isEditing) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError) &&
            (identical(other.nameError, nameError) ||
                other.nameError == nameError) &&
            (identical(other.amountError, amountError) ||
                other.amountError == amountError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      budgetType,
      const DeepCollectionEquality().hash(_selectedCategoryIds),
      amountString,
      period,
      startDate,
      endDate,
      colorHex,
      icon,
      alertThreshold,
      notificationsEnabled,
      notes,
      isSaving,
      isEditing,
      saveError,
      nameError,
      amountError);

  @override
  String toString() {
    return 'CreateBudgetState(name: $name, budgetType: $budgetType, selectedCategoryIds: $selectedCategoryIds, amountString: $amountString, period: $period, startDate: $startDate, endDate: $endDate, colorHex: $colorHex, icon: $icon, alertThreshold: $alertThreshold, notificationsEnabled: $notificationsEnabled, notes: $notes, isSaving: $isSaving, isEditing: $isEditing, saveError: $saveError, nameError: $nameError, amountError: $amountError)';
  }
}

/// @nodoc
abstract mixin class _$CreateBudgetStateCopyWith<$Res>
    implements $CreateBudgetStateCopyWith<$Res> {
  factory _$CreateBudgetStateCopyWith(
          _CreateBudgetState value, $Res Function(_CreateBudgetState) _then) =
      __$CreateBudgetStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      BudgetType budgetType,
      List<String> selectedCategoryIds,
      String amountString,
      BudgetPeriod period,
      DateTime startDate,
      DateTime? endDate,
      String colorHex,
      String icon,
      double alertThreshold,
      bool notificationsEnabled,
      String? notes,
      bool isSaving,
      bool isEditing,
      String? saveError,
      String? nameError,
      String? amountError});
}

/// @nodoc
class __$CreateBudgetStateCopyWithImpl<$Res>
    implements _$CreateBudgetStateCopyWith<$Res> {
  __$CreateBudgetStateCopyWithImpl(this._self, this._then);

  final _CreateBudgetState _self;
  final $Res Function(_CreateBudgetState) _then;

  /// Create a copy of CreateBudgetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? budgetType = null,
    Object? selectedCategoryIds = null,
    Object? amountString = null,
    Object? period = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? colorHex = null,
    Object? icon = null,
    Object? alertThreshold = null,
    Object? notificationsEnabled = null,
    Object? notes = freezed,
    Object? isSaving = null,
    Object? isEditing = null,
    Object? saveError = freezed,
    Object? nameError = freezed,
    Object? amountError = freezed,
  }) {
    return _then(_CreateBudgetState(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      budgetType: null == budgetType
          ? _self.budgetType
          : budgetType // ignore: cast_nullable_to_non_nullable
              as BudgetType,
      selectedCategoryIds: null == selectedCategoryIds
          ? _self._selectedCategoryIds
          : selectedCategoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      amountString: null == amountString
          ? _self.amountString
          : amountString // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as BudgetPeriod,
      startDate: null == startDate
          ? _self.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _self.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      colorHex: null == colorHex
          ? _self.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      alertThreshold: null == alertThreshold
          ? _self.alertThreshold
          : alertThreshold // ignore: cast_nullable_to_non_nullable
              as double,
      notificationsEnabled: null == notificationsEnabled
          ? _self.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      isEditing: null == isEditing
          ? _self.isEditing
          : isEditing // ignore: cast_nullable_to_non_nullable
              as bool,
      saveError: freezed == saveError
          ? _self.saveError
          : saveError // ignore: cast_nullable_to_non_nullable
              as String?,
      nameError: freezed == nameError
          ? _self.nameError
          : nameError // ignore: cast_nullable_to_non_nullable
              as String?,
      amountError: freezed == amountError
          ? _self.amountError
          : amountError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
