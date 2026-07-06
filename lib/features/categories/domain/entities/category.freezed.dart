// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Category {
  String get id;
  String? get userId;
  String? get profileId;
  String get name;
  String get icon;
  String? get colorHex;
  @JsonKey(fromJson: _gstHeadFromFirestore, toJson: _gstHeadToFirestore)
  GstHead? get gstHead;
  @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
  TransactionType get type;
  bool get isSystem;
  int get sortOrder;
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? get createdAt;
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime? get deletedAt;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<Category> get copyWith =>
      _$CategoryCopyWithImpl<Category>(this as Category, _$identity);

  /// Serializes this Category to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Category &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.gstHead, gstHead) || other.gstHead == gstHead) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, profileId, name,
      icon, colorHex, gstHead, type, isSystem, sortOrder, createdAt, deletedAt);

  @override
  String toString() {
    return 'Category(id: $id, userId: $userId, profileId: $profileId, name: $name, icon: $icon, colorHex: $colorHex, gstHead: $gstHead, type: $type, isSystem: $isSystem, sortOrder: $sortOrder, createdAt: $createdAt, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class $CategoryCopyWith<$Res> {
  factory $CategoryCopyWith(Category value, $Res Function(Category) _then) =
      _$CategoryCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? userId,
      String? profileId,
      String name,
      String icon,
      String? colorHex,
      @JsonKey(fromJson: _gstHeadFromFirestore, toJson: _gstHeadToFirestore)
      GstHead? gstHead,
      @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
      TransactionType type,
      bool isSystem,
      int sortOrder,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? createdAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? deletedAt});
}

/// @nodoc
class _$CategoryCopyWithImpl<$Res> implements $CategoryCopyWith<$Res> {
  _$CategoryCopyWithImpl(this._self, this._then);

  final Category _self;
  final $Res Function(Category) _then;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? profileId = freezed,
    Object? name = null,
    Object? icon = null,
    Object? colorHex = freezed,
    Object? gstHead = freezed,
    Object? type = null,
    Object? isSystem = null,
    Object? sortOrder = null,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      profileId: freezed == profileId
          ? _self.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: freezed == colorHex
          ? _self.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      gstHead: freezed == gstHead
          ? _self.gstHead
          : gstHead // ignore: cast_nullable_to_non_nullable
              as GstHead?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      isSystem: null == isSystem
          ? _self.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [Category].
extension CategoryPatterns on Category {
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
    TResult Function(_Category value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Category() when $default != null:
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
    TResult Function(_Category value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Category():
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
    TResult? Function(_Category value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Category() when $default != null:
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
            String? userId,
            String? profileId,
            String name,
            String icon,
            String? colorHex,
            @JsonKey(
                fromJson: _gstHeadFromFirestore, toJson: _gstHeadToFirestore)
            GstHead? gstHead,
            @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
            TransactionType type,
            bool isSystem,
            int sortOrder,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? createdAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Category() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.name,
            _that.icon,
            _that.colorHex,
            _that.gstHead,
            _that.type,
            _that.isSystem,
            _that.sortOrder,
            _that.createdAt,
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
            String? userId,
            String? profileId,
            String name,
            String icon,
            String? colorHex,
            @JsonKey(
                fromJson: _gstHeadFromFirestore, toJson: _gstHeadToFirestore)
            GstHead? gstHead,
            @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
            TransactionType type,
            bool isSystem,
            int sortOrder,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? createdAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Category():
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.name,
            _that.icon,
            _that.colorHex,
            _that.gstHead,
            _that.type,
            _that.isSystem,
            _that.sortOrder,
            _that.createdAt,
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
            String? userId,
            String? profileId,
            String name,
            String icon,
            String? colorHex,
            @JsonKey(
                fromJson: _gstHeadFromFirestore, toJson: _gstHeadToFirestore)
            GstHead? gstHead,
            @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
            TransactionType type,
            bool isSystem,
            int sortOrder,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? createdAt,
            @JsonKey(
                fromJson: _nullableDateTimeFromTimestamp,
                toJson: _dateTimeToTimestamp)
            DateTime? deletedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Category() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.profileId,
            _that.name,
            _that.icon,
            _that.colorHex,
            _that.gstHead,
            _that.type,
            _that.isSystem,
            _that.sortOrder,
            _that.createdAt,
            _that.deletedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Category implements Category {
  const _Category(
      {required this.id,
      this.userId,
      this.profileId,
      required this.name,
      required this.icon,
      this.colorHex,
      @JsonKey(fromJson: _gstHeadFromFirestore, toJson: _gstHeadToFirestore)
      this.gstHead,
      @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
      required this.type,
      this.isSystem = false,
      this.sortOrder = 0,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      this.createdAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      this.deletedAt});
  factory _Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  @override
  final String id;
  @override
  final String? userId;
  @override
  final String? profileId;
  @override
  final String name;
  @override
  final String icon;
  @override
  final String? colorHex;
  @override
  @JsonKey(fromJson: _gstHeadFromFirestore, toJson: _gstHeadToFirestore)
  final GstHead? gstHead;
  @override
  @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
  final TransactionType type;
  @override
  @JsonKey()
  final bool isSystem;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime? createdAt;
  @override
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime? deletedAt;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CategoryCopyWith<_Category> get copyWith =>
      __$CategoryCopyWithImpl<_Category>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CategoryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Category &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.profileId, profileId) ||
                other.profileId == profileId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.gstHead, gstHead) || other.gstHead == gstHead) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isSystem, isSystem) ||
                other.isSystem == isSystem) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, profileId, name,
      icon, colorHex, gstHead, type, isSystem, sortOrder, createdAt, deletedAt);

  @override
  String toString() {
    return 'Category(id: $id, userId: $userId, profileId: $profileId, name: $name, icon: $icon, colorHex: $colorHex, gstHead: $gstHead, type: $type, isSystem: $isSystem, sortOrder: $sortOrder, createdAt: $createdAt, deletedAt: $deletedAt)';
  }
}

/// @nodoc
abstract mixin class _$CategoryCopyWith<$Res>
    implements $CategoryCopyWith<$Res> {
  factory _$CategoryCopyWith(_Category value, $Res Function(_Category) _then) =
      __$CategoryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? userId,
      String? profileId,
      String name,
      String icon,
      String? colorHex,
      @JsonKey(fromJson: _gstHeadFromFirestore, toJson: _gstHeadToFirestore)
      GstHead? gstHead,
      @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
      TransactionType type,
      bool isSystem,
      int sortOrder,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? createdAt,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _dateTimeToTimestamp)
      DateTime? deletedAt});
}

/// @nodoc
class __$CategoryCopyWithImpl<$Res> implements _$CategoryCopyWith<$Res> {
  __$CategoryCopyWithImpl(this._self, this._then);

  final _Category _self;
  final $Res Function(_Category) _then;

  /// Create a copy of Category
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? profileId = freezed,
    Object? name = null,
    Object? icon = null,
    Object? colorHex = freezed,
    Object? gstHead = freezed,
    Object? type = null,
    Object? isSystem = null,
    Object? sortOrder = null,
    Object? createdAt = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_Category(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      profileId: freezed == profileId
          ? _self.profileId
          : profileId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _self.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      colorHex: freezed == colorHex
          ? _self.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String?,
      gstHead: freezed == gstHead
          ? _self.gstHead
          : gstHead // ignore: cast_nullable_to_non_nullable
              as GstHead?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as TransactionType,
      isSystem: null == isSystem
          ? _self.isSystem
          : isSystem // ignore: cast_nullable_to_non_nullable
              as bool,
      sortOrder: null == sortOrder
          ? _self.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
