// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'capture_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CaptureState implements DiagnosticableTreeMixin {
  ParsedSms get parsedSms;
  List<Category> get categories;
  String? get selectedCategoryId;
  bool get isLoadingCategories;
  bool get isSaving;
  String? get error;

  /// Create a copy of CaptureState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CaptureStateCopyWith<CaptureState> get copyWith =>
      _$CaptureStateCopyWithImpl<CaptureState>(
          this as CaptureState, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CaptureState'))
      ..add(DiagnosticsProperty('parsedSms', parsedSms))
      ..add(DiagnosticsProperty('categories', categories))
      ..add(DiagnosticsProperty('selectedCategoryId', selectedCategoryId))
      ..add(DiagnosticsProperty('isLoadingCategories', isLoadingCategories))
      ..add(DiagnosticsProperty('isSaving', isSaving))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CaptureState &&
            (identical(other.parsedSms, parsedSms) ||
                other.parsedSms == parsedSms) &&
            const DeepCollectionEquality()
                .equals(other.categories, categories) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            (identical(other.isLoadingCategories, isLoadingCategories) ||
                other.isLoadingCategories == isLoadingCategories) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      parsedSms,
      const DeepCollectionEquality().hash(categories),
      selectedCategoryId,
      isLoadingCategories,
      isSaving,
      error);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CaptureState(parsedSms: $parsedSms, categories: $categories, selectedCategoryId: $selectedCategoryId, isLoadingCategories: $isLoadingCategories, isSaving: $isSaving, error: $error)';
  }
}

/// @nodoc
abstract mixin class $CaptureStateCopyWith<$Res> {
  factory $CaptureStateCopyWith(
          CaptureState value, $Res Function(CaptureState) _then) =
      _$CaptureStateCopyWithImpl;
  @useResult
  $Res call(
      {ParsedSms parsedSms,
      List<Category> categories,
      String? selectedCategoryId,
      bool isLoadingCategories,
      bool isSaving,
      String? error});

  $ParsedSmsCopyWith<$Res> get parsedSms;
}

/// @nodoc
class _$CaptureStateCopyWithImpl<$Res> implements $CaptureStateCopyWith<$Res> {
  _$CaptureStateCopyWithImpl(this._self, this._then);

  final CaptureState _self;
  final $Res Function(CaptureState) _then;

  /// Create a copy of CaptureState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parsedSms = null,
    Object? categories = null,
    Object? selectedCategoryId = freezed,
    Object? isLoadingCategories = null,
    Object? isSaving = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      parsedSms: null == parsedSms
          ? _self.parsedSms
          : parsedSms // ignore: cast_nullable_to_non_nullable
              as ParsedSms,
      categories: null == categories
          ? _self.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      selectedCategoryId: freezed == selectedCategoryId
          ? _self.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoadingCategories: null == isLoadingCategories
          ? _self.isLoadingCategories
          : isLoadingCategories // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of CaptureState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParsedSmsCopyWith<$Res> get parsedSms {
    return $ParsedSmsCopyWith<$Res>(_self.parsedSms, (value) {
      return _then(_self.copyWith(parsedSms: value));
    });
  }
}

