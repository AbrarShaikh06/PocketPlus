// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {
  String get id;
  String get userId;
  String get name;
  @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
  ProfileType get type;
  String get colorHex;
  List<String> get upiIds;
  List<String> get bankAccountLast4;
  bool get isDefault;
  @JsonKey(
      fromJson: _fiscalYearStartFromFirestore,
      toJson: _fiscalYearStartToFirestore)
  FiscalYearStart get fiscalYearStart;
  String get currency;
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? get createdAt;
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? get updatedAt;
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? get deletedAt;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<Profile> get copyWith =>
      _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Profile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            const DeepCollectionEquality().equals(other.upiIds, upiIds) &&
            const DeepCollectionEquality()
                .equals(other.bankAccountLast4, bankAccountLast4) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.fiscalYearStart, fiscalYearStart) ||
                other.fiscalYearStart == fiscalYearStart) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      name,
      type,
      colorHex,
      const DeepCollectionEquality().hash(upiIds),
      const DeepCollectionEquality().hash(bankAccountLast4),
      isDefault,
      fiscalYearStart,
      currency,
      createdAt,
      updatedAt,
      deletedAt);

  @override
  String toString() {
    return 'Profile(id: $id, userId: $userId, name: $name, type: $type, colorHex: $colorHex, upiIds: $upiIds, bankAccountLast4: $bankAccountLast4, isDefault: $isDefault, fiscalYearStart: $fiscalYearStart, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res> {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) =
      _$ProfileCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
      ProfileType type,
      String colorHex,
      List<String> upiIds,
      List<String> bankAccountLast4,
      bool isDefault,
      @JsonKey(
          fromJson: _fiscalYearStartFromFirestore,
          toJson: _fiscalYearStartToFirestore)
      FiscalYearStart fiscalYearStart,
      String currency,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? createdAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? updatedAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? deletedAt});
}

