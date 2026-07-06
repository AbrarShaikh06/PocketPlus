// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedbackItem {
  String get id;
  String? get userId;
  @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
  FeedbackType get type;
  String? get message;
  int? get rating;
  int? get npsScore;
  String? get screenshotUrl;
  String get appVersion;
  String get platform;
  String get status;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  DateTime get createdAt;

  /// Create a copy of FeedbackItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedbackItemCopyWith<FeedbackItem> get copyWith =>
      _$FeedbackItemCopyWithImpl<FeedbackItem>(
          this as FeedbackItem, _$identity);

  /// Serializes this FeedbackItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedbackItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.npsScore, npsScore) ||
                other.npsScore == npsScore) &&
            (identical(other.screenshotUrl, screenshotUrl) ||
                other.screenshotUrl == screenshotUrl) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, type, message,
      rating, npsScore, screenshotUrl, appVersion, platform, status, createdAt);

  @override
  String toString() {
    return 'FeedbackItem(id: $id, userId: $userId, type: $type, message: $message, rating: $rating, npsScore: $npsScore, screenshotUrl: $screenshotUrl, appVersion: $appVersion, platform: $platform, status: $status, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $FeedbackItemCopyWith<$Res> {
  factory $FeedbackItemCopyWith(
          FeedbackItem value, $Res Function(FeedbackItem) _then) =
      _$FeedbackItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String? userId,
      @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
      FeedbackType type,
      String? message,
      int? rating,
      int? npsScore,
      String? screenshotUrl,
      String appVersion,
      String platform,
      String status,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt});
}

/// @nodoc
class _$FeedbackItemCopyWithImpl<$Res> implements $FeedbackItemCopyWith<$Res> {
  _$FeedbackItemCopyWithImpl(this._self, this._then);

  final FeedbackItem _self;
  final $Res Function(FeedbackItem) _then;

  /// Create a copy of FeedbackItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? type = null,
    Object? message = freezed,
    Object? rating = freezed,
    Object? npsScore = freezed,
    Object? screenshotUrl = freezed,
    Object? appVersion = null,
    Object? platform = null,
    Object? status = null,
    Object? createdAt = null,
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
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as FeedbackType,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      npsScore: freezed == npsScore
          ? _self.npsScore
          : npsScore // ignore: cast_nullable_to_non_nullable
              as int?,
      screenshotUrl: freezed == screenshotUrl
          ? _self.screenshotUrl
          : screenshotUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      appVersion: null == appVersion
          ? _self.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _self.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeedbackItem].
extension FeedbackItemPatterns on FeedbackItem {
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
    TResult Function(_FeedbackItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedbackItem() when $default != null:
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
    TResult Function(_FeedbackItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedbackItem():
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
    TResult? Function(_FeedbackItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedbackItem() when $default != null:
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
            @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
            FeedbackType type,
            String? message,
            int? rating,
            int? npsScore,
            String? screenshotUrl,
            String appVersion,
            String platform,
            String status,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedbackItem() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.type,
            _that.message,
            _that.rating,
            _that.npsScore,
            _that.screenshotUrl,
            _that.appVersion,
            _that.platform,
            _that.status,
            _that.createdAt);
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
            @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
            FeedbackType type,
            String? message,
            int? rating,
            int? npsScore,
            String? screenshotUrl,
            String appVersion,
            String platform,
            String status,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedbackItem():
        return $default(
            _that.id,
            _that.userId,
            _that.type,
            _that.message,
            _that.rating,
            _that.npsScore,
            _that.screenshotUrl,
            _that.appVersion,
            _that.platform,
            _that.status,
            _that.createdAt);
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
            @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
            FeedbackType type,
            String? message,
            int? rating,
            int? npsScore,
            String? screenshotUrl,
            String appVersion,
            String platform,
            String status,
            @JsonKey(
                fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedbackItem() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.type,
            _that.message,
            _that.rating,
            _that.npsScore,
            _that.screenshotUrl,
            _that.appVersion,
            _that.platform,
            _that.status,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FeedbackItem implements FeedbackItem {
  const _FeedbackItem(
      {required this.id,
      this.userId,
      @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
      required this.type,
      this.message,
      this.rating,
      this.npsScore,
      this.screenshotUrl,
      required this.appVersion,
      this.platform = 'android',
      this.status = 'NEW',
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      required this.createdAt});
  factory _FeedbackItem.fromJson(Map<String, dynamic> json) =>
      _$FeedbackItemFromJson(json);

  @override
  final String id;
  @override
  final String? userId;
  @override
  @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
  final FeedbackType type;
  @override
  final String? message;
  @override
  final int? rating;
  @override
  final int? npsScore;
  @override
  final String? screenshotUrl;
  @override
  final String appVersion;
  @override
  @JsonKey()
  final String platform;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime createdAt;

  /// Create a copy of FeedbackItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeedbackItemCopyWith<_FeedbackItem> get copyWith =>
      __$FeedbackItemCopyWithImpl<_FeedbackItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FeedbackItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeedbackItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.npsScore, npsScore) ||
                other.npsScore == npsScore) &&
            (identical(other.screenshotUrl, screenshotUrl) ||
                other.screenshotUrl == screenshotUrl) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, type, message,
      rating, npsScore, screenshotUrl, appVersion, platform, status, createdAt);

  @override
  String toString() {
    return 'FeedbackItem(id: $id, userId: $userId, type: $type, message: $message, rating: $rating, npsScore: $npsScore, screenshotUrl: $screenshotUrl, appVersion: $appVersion, platform: $platform, status: $status, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$FeedbackItemCopyWith<$Res>
    implements $FeedbackItemCopyWith<$Res> {
  factory _$FeedbackItemCopyWith(
          _FeedbackItem value, $Res Function(_FeedbackItem) _then) =
      __$FeedbackItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String? userId,
      @JsonKey(fromJson: _typeFromFirestore, toJson: _typeToFirestore)
      FeedbackType type,
      String? message,
      int? rating,
      int? npsScore,
      String? screenshotUrl,
      String appVersion,
      String platform,
      String status,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
      DateTime createdAt});
}

/// @nodoc
class __$FeedbackItemCopyWithImpl<$Res>
    implements _$FeedbackItemCopyWith<$Res> {
  __$FeedbackItemCopyWithImpl(this._self, this._then);

  final _FeedbackItem _self;
  final $Res Function(_FeedbackItem) _then;

  /// Create a copy of FeedbackItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? type = null,
    Object? message = freezed,
    Object? rating = freezed,
    Object? npsScore = freezed,
    Object? screenshotUrl = freezed,
    Object? appVersion = null,
    Object? platform = null,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_FeedbackItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as FeedbackType,
      message: freezed == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      npsScore: freezed == npsScore
          ? _self.npsScore
          : npsScore // ignore: cast_nullable_to_non_nullable
              as int?,
      screenshotUrl: freezed == screenshotUrl
          ? _self.screenshotUrl
          : screenshotUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      appVersion: null == appVersion
          ? _self.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String,
      platform: null == platform
          ? _self.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
