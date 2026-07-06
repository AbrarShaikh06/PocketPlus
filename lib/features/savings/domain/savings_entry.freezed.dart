// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingsEntry {
  String get id;
  String get goalId;
  String get userId;
  String get profileId;
  int get amount;
  String? get note;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get entryDate;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get createdAt;
  @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
  SyncStatus get syncStatus;

  /// Create a copy of SavingsEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SavingsEntryCopyWith<SavingsEntry> get copyWith =>
      _$SavingsEntryCopyWithImpl<SavingsEntry>(
          this as SavingsEntry, _$identity);

  /// Serializes this SavingsEntry to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SavingsEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, goalId, userId, profileId,
      amount, note, entryDate, createdAt, syncStatus);

  @override
  String toString() {
    return 'SavingsEntry(id: $id, goalId: $goalId, userId: $userId, profileId: $profileId, amount: $amount, note: $note, entryDate: $entryDate, createdAt: $createdAt, syncStatus: $syncStatus)';
  }
}

/// @nodoc
abstract mixin class $SavingsEntryCopyWith<$Res> {
  factory $SavingsEntryCopyWith(
          SavingsEntry value, $Res Function(SavingsEntry) _then) =
      _$SavingsEntryCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String goalId,
      String userId,
      String profileId,
      int amount,
      String? note,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime entryDate,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt,
      @JsonKey(
          fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
      SyncStatus syncStatus});
}

/// @nodoc
class _$SavingsEntryCopyWithImpl<$Res> implements $SavingsEntryCopyWith<$Res> {
  _$SavingsEntryCopyWithImpl(this._self, this._then);

  final SavingsEntry _self;
  final $Res Function(SavingsEntry) _then;

  /// Create a copy of SavingsEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? goalId = null,
    Object? userId = null,
    Object? profileId = null,
    Object? amount = null,
    Object? note = freezed,
    Object? entryDate = null,
    Object? createdAt = null,
    Object? syncStatus = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      goalId: null == goalId
          ? _self.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: null == profileId
          ? _self.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      entryDate: null == entryDate
          ? _self.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncStatus: null == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ));
  }
}

/// Adds pattern-matching-related methods to [SavingsEntry].
extension SavingsEntryPatterns on SavingsEntry {
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
    TResult Function(_SavingsEntry value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SavingsEntry() when $default != null:
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
    TResult Function(_SavingsEntry value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SavingsEntry():
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
    TResult? Function(_SavingsEntry value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SavingsEntry() when $default != null:
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
            String goalId,
            String userId,
            String profileId,
            int amount,
            String? note,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime entryDate,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _syncStatusFromFirestore,
                toJson: _syncStatusToFirestore)
            SyncStatus syncStatus)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SavingsEntry() when $default != null:
        return $default(
            _that.id,
            _that.goalId,
            _that.userId,
            _that.profileId,
            _that.amount,
            _that.note,
            _that.entryDate,
            _that.createdAt,
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
            String goalId,
            String userId,
            String profileId,
            int amount,
            String? note,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime entryDate,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _syncStatusFromFirestore,
                toJson: _syncStatusToFirestore)
            SyncStatus syncStatus)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SavingsEntry():
        return $default(
            _that.id,
            _that.goalId,
            _that.userId,
            _that.profileId,
            _that.amount,
            _that.note,
            _that.entryDate,
            _that.createdAt,
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
            String goalId,
            String userId,
            String profileId,
            int amount,
            String? note,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime entryDate,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _syncStatusFromFirestore,
                toJson: _syncStatusToFirestore)
            SyncStatus syncStatus)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SavingsEntry() when $default != null:
        return $default(
            _that.id,
            _that.goalId,
            _that.userId,
            _that.profileId,
            _that.amount,
            _that.note,
            _that.entryDate,
            _that.createdAt,
            _that.syncStatus);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SavingsEntry implements SavingsEntry {
  const _SavingsEntry(
      {required this.id,
      required this.goalId,
      required this.userId,
      required this.profileId,
      required this.amount,
      this.note,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.entryDate,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.createdAt,
      @JsonKey(
          fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
      this.syncStatus = SyncStatus.pending});
  factory _SavingsEntry.fromJson(Map<String, dynamic> json) =>
      _$SavingsEntryFromJson(json);

  @override
  final String id;
  @override
  final String goalId;
  @override
  final String userId;
  @override
  final String profileId;
  @override
  final int amount;
  @override
  final String? note;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime entryDate;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime createdAt;
  @override
  @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
  final SyncStatus syncStatus;

  /// Create a copy of SavingsEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SavingsEntryCopyWith<_SavingsEntry> get copyWith =>
      __$SavingsEntryCopyWithImpl<_SavingsEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SavingsEntryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SavingsEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, goalId, userId, profileId,
      amount, note, entryDate, createdAt, syncStatus);

  @override
  String toString() {
    return 'SavingsEntry(id: $id, goalId: $goalId, userId: $userId, profileId: $profileId, amount: $amount, note: $note, entryDate: $entryDate, createdAt: $createdAt, syncStatus: $syncStatus)';
  }
}

/// @nodoc
abstract mixin class _$SavingsEntryCopyWith<$Res>
    implements $SavingsEntryCopyWith<$Res> {
  factory _$SavingsEntryCopyWith(
          _SavingsEntry value, $Res Function(_SavingsEntry) _then) =
      __$SavingsEntryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String goalId,
      String userId,
      String profileId,
      int amount,
      String? note,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime entryDate,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt,
      @JsonKey(
          fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
      SyncStatus syncStatus});
}

/// @nodoc
class __$SavingsEntryCopyWithImpl<$Res>
    implements _$SavingsEntryCopyWith<$Res> {
  __$SavingsEntryCopyWithImpl(this._self, this._then);

  final _SavingsEntry _self;
  final $Res Function(_SavingsEntry) _then;

  /// Create a copy of SavingsEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? goalId = null,
    Object? userId = null,
    Object? profileId = null,
    Object? amount = null,
    Object? note = freezed,
    Object? entryDate = null,
    Object? createdAt = null,
    Object? syncStatus = null,
  }) {
    return _then(_SavingsEntry(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      goalId: null == goalId
          ? _self.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      profileId: null == profileId
          ? _self.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      entryDate: null == entryDate
          ? _self.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncStatus: null == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
    ));
  }
}

// dart format on
