// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'khata_customer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KhataCustomer {
  String get id;
  String get userId;
  String get profileId;
  String get name;
  String? get phone;
  int get balance;
  String? get notes;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get createdAt;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get updatedAt;
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? get deletedAt;

  /// Create a copy of KhataCustomer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KhataCustomerCopyWith<KhataCustomer> get copyWith =>
      _$KhataCustomerCopyWithImpl<KhataCustomer>(
          this as KhataCustomer, _$identity);

  /// Serializes this KhataCustomer to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KhataCustomer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, profileId, name,
      phone, balance, notes, createdAt, updatedAt, deletedAt);

  @override
  String toString() {
    return 'KhataCustomer(id: $id, userId: $userId, profileId: $profileId, name: $name, phone: $phone, balance: $balance, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class $KhataCustomerCopyWith<$Res> {
  factory $KhataCustomerCopyWith(
          KhataCustomer value, $Res Function(KhataCustomer) _then) =
      _$KhataCustomerCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String profileId,
      String name,
      String? phone,
      int balance,
      String? notes,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime updatedAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? deletedAt});
}

/// @nodoc
class _$KhataCustomerCopyWithImpl<$Res>
    implements $KhataCustomerCopyWith<$Res> {
  _$KhataCustomerCopyWithImpl(this._self, this._then);

  final KhataCustomer _self;
  final $Res Function(KhataCustomer) _then;

  /// Create a copy of KhataCustomer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileId = null,
    Object? name = null,
    Object? phone = freezed,
    Object? balance = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
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
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: null == balance
          ? _self.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [KhataCustomer].
extension KhataCustomerPatterns on KhataCustomer {
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
    TResult Function(_KhataCustomer value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KhataCustomer() when $default != null:
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
    TResult Function(_KhataCustomer value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KhataCustomer():
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
    TResult? Function(_KhataCustomer value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KhataCustomer() when $default != null:
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
            String? phone,
            int balance,
            String? notes,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime updatedAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KhataCustomer() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.name,
            _that.phone,
            _that.balance,
            _that.notes,
            _that.createdAt,
            _that.updatedAt,
            _that.deletedAt);
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
            String? phone,
            int balance,
            String? notes,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime updatedAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KhataCustomer():
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.name,
            _that.phone,
            _that.balance,
            _that.notes,
            _that.createdAt,
            _that.updatedAt,
            _that.deletedAt);
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
            String? phone,
            int balance,
            String? notes,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime updatedAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KhataCustomer() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.name,
            _that.phone,
            _that.balance,
            _that.notes,
            _that.createdAt,
            _that.updatedAt,
            _that.deletedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _KhataCustomer implements KhataCustomer {
  const _KhataCustomer(
      {required this.id,
      required this.userId,
      required this.profileId,
      required this.name,
      this.phone,
      this.balance = 0,
      this.notes,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.createdAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.updatedAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      this.deletedAt});
  factory _KhataCustomer.fromJson(Map<String, dynamic> json) =>
      _$KhataCustomerFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String profileId;
  @override
  final String name;
  @override
  final String? phone;
  @override
  @JsonKey()
  final int balance;
  @override
  final String? notes;
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

  /// Create a copy of KhataCustomer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$KhataCustomerCopyWith<_KhataCustomer> get copyWith =>
      __$KhataCustomerCopyWithImpl<_KhataCustomer>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$KhataCustomerToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _KhataCustomer &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, profileId, name,
      phone, balance, notes, createdAt, updatedAt, deletedAt);

  @override
  String toString() {
    return 'KhataCustomer(id: $id, userId: $userId, profileId: $profileId, name: $name, phone: $phone, balance: $balance, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class _$KhataCustomerCopyWith<$Res>
    implements $KhataCustomerCopyWith<$Res> {
  factory _$KhataCustomerCopyWith(
          _KhataCustomer value, $Res Function(_KhataCustomer) _then) =
      __$KhataCustomerCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String profileId,
      String name,
      String? phone,
      int balance,
      String? notes,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime updatedAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? deletedAt});
}

/// @nodoc
class __$KhataCustomerCopyWithImpl<$Res>
    implements _$KhataCustomerCopyWith<$Res> {
  __$KhataCustomerCopyWithImpl(this._self, this._then);

  final _KhataCustomer _self;
  final $Res Function(_KhataCustomer) _then;

  /// Create a copy of KhataCustomer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? profileId = null,
    Object? name = null,
    Object? phone = freezed,
    Object? balance = null,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? deletedAt = freezed,
  }) {
    return _then(_KhataCustomer(
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
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      balance: null == balance
          ? _self.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as int,
      notes: freezed == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
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
    ));
  }
}

// dart format on
