// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'khata_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KhataEntry {
  String get id;
  String get customerId;
  String get userId;
  int get amount;
  @JsonKey(fromJson: _entryTypeFromFirestore, toJson: _entryTypeToFirestore)
  KhataEntryType get entryType;
  String? get note;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get entryDate;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get createdAt;

  /// Create a copy of KhataEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KhataEntryCopyWith<KhataEntry> get copyWith =>
      _$KhataEntryCopyWithImpl<KhataEntry>(this as KhataEntry, _$identity);

  /// Serializes this KhataEntry to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KhataEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.entryType, entryType) ||
                other.entryType == entryType) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, customerId, userId, amount,
      entryType, note, entryDate, createdAt);

  @override
  String toString() {
    return 'KhataEntry(id: $id, customerId: $customerId, userId: $userId, amount: $amount, entryType: $entryType, note: $note, entryDate: $entryDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $KhataEntryCopyWith<$Res> {
  factory $KhataEntryCopyWith(
          KhataEntry value, $Res Function(KhataEntry) _then) =
      _$KhataEntryCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String customerId,
      String userId,
      int amount,
      @JsonKey(fromJson: _entryTypeFromFirestore, toJson: _entryTypeToFirestore)
      KhataEntryType entryType,
      String? note,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime entryDate,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt});
}

/// @nodoc
class _$KhataEntryCopyWithImpl<$Res> implements $KhataEntryCopyWith<$Res> {
  _$KhataEntryCopyWithImpl(this._self, this._then);

  final KhataEntry _self;
  final $Res Function(KhataEntry) _then;

  /// Create a copy of KhataEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? userId = null,
    Object? amount = null,
    Object? entryType = null,
    Object? note = freezed,
    Object? entryDate = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _self.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      entryType: null == entryType
          ? _self.entryType
          : entryType // ignore: cast_nullable_to_non_nullable
              as KhataEntryType,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [KhataEntry].
extension KhataEntryPatterns on KhataEntry {
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
    TResult Function(_KhataEntry value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KhataEntry() when $default != null:
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
    TResult Function(_KhataEntry value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KhataEntry():
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
    TResult? Function(_KhataEntry value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KhataEntry() when $default != null:
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
            String customerId,
            String userId,
            int amount,
            @JsonKey(
                fromJson: _entryTypeFromFirestore,
                toJson: _entryTypeToFirestore)
            KhataEntryType entryType,
            String? note,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime entryDate,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KhataEntry() when $default != null:
        return $default(_that.id, _that.customerId, _that.userId, _that.amount,
            _that.entryType, _that.note, _that.entryDate, _that.createdAt);
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
            String customerId,
            String userId,
            int amount,
            @JsonKey(
                fromJson: _entryTypeFromFirestore,
                toJson: _entryTypeToFirestore)
            KhataEntryType entryType,
            String? note,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime entryDate,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KhataEntry():
        return $default(_that.id, _that.customerId, _that.userId, _that.amount,
            _that.entryType, _that.note, _that.entryDate, _that.createdAt);
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
            String customerId,
            String userId,
            int amount,
            @JsonKey(
                fromJson: _entryTypeFromFirestore,
                toJson: _entryTypeToFirestore)
            KhataEntryType entryType,
            String? note,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime entryDate,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KhataEntry() when $default != null:
        return $default(_that.id, _that.customerId, _that.userId, _that.amount,
            _that.entryType, _that.note, _that.entryDate, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _KhataEntry implements KhataEntry {
  const _KhataEntry(
      {required this.id,
      required this.customerId,
      required this.userId,
      required this.amount,
      @JsonKey(fromJson: _entryTypeFromFirestore, toJson: _entryTypeToFirestore)
      required this.entryType,
      this.note,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.entryDate,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.createdAt});
  factory _KhataEntry.fromJson(Map<String, dynamic> json) =>
      _$KhataEntryFromJson(json);

  @override
  final String id;
  @override
  final String customerId;
  @override
  final String userId;
  @override
  final int amount;
  @override
  @JsonKey(fromJson: _entryTypeFromFirestore, toJson: _entryTypeToFirestore)
  final KhataEntryType entryType;
  @override
  final String? note;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime entryDate;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime createdAt;

  /// Create a copy of KhataEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$KhataEntryCopyWith<_KhataEntry> get copyWith =>
      __$KhataEntryCopyWithImpl<_KhataEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$KhataEntryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _KhataEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.customerId, customerId) ||
                other.customerId == customerId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.entryType, entryType) ||
                other.entryType == entryType) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, customerId, userId, amount,
      entryType, note, entryDate, createdAt);

  @override
  String toString() {
    return 'KhataEntry(id: $id, customerId: $customerId, userId: $userId, amount: $amount, entryType: $entryType, note: $note, entryDate: $entryDate, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$KhataEntryCopyWith<$Res>
    implements $KhataEntryCopyWith<$Res> {
  factory _$KhataEntryCopyWith(
          _KhataEntry value, $Res Function(_KhataEntry) _then) =
      __$KhataEntryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String customerId,
      String userId,
      int amount,
      @JsonKey(fromJson: _entryTypeFromFirestore, toJson: _entryTypeToFirestore)
      KhataEntryType entryType,
      String? note,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime entryDate,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt});
}

/// @nodoc
class __$KhataEntryCopyWithImpl<$Res> implements _$KhataEntryCopyWith<$Res> {
  __$KhataEntryCopyWithImpl(this._self, this._then);

  final _KhataEntry _self;
  final $Res Function(_KhataEntry) _then;

  /// Create a copy of KhataEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? customerId = null,
    Object? userId = null,
    Object? amount = null,
    Object? entryType = null,
    Object? note = freezed,
    Object? entryDate = null,
    Object? createdAt = null,
  }) {
    return _then(_KhataEntry(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      customerId: null == customerId
          ? _self.customerId
          : customerId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _self.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      entryType: null == entryType
          ? _self.entryType
          : entryType // ignore: cast_nullable_to_non_nullable
              as KhataEntryType,
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
    ));
  }
}

// dart format on
