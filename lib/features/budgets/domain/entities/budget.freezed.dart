// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Budget {
  String get id;
  String get userId;
  String get profileId;
  String get name;
  @JsonKey(fromJson: _budgetTypeFromFirestore, toJson: _budgetTypeToFirestore)
  BudgetType get budgetType;
  List<String> get categoryIds;
  int get amount;
  int get spentAmount;
  int get remainingAmount;
  @JsonKey(
      fromJson: _budgetPeriodFromFirestore, toJson: _budgetPeriodToFirestore)
  BudgetPeriod get period;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get startDate;
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? get endDate;
  String get colorHex;
  String get icon;
  int get alertThreshold;
  bool get notificationsEnabled;
  String? get notes;
  bool get isPaused;
  bool get isDeleted;
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? get deletedAt;
  @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
  SyncStatus get syncStatus;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get createdAt;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get updatedAt;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetCopyWith<Budget> get copyWith =>
      _$BudgetCopyWithImpl<Budget>(this as Budget, _$identity);

  /// Serializes this Budget to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Budget &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.budgetType, budgetType) ||
                other.budgetType == budgetType) &&
            const DeepCollectionEquality()
                .equals(other.categoryIds, categoryIds) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.spentAmount, spentAmount) ||
                other.spentAmount == spentAmount) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
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
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        profileId,
        name,
        budgetType,
        const DeepCollectionEquality().hash(categoryIds),
        amount,
        spentAmount,
        remainingAmount,
        period,
        startDate,
        endDate,
        colorHex,
        icon,
        alertThreshold,
        notificationsEnabled,
        notes,
        isPaused,
        isDeleted,
        deletedAt,
        syncStatus,
        createdAt,
        updatedAt
      ]);

  @override
  String toString() {
    return 'Budget(id: $id, userId: $userId, profileId: $profileId, name: $name, budgetType: $budgetType, categoryIds: $categoryIds, amount: $amount, spentAmount: $spentAmount, remainingAmount: $remainingAmount, period: $period, startDate: $startDate, endDate: $endDate, colorHex: $colorHex, icon: $icon, alertThreshold: $alertThreshold, notificationsEnabled: $notificationsEnabled, notes: $notes, isPaused: $isPaused, isDeleted: $isDeleted, deletedAt: $deletedAt, syncStatus: $syncStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $BudgetCopyWith<$Res> {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) _then) =
      _$BudgetCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String profileId,
      String name,
      @JsonKey(
          fromJson: _budgetTypeFromFirestore, toJson: _budgetTypeToFirestore)
      BudgetType budgetType,
      List<String> categoryIds,
      int amount,
      int spentAmount,
      int remainingAmount,
      @JsonKey(
          fromJson: _budgetPeriodFromFirestore,
          toJson: _budgetPeriodToFirestore)
      BudgetPeriod period,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime startDate,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? endDate,
      String colorHex,
      String icon,
      int alertThreshold,
      bool notificationsEnabled,
      String? notes,
      bool isPaused,
      bool isDeleted,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? deletedAt,
      @JsonKey(
          fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
      SyncStatus syncStatus,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime updatedAt});
}

/// @nodoc
class _$BudgetCopyWithImpl<$Res> implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._self, this._then);

  final Budget _self;
  final $Res Function(Budget) _then;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileId = null,
    Object? name = null,
    Object? budgetType = null,
    Object? categoryIds = null,
    Object? amount = null,
    Object? spentAmount = null,
    Object? remainingAmount = null,
    Object? period = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? colorHex = null,
    Object? icon = null,
    Object? alertThreshold = null,
    Object? notificationsEnabled = null,
    Object? notes = freezed,
    Object? isPaused = null,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? syncStatus = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      budgetType: null == budgetType
          ? _self.budgetType
          : budgetType // ignore: cast_nullable_to_non_nullable
              as BudgetType,
      categoryIds: null == categoryIds
          ? _self.categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      spentAmount: null == spentAmount
          ? _self.spentAmount
          : spentAmount // ignore: cast_nullable_to_non_nullable
              as int,
      remainingAmount: null == remainingAmount
          ? _self.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as int,
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
              as int,
      notificationsEnabled: null == notificationsEnabled
          ? _self.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isPaused: null == isPaused
          ? _self.isPaused
          : isPaused // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncStatus: null == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [Budget].