/// @nodoc
class _$ProfileCopyWithImpl<$Res> implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? type = null,
    Object? colorHex = null,
    Object? upiIds = null,
    Object? bankAccountLast4 = null,
    Object? isDefault = null,
    Object? fiscalYearStart = null,
    Object? currency = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as ProfileType,
      colorHex: null == colorHex
          ? _self.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      upiIds: null == upiIds
          ? _self.upiIds
          : upiIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bankAccountLast4: null == bankAccountLast4
          ? _self.bankAccountLast4
          : bankAccountLast4 // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isDefault: null == isDefault
          ? _self.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      fiscalYearStart: null == fiscalYearStart
          ? _self.fiscalYearStart
          : fiscalYearStart // ignore: cast_nullable_to_non_nullable
              as FiscalYearStart,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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
    TResult Function(_Profile value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Profile() when $default != null:
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
    TResult Function(_Profile value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Profile():
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
    TResult? Function(_Profile value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Profile() when $default != null:
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
            String name,
            @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
            ProfileType type,
            String colorHex,
            List<String> upiIds,
            List<String> bankAccountLast4,
            bool isDefault,
            @JsonKey(
                fromJson: _fiscalYearStartFromFirestore,
                toJson: _fiscalYearStartToFirestore)
            FiscalYearStart fiscalYearStart,
            String currency,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? createdAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? updatedAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Profile() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.name,
            _that.type,
            _that.colorHex,
            _that.upiIds,
            _that.bankAccountLast4,
            _that.isDefault,
            _that.fiscalYearStart,
            _that.currency,
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
            String name,
            @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
            ProfileType type,
            String colorHex,
            List<String> upiIds,
            List<String> bankAccountLast4,
            bool isDefault,
            @JsonKey(
                fromJson: _fiscalYearStartFromFirestore,
                toJson: _fiscalYearStartToFirestore)
            FiscalYearStart fiscalYearStart,
            String currency,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? createdAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? updatedAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Profile():
        return $default(
            _that.id,
            _that.userId,
            _that.name,
            _that.type,
            _that.colorHex,
            _that.upiIds,
            _that.bankAccountLast4,
            _that.isDefault,
            _that.fiscalYearStart,
            _that.currency,
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
            String name,
            @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
            ProfileType type,
            String colorHex,
            List<String> upiIds,
            List<String> bankAccountLast4,
            bool isDefault,
            @JsonKey(
                fromJson: _fiscalYearStartFromFirestore,
                toJson: _fiscalYearStartToFirestore)
            FiscalYearStart fiscalYearStart,
            String currency,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? createdAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? updatedAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Profile() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.name,
            _that.type,
            _that.colorHex,
            _that.upiIds,
            _that.bankAccountLast4,
            _that.isDefault,
            _that.fiscalYearStart,
            _that.currency,
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
class _Profile implements Profile {
  const _Profile(
      {required this.id,
      required this.userId,
      required this.name,
      @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
      required this.type,
      this.colorHex = '#0D631B',
      final List<String> upiIds = const [],
      final List<String> bankAccountLast4 = const [],
      this.isDefault = false,
      @JsonKey(
          fromJson: _fiscalYearStartFromFirestore,
          toJson: _fiscalYearStartToFirestore)
      this.fiscalYearStart = FiscalYearStart.apr,
      this.currency = 'INR',
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      this.createdAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      this.updatedAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      this.deletedAt})
      : _upiIds = upiIds,
        _bankAccountLast4 = bankAccountLast4;
  factory _Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  @override
  @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
  final ProfileType type;
  @override
  @JsonKey()
  final String colorHex;
  final List<String> _upiIds;
  @override
  @JsonKey()
  List<String> get upiIds {
    if (_upiIds is EqualUnmodifiableListView) return _upiIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upiIds);
  }

  final List<String> _bankAccountLast4;
  @override
  @JsonKey()
  List<String> get bankAccountLast4 {
    if (_bankAccountLast4 is EqualUnmodifiableListView)
      return _bankAccountLast4;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bankAccountLast4);
  }

  @override
  @JsonKey()
  final bool isDefault;
  @override
  @JsonKey(
      fromJson: _fiscalYearStartFromFirestore,
      toJson: _fiscalYearStartToFirestore)
  final FiscalYearStart fiscalYearStart;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime? createdAt;
  @override
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime? updatedAt;
  @override
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime? deletedAt;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProfileCopyWith<_Profile> get copyWith =>
      __$ProfileCopyWithImpl<_Profile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProfileToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Profile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            const DeepCollectionEquality().equals(other._upiIds, _upiIds) &&
            const DeepCollectionEquality()
                .equals(other._bankAccountLast4, _bankAccountLast4) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.fiscalYearStart, fiscalYearStart) ||
                other.fiscalYearStart == fiscalYearStart) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      name,
      type,
      colorHex,
      const DeepCollectionEquality().hash(_upiIds),
      const DeepCollectionEquality().hash(_bankAccountLast4),
      isDefault,
      fiscalYearStart,
      currency,
      createdAt,
      updatedAt,
      deletedAt);

  @override
  String toString() {
    return 'Profile(id: $id, userId: $userId, name: $name, type: $type, colorHex: $colorHex, upiIds: $upiIds, bankAccountLast4: $bankAccountLast4, isDefault: $isDefault, fiscalYearStart: $fiscalYearStart, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) =
      __$ProfileCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
      ProfileType type,
      String colorHex,
      List<String> upiIds,
      List<String> bankAccountLast4,
      bool isDefault,
      @JsonKey(
          fromJson: _fiscalYearStartFromFirestore,
          toJson: _fiscalYearStartToFirestore)
      FiscalYearStart fiscalYearStart,
      String currency,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? createdAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? updatedAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? deletedAt});
}

/// @nodoc
class __$ProfileCopyWithImpl<$Res> implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

  /// Create a copy of Profile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? type = null,
    Object? colorHex = null,
    Object? upiIds = null,
    Object? bankAccountLast4 = null,
    Object? isDefault = null,
    Object? fiscalYearStart = null,
    Object? currency = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_Profile(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as ProfileType,
      colorHex: null == colorHex
          ? _self.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      upiIds: null == upiIds
          ? _self._upiIds
          : upiIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bankAccountLast4: null == bankAccountLast4
          ? _self._bankAccountLast4
          : bankAccountLast4 // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isDefault: null == isDefault
          ? _self.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      fiscalYearStart: null == fiscalYearStart
          ? _self.fiscalYearStart
          : fiscalYearStart // ignore: cast_nullable_to_non_nullable
              as FiscalYearStart,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
