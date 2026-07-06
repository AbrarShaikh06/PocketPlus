// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingsGoal {
  String get id;
  String get userId;
  String get profileId;
  String get name;
  @JsonKey(fromJson: _categoryFromFirestore, toJson: _categoryToFirestore)
  SavingsCategory get category;
  int get targetAmount;
  int get savedAmount;
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? get targetDate;
  String? get notes;
  bool get isAchieved;
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? get achievedAt;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get createdAt;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get updatedAt;
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? get deletedAt;
  @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
  SyncStatus get syncStatus;

  /// Create a copy of SavingsGoal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SavingsGoalCopyWith<SavingsGoal> get copyWith =>
      _$SavingsGoalCopyWithImpl<SavingsGoal>(this as SavingsGoal, _$identity);

  /// Serializes this SavingsGoal to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SavingsGoal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.savedAmount, savedAmount) ||
                other.savedAmount == savedAmount) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isAchieved, isAchieved) ||
                other.isAchieved == isAchieved) &&
            (identical(other.achievedAt, achievedAt) ||
                other.achievedAt == achievedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      profileId,
      name,
      category,
      targetAmount,
      savedAmount,
      targetDate,
      notes,
      isAchieved,
      achievedAt,
      createdAt,
      updatedAt,
      deletedAt,
      syncStatus);

  @override
  String toString() {
    return 'SavingsGoal(id: $id, userId: $userId, profileId: $profileId, name: $name, category: $category, targetAmount: $targetAmount, savedAmount: $savedAmount, targetDate: $targetDate, notes: $notes, isAchieved: $isAchieved, achievedAt: $achievedAt, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncStatus: $syncStatus)';
  }
}

/// @nodoc
abstract mixin class $SavingsGoalCopyWith<$Res> {
  factory $SavingsGoalCopyWith(
          SavingsGoal value, $Res Function(SavingsGoal) _then) =
      _$SavingsGoalCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String profileId,
      String name,
      @JsonKey(fromJson: _categoryFromFirestore, toJson: _categoryToFirestore)
      SavingsCategory category,
      int targetAmount,
      int savedAmount,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? targetDate,
      String? notes,
      bool isAchieved,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? achievedAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime updatedAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? deletedAt,
      @JsonKey(
          fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
      SyncStatus syncStatus});
}

/// @nodoc
class _$SavingsGoalCopyWithImpl<$Res> implements $SavingsGoalCopyWith<$Res> {
  _$SavingsGoalCopyWithImpl(this._self, this._then);

  final SavingsGoal _self;
  final $Res Function(SavingsGoal) _then;

  /// Create a copy of SavingsGoal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileId = null,
    Object? name = null,
    Object? category = null,
    Object? targetAmount = null,
    Object? savedAmount = null,
    Object? targetDate = freezed,
    Object? notes = freezed,
    Object? isAchieved = null,
    Object? achievedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? syncStatus = null,
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
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as SavingsCategory,
      targetAmount: null == targetAmount
          ? _self.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as int,
      savedAmount: null == savedAmount
          ? _self.savedAmount
          : savedAmount // ignore: cast_nullable_to_non_nullable
              as int,
      targetDate: freezed == targetDate
          ? _self.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isAchieved: null == isAchieved
          ? _self.isAchieved
          : isAchieved // ignore: cast_nullable_to_non_nullable
              as bool,
      achievedAt: freezed == achievedAt
          ? _self.achievedAt
          : achievedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      syncStatus: null == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ));
  }
}