extension BudgetPatterns on Budget {
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
    TResult Function(_Budget value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Budget() when $default != null:
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
    TResult Function(_Budget value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Budget():
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
    TResult? Function(_Budget value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Budget() when $default != null:
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
            String name,
            @JsonKey(
                fromJson: _budgetTypeFromFirestore,
                toJson: _budgetTypeToFirestore)
            BudgetType budgetType,
            List<String> categoryIds,
            int amount,
            int spentAmount,
            int remainingAmount,
            @JsonKey(
                fromJson: _budgetPeriodFromFirestore,
                toJson: _budgetPeriodToFirestore)
            BudgetPeriod period,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime startDate,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? endDate,
            String colorHex,
            String icon,
            int alertThreshold,
            bool notificationsEnabled,
            String? notes,
            bool isPaused,
            bool isDeleted,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt,
            @JsonKey(
                fromJson: _syncStatusFromFirestore,
                toJson: _syncStatusToFirestore)
            SyncStatus syncStatus,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Budget() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.name,
            _that.budgetType,
            _that.categoryIds,
            _that.amount,
            _that.spentAmount,
            _that.remainingAmount,
            _that.period,
            _that.startDate,
            _that.endDate,
            _that.colorHex,
            _that.icon,
            _that.alertThreshold,
            _that.notificationsEnabled,
            _that.notes,
            _that.isPaused,
            _that.isDeleted,
            _that.deletedAt,
            _that.syncStatus,
            _that.createdAt,
            _that.updatedAt);
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
            String name,
            @JsonKey(
                fromJson: _budgetTypeFromFirestore,
                toJson: _budgetTypeToFirestore)
            BudgetType budgetType,
            List<String> categoryIds,
            int amount,
            int spentAmount,
            int remainingAmount,
            @JsonKey(
                fromJson: _budgetPeriodFromFirestore,
                toJson: _budgetPeriodToFirestore)
            BudgetPeriod period,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime startDate,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? endDate,
            String colorHex,
            String icon,
            int alertThreshold,
            bool notificationsEnabled,
            String? notes,
            bool isPaused,
            bool isDeleted,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt,
            @JsonKey(
                fromJson: _syncStatusFromFirestore,
                toJson: _syncStatusToFirestore)
            SyncStatus syncStatus,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Budget():
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.name,
            _that.budgetType,
            _that.categoryIds,
            _that.amount,
            _that.spentAmount,
            _that.remainingAmount,
            _that.period,
            _that.startDate,
            _that.endDate,
            _that.colorHex,
            _that.icon,
            _that.alertThreshold,
            _that.notificationsEnabled,
            _that.notes,
            _that.isPaused,
            _that.isDeleted,
            _that.deletedAt,
            _that.syncStatus,
            _that.createdAt,
            _that.updatedAt);
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
            String name,
            @JsonKey(
                fromJson: _budgetTypeFromFirestore,
                toJson: _budgetTypeToFirestore)
            BudgetType budgetType,
            List<String> categoryIds,
            int amount,
            int spentAmount,
            int remainingAmount,
            @JsonKey(
                fromJson: _budgetPeriodFromFirestore,
                toJson: _budgetPeriodToFirestore)
            BudgetPeriod period,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime startDate,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? endDate,
            String colorHex,
            String icon,
            int alertThreshold,
            bool notificationsEnabled,
            String? notes,
            bool isPaused,
            bool isDeleted,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt,
            @JsonKey(
                fromJson: _syncStatusFromFirestore,
                toJson: _syncStatusToFirestore)
            SyncStatus syncStatus,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Budget() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.name,
            _that.budgetType,
            _that.categoryIds,
            _that.amount,
            _that.spentAmount,
            _that.remainingAmount,
            _that.period,
            _that.startDate,
            _that.endDate,
            _that.colorHex,
            _that.icon,
            _that.alertThreshold,
            _that.notificationsEnabled,
            _that.notes,
            _that.isPaused,
            _that.isDeleted,
            _that.deletedAt,
            _that.syncStatus,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Budget implements Budget {
  const _Budget(
      {required this.id,
      required this.userId,
      required this.profileId,
      required this.name,
      @JsonKey(
          fromJson: _budgetTypeFromFirestore, toJson: _budgetTypeToFirestore)
      required this.budgetType,
      final List<String> categoryIds = const [],
      required this.amount,
      this.spentAmount = 0,
      this.remainingAmount = 0,
      @JsonKey(
          fromJson: _budgetPeriodFromFirestore,
          toJson: _budgetPeriodToFirestore)
      required this.period,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.startDate,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      this.endDate,
      this.colorHex = '#4CAF50',
      this.icon = 'account_balance_wallet',
      this.alertThreshold = 80,
      this.notificationsEnabled = true,
      this.notes,
      this.isPaused = false,
      this.isDeleted = false,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      this.deletedAt,
      @JsonKey(
          fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
      this.syncStatus = SyncStatus.pending,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.createdAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.updatedAt})
      : _categoryIds = categoryIds;
  factory _Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String profileId;
  @override
  final String name;
  @override
  @JsonKey(fromJson: _budgetTypeFromFirestore, toJson: _budgetTypeToFirestore)
  final BudgetType budgetType;
  final List<String> _categoryIds;
  @override
  @JsonKey()
  List<String> get categoryIds {
    if (_categoryIds is EqualUnmodifiableListView) return _categoryIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryIds);
  }

  @override
  final int amount;
  @override
  @JsonKey()
  final int spentAmount;
  @override
  @JsonKey()
  final int remainingAmount;
  @override
  @JsonKey(
      fromJson: _budgetPeriodFromFirestore, toJson: _budgetPeriodToFirestore)
  final BudgetPeriod period;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime startDate;
  @override
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime? endDate;
  @override
  @JsonKey()
  final String colorHex;
  @override
  @JsonKey()
  final String icon;
  @override
  @JsonKey()
  final int alertThreshold;
  @override
  @JsonKey()
  final bool notificationsEnabled;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isPaused;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime? deletedAt;
  @override
  @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
  final SyncStatus syncStatus;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime updatedAt;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetCopyWith<_Budget> get copyWith =>
      __$BudgetCopyWithImpl<_Budget>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Budget &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.budgetType, budgetType) ||
                other.budgetType == budgetType) &&
            const DeepCollectionEquality()
                .equals(other._categoryIds, _categoryIds) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.spentAmount, spentAmount) ||
                other.spentAmount == spentAmount) &&
            (identical(other.remainingAmount, remainingAmount) ||
                other.remainingAmount == remainingAmount) &&
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
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        profileId,
        name,
        budgetType,
        const DeepCollectionEquality().hash(_categoryIds),
        amount,
        spentAmount,
        remainingAmount,
        period,
        startDate,
        endDate,
        colorHex,
        icon,
        alertThreshold,
        notificationsEnabled,
        notes,
        isPaused,
        isDeleted,
        deletedAt,
        syncStatus,
        createdAt,
        updatedAt
      ]);

  @override
  String toString() {
    return 'Budget(id: $id, userId: $userId, profileId: $profileId, name: $name, budgetType: $budgetType, categoryIds: $categoryIds, amount: $amount, spentAmount: $spentAmount, remainingAmount: $remainingAmount, period: $period, startDate: $startDate, endDate: $endDate, colorHex: $colorHex, icon: $icon, alertThreshold: $alertThreshold, notificationsEnabled: $notificationsEnabled, notes: $notes, isPaused: $isPaused, isDeleted: $isDeleted, deletedAt: $deletedAt, syncStatus: $syncStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$BudgetCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$BudgetCopyWith(_Budget value, $Res Function(_Budget) _then) =
      __$BudgetCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String profileId,
      String name,
      @JsonKey(
          fromJson: _budgetTypeFromFirestore, toJson: _budgetTypeToFirestore)
      BudgetType budgetType,
      List<String> categoryIds,
      int amount,
      int spentAmount,
      int remainingAmount,
      @JsonKey(
          fromJson: _budgetPeriodFromFirestore,
          toJson: _budgetPeriodToFirestore)
      BudgetPeriod period,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime startDate,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? endDate,
      String colorHex,
      String icon,
      int alertThreshold,
      bool notificationsEnabled,
      String? notes,
      bool isPaused,
      bool isDeleted,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? deletedAt,
      @JsonKey(
          fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
      SyncStatus syncStatus,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime updatedAt});
}