/// Adds pattern-matching-related methods to [CaptureState].
extension CaptureStatePatterns on CaptureState {
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
    TResult Function(_CaptureState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CaptureState() when $default != null:
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
    TResult Function(_CaptureState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CaptureState():
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
    TResult? Function(_CaptureState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CaptureState() when $default != null:
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
            ParsedSms parsedSms,
            List<Category> categories,
            String? selectedCategoryId,
            bool isLoadingCategories,
            bool isSaving,
            String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CaptureState() when $default != null:
        return $default(
            _that.parsedSms,
            _that.categories,
            _that.selectedCategoryId,
            _that.isLoadingCategories,
            _that.isSaving,
            _that.error);
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
            ParsedSms parsedSms,
            List<Category> categories,
            String? selectedCategoryId,
            bool isLoadingCategories,
            bool isSaving,
            String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CaptureState():
        return $default(
            _that.parsedSms,
            _that.categories,
            _that.selectedCategoryId,
            _that.isLoadingCategories,
            _that.isSaving,
            _that.error);
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
            ParsedSms parsedSms,
            List<Category> categories,
            String? selectedCategoryId,
            bool isLoadingCategories,
            bool isSaving,
            String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CaptureState() when $default != null:
        return $default(
            _that.parsedSms,
            _that.categories,
            _that.selectedCategoryId,
            _that.isLoadingCategories,
            _that.isSaving,
            _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CaptureState with DiagnosticableTreeMixin implements CaptureState {
  const _CaptureState(
      {required this.parsedSms,
      required final List<Category> categories,
      this.selectedCategoryId,
      required this.isLoadingCategories,
      required this.isSaving,
      this.error})
      : _categories = categories;

  @override
  final ParsedSms parsedSms;
  final List<Category> _categories;
  @override
  List<Category> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final String? selectedCategoryId;
  @override
  final bool isLoadingCategories;
  @override
  final bool isSaving;
  @override
  final String? error;

  /// Create a copy of CaptureState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CaptureStateCopyWith<_CaptureState> get copyWith =>
      __$CaptureStateCopyWithImpl<_CaptureState>(this, _$identity);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('type', 'CaptureState'))
      ..add(DiagnosticsProperty('parsedSms', parsedSms))
      ..add(DiagnosticsProperty('categories', categories))
      ..add(DiagnosticsProperty('selectedCategoryId', selectedCategoryId))
      ..add(DiagnosticsProperty('isLoadingCategories', isLoadingCategories))
      ..add(DiagnosticsProperty('isSaving', isSaving))
      ..add(DiagnosticsProperty('error', error));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CaptureState &&
            (identical(other.parsedSms, parsedSms) ||
                other.parsedSms == parsedSms) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.selectedCategoryId, selectedCategoryId) ||
                other.selectedCategoryId == selectedCategoryId) &&
            (identical(other.isLoadingCategories, isLoadingCategories) ||
                other.isLoadingCategories == isLoadingCategories) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      parsedSms,
      const DeepCollectionEquality().hash(_categories),
      selectedCategoryId,
      isLoadingCategories,
      isSaving,
      error);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CaptureState(parsedSms: $parsedSms, categories: $categories, selectedCategoryId: $selectedCategoryId, isLoadingCategories: $isLoadingCategories, isSaving: $isSaving, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$CaptureStateCopyWith<$Res>
    implements $CaptureStateCopyWith<$Res> {
  factory _$CaptureStateCopyWith(
          _CaptureState value, $Res Function(_CaptureState) _then) =
      __$CaptureStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ParsedSms parsedSms,
      List<Category> categories,
      String? selectedCategoryId,
      bool isLoadingCategories,
      bool isSaving,
      String? error});

  @override
  $ParsedSmsCopyWith<$Res> get parsedSms;
}

/// @nodoc
class __$CaptureStateCopyWithImpl<$Res>
    implements _$CaptureStateCopyWith<$Res> {
  __$CaptureStateCopyWithImpl(this._self, this._then);

  final _CaptureState _self;
  final $Res Function(_CaptureState) _then;

  /// Create a copy of CaptureState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? parsedSms = null,
    Object? categories = null,
    Object? selectedCategoryId = freezed,
    Object? isLoadingCategories = null,
    Object? isSaving = null,
    Object? error = freezed,
  }) {
    return _then(_CaptureState(
      parsedSms: null == parsedSms
          ? _self.parsedSms
          : parsedSms // ignore: cast_nullable_to_non_nullable
              as ParsedSms,
      categories: null == categories
          ? _self._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      selectedCategoryId: freezed == selectedCategoryId
          ? _self.selectedCategoryId
          : selectedCategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoadingCategories: null == isLoadingCategories
          ? _self.isLoadingCategories
          : isLoadingCategories // ignore: cast_nullable_to_non_nullable
              as bool,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of CaptureState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParsedSmsCopyWith<$Res> get parsedSms {
    return $ParsedSmsCopyWith<$Res>(_self.parsedSms, (value) {
      return _then(_self.copyWith(parsedSms: value));
    });
  }
}

// dart format on