/// Adds pattern-matching-related methods to [SavingsGoal].
extension SavingsGoalPatterns on SavingsGoal {
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
    TResult Function(_SavingsGoal value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SavingsGoal() when $default != null:
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
    TResult Function(_SavingsGoal value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SavingsGoal():
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
    TResult? Function(_SavingsGoal value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SavingsGoal() when $default != null:
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
                fromJson: _categoryFromFirestore, toJson: _categoryToFirestore)
            SavingsCategory category,
            int targetAmount,
            int savedAmount,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? targetDate,
            String? notes,
            bool isAchieved,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? achievedAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime updatedAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt,
            @JsonKey(
                fromJson: _syncStatusFromFirestore,
                toJson: _syncStatusToFirestore)
            SyncStatus syncStatus)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SavingsGoal() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.name,
            _that.category,
            _that.targetAmount,
            _that.savedAmount,
            _that.targetDate,
            _that.notes,
            _that.isAchieved,
            _that.achievedAt,
            _that.createdAt,
            _that.updatedAt,
            _that.deletedAt,
            _that.syncStatus);
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
                fromJson: _categoryFromFirestore, toJson: _categoryToFirestore)
            SavingsCategory category,
            int targetAmount,
            int savedAmount,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? targetDate,
            String? notes,
            bool isAchieved,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? achievedAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime updatedAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt,
            @JsonKey(
                fromJson: _syncStatusFromFirestore,
                toJson: _syncStatusToFirestore)
            SyncStatus syncStatus)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SavingsGoal():
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.name,
            _that.category,
            _that.targetAmount,
            _that.savedAmount,
            _that.targetDate,
            _that.notes,
            _that.isAchieved,
            _that.achievedAt,
            _that.createdAt,
            _that.updatedAt,
            _that.deletedAt,
            _that.syncStatus);
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
                fromJson: _categoryFromFirestore, toJson: _categoryToFirestore)
            SavingsCategory category,
            int targetAmount,
            int savedAmount,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? targetDate,
            String? notes,
            bool isAchieved,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? achievedAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime updatedAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt,
            @JsonKey(
                fromJson: _syncStatusFromFirestore,
                toJson: _syncStatusToFirestore)
            SyncStatus syncStatus)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SavingsGoal() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.name,
            _that.category,
            _that.targetAmount,
            _that.savedAmount,
            _that.targetDate,
            _that.notes,
            _that.isAchieved,
            _that.achievedAt,
            _that.createdAt,
            _that.updatedAt,
            _that.deletedAt,
            _that.syncStatus);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SavingsGoal implements SavingsGoal {
  const _SavingsGoal(
      {required this.id,
      required this.userId,
      required this.profileId,
      required this.name,
      @JsonKey(fromJson: _categoryFromFirestore, toJson: _categoryToFirestore)
      required this.category,
      required this.targetAmount,
      required this.savedAmount,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      this.targetDate,
      this.notes,
      this.isAchieved = false,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      this.achievedAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.createdAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.updatedAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      this.deletedAt,
      @JsonKey(
          fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
      this.syncStatus = SyncStatus.pending});
  factory _SavingsGoal.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String profileId;
  @override
  final String name;
  @override
  @JsonKey(fromJson: _categoryFromFirestore, toJson: _categoryToFirestore)
  final SavingsCategory category;
  @override
  final int targetAmount;
  @override
  final int savedAmount;
  @override
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime? targetDate;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isAchieved;
  @override
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime? achievedAt;
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
  @override
  @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
  final SyncStatus syncStatus;

  /// Create a copy of SavingsGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SavingsGoalCopyWith<_SavingsGoal> get copyWith =>
      __$SavingsGoalCopyWithImpl<_SavingsGoal>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SavingsGoalToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SavingsGoal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.targetAmount, targetAmount) ||
                other.targetAmount == targetAmount) &&
            (identical(other.savedAmount, savedAmount) ||
                other.savedAmount == savedAmount) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isAchieved, isAchieved) ||
                other.isAchieved == isAchieved) &&
            (identical(other.achievedAt, achievedAt) ||
                other.achievedAt == achievedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      profileId,
      name,
      category,
      targetAmount,
      savedAmount,
      targetDate,
      notes,
      isAchieved,
      achievedAt,
      createdAt,
      updatedAt,
      deletedAt,
      syncStatus);

  @override
  String toString() {
    return 'SavingsGoal(id: $id, userId: $userId, profileId: $profileId, name: $name, category: $category, targetAmount: $targetAmount, savedAmount: $savedAmount, targetDate: $targetDate, notes: $notes, isAchieved: $isAchieved, achievedAt: $achievedAt, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, syncStatus: $syncStatus)';
  }
}

/// @nodoc
abstract mixin class _$SavingsGoalCopyWith<$Res>
    implements $SavingsGoalCopyWith<$Res> {
  factory _$SavingsGoalCopyWith(
          _SavingsGoal value, $Res Function(_SavingsGoal) _then) =
      __$SavingsGoalCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String profileId,
      String name,
      @JsonKey(fromJson: _categoryFromFirestore, toJson: _categoryToFirestore)
      SavingsCategory category,
      int targetAmount,
      int savedAmount,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? targetDate,
      String? notes,
      bool isAchieved,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? achievedAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime updatedAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? deletedAt,
      @JsonKey(
          fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
      SyncStatus syncStatus});
}

/// @nodoc
class __$SavingsGoalCopyWithImpl<$Res> implements _$SavingsGoalCopyWith<$Res> {
  __$SavingsGoalCopyWithImpl(this._self, this._then);

  final _SavingsGoal _self;
  final $Res Function(_SavingsGoal) _then;

  /// Create a copy of SavingsGoal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileId = null,
    Object? name = null,
    Object? category = null,
    Object? targetAmount = null,
    Object? savedAmount = null,
    Object? targetDate = freezed,
    Object? notes = freezed,
    Object? isAchieved = null,
    Object? achievedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
    Object? syncStatus = null,
  }) {
    return _then(_SavingsGoal(
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
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as SavingsCategory,
      targetAmount: null == targetAmount
          ? _self.targetAmount
          : targetAmount // ignore: cast_nullable_to_non_nullable
              as int,
      savedAmount: null == savedAmount
          ? _self.savedAmount
          : savedAmount // ignore: cast_nullable_to_non_nullable
              as int,
      targetDate: freezed == targetDate
          ? _self.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isAchieved: null == isAchieved
          ? _self.isAchieved
          : isAchieved // ignore: cast_nullable_to_non_nullable
              as bool,
      achievedAt: freezed == achievedAt
          ? _self.achievedAt
          : achievedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      syncStatus: null == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ));
  }
}

// dart format on