/// @nodoc
class __$BudgetCopyWithImpl<$Res> implements _$BudgetCopyWith<$Res> {
  __$BudgetCopyWithImpl(this._self, this._then);

  final _Budget _self;
  final $Res Function(_Budget) _then;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileId = null,
    Object? name = null,
    Object? budgetType = null,
    Object? categoryIds = null,
    Object? amount = null,
    Object? spentAmount = null,
    Object? remainingAmount = null,
    Object? period = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? colorHex = null,
    Object? icon = null,
    Object? alertThreshold = null,
    Object? notificationsEnabled = null,
    Object? notes = freezed,
    Object? isPaused = null,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? syncStatus = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_Budget(
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      budgetType: null == budgetType
          ? _self.budgetType
          : budgetType // ignore: cast_nullable_to_non_nullable
              as BudgetType,
      categoryIds: null == categoryIds
          ? _self._categoryIds
          : categoryIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      spentAmount: null == spentAmount
          ? _self.spentAmount
          : spentAmount // ignore: cast_nullable_to_non_nullable
              as int,
      remainingAmount: null == remainingAmount
          ? _self.remainingAmount
          : remainingAmount // ignore: cast_nullable_to_non_nullable
              as int,
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
              as int,
      notificationsEnabled: null == notificationsEnabled
          ? _self.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isPaused: null == isPaused
          ? _self.isPaused
          : isPaused // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncStatus: null == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
