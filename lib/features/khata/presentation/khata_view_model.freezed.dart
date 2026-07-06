// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'khata_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$KhataListState {
  List<KhataCustomer> get customers;
  bool get isLoading;
  String? get error;

  /// Create a copy of KhataListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $KhataListStateCopyWith<KhataListState> get copyWith =>
      _$KhataListStateCopyWithImpl<KhataListState>(
          this as KhataListState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is KhataListState &&
            const DeepCollectionEquality().equals(other.customers, customers) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(customers), isLoading, error);

  @override
  String toString() {
    return 'KhataListState(customers: $customers, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class $KhataListStateCopyWith<$Res> {
  factory $KhataListStateCopyWith(
          KhataListState value, $Res Function(KhataListState) _then) =
      _$KhataListStateCopyWithImpl;
  @useResult
  $Res call({List<KhataCustomer> customers, bool isLoading, String? error});
}

/// @nodoc
class _$KhataListStateCopyWithImpl<$Res>
    implements $KhataListStateCopyWith<$Res> {
  _$KhataListStateCopyWithImpl(this._self, this._then);

  final KhataListState _self;
  final $Res Function(KhataListState) _then;

  /// Create a copy of KhataListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customers = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      customers: null == customers
          ? _self.customers
          : customers // ignore: cast_nullable_to_non_nullable
              as List<KhataCustomer>,
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

/// Adds pattern-matching-related methods to [KhataListState].
extension KhataListStatePatterns on KhataListState {
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
    TResult Function(_KhataListState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KhataListState() when $default != null:
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
    TResult Function(_KhataListState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KhataListState():
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
    TResult? Function(_KhataListState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KhataListState() when $default != null:
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
            List<KhataCustomer> customers, bool isLoading, String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _KhataListState() when $default != null:
        return $default(_that.customers, _that.isLoading, _that.error);
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
            List<KhataCustomer> customers, bool isLoading, String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KhataListState():
        return $default(_that.customers, _that.isLoading, _that.error);
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
            List<KhataCustomer> customers, bool isLoading, String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _KhataListState() when $default != null:
        return $default(_that.customers, _that.isLoading, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _KhataListState implements KhataListState {
  const _KhataListState(
      {required final List<KhataCustomer> customers,
      required this.isLoading,
      this.error})
      : _customers = customers;

  final List<KhataCustomer> _customers;
  @override
  List<KhataCustomer> get customers {
    if (_customers is EqualUnmodifiableListView) return _customers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customers);
  }

  @override
  final bool isLoading;
  @override
  final String? error;

  /// Create a copy of KhataListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$KhataListStateCopyWith<_KhataListState> get copyWith =>
      __$KhataListStateCopyWithImpl<_KhataListState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _KhataListState &&
            const DeepCollectionEquality()
                .equals(other._customers, _customers) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_customers), isLoading, error);

  @override
  String toString() {
    return 'KhataListState(customers: $customers, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$KhataListStateCopyWith<$Res>
    implements $KhataListStateCopyWith<$Res> {
  factory _$KhataListStateCopyWith(
          _KhataListState value, $Res Function(_KhataListState) _then) =
      __$KhataListStateCopyWithImpl;
  @override
  @useResult
  $Res call({List<KhataCustomer> customers, bool isLoading, String? error});
}

/// @nodoc
class __$KhataListStateCopyWithImpl<$Res>
    implements _$KhataListStateCopyWith<$Res> {
  __$KhataListStateCopyWithImpl(this._self, this._then);

  final _KhataListState _self;
  final $Res Function(_KhataListState) _then;

  /// Create a copy of KhataListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? customers = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_KhataListState(
      customers: null == customers
          ? _self._customers
          : customers // ignore: cast_nullable_to_non_nullable
              as List<KhataCustomer>,
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
mixin _$AddCustomerState {
  String get name;
  String get phone;
  String? get nameError;
  String? get phoneError;
  bool get isSaving;

  /// Create a copy of AddCustomerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddCustomerStateCopyWith<AddCustomerState> get copyWith =>
      _$AddCustomerStateCopyWithImpl<AddCustomerState>(
          this as AddCustomerState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddCustomerState &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.nameError, nameError) ||
                other.nameError == nameError) &&
            (identical(other.phoneError, phoneError) ||
                other.phoneError == phoneError) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, name, phone, nameError, phoneError, isSaving);

  @override
  String toString() {
    return 'AddCustomerState(name: $name, phone: $phone, nameError: $nameError, phoneError: $phoneError, isSaving: $isSaving)';
  }
}

/// @nodoc
abstract mixin class $AddCustomerStateCopyWith<$Res> {
  factory $AddCustomerStateCopyWith(
          AddCustomerState value, $Res Function(AddCustomerState) _then) =
      _$AddCustomerStateCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      String phone,
      String? nameError,
      String? phoneError,
      bool isSaving});
}

/// @nodoc
class _$AddCustomerStateCopyWithImpl<$Res>
    implements $AddCustomerStateCopyWith<$Res> {
  _$AddCustomerStateCopyWithImpl(this._self, this._then);

  final AddCustomerState _self;
  final $Res Function(AddCustomerState) _then;

  /// Create a copy of AddCustomerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? phone = null,
    Object? nameError = freezed,
    Object? phoneError = freezed,
    Object? isSaving = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      nameError: freezed == nameError
          ? _self.nameError
          : nameError // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneError: freezed == phoneError
          ? _self.phoneError
          : phoneError // ignore: cast_nullable_to_non_nullable
              as String?,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [AddCustomerState].
extension AddCustomerStatePatterns on AddCustomerState {
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
    TResult Function(_AddCustomerState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddCustomerState() when $default != null:
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
    TResult Function(_AddCustomerState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddCustomerState():
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
    TResult? Function(_AddCustomerState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddCustomerState() when $default != null:
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
    TResult Function(String name, String phone, String? nameError,
            String? phoneError, bool isSaving)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddCustomerState() when $default != null:
        return $default(_that.name, _that.phone, _that.nameError,
            _that.phoneError, _that.isSaving);
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
    TResult Function(String name, String phone, String? nameError,
            String? phoneError, bool isSaving)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddCustomerState():
        return $default(_that.name, _that.phone, _that.nameError,
            _that.phoneError, _that.isSaving);
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
    TResult? Function(String name, String phone, String? nameError,
            String? phoneError, bool isSaving)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddCustomerState() when $default != null:
        return $default(_that.name, _that.phone, _that.nameError,
            _that.phoneError, _that.isSaving);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AddCustomerState implements AddCustomerState {
  const _AddCustomerState(
      {required this.name,
      required this.phone,
      this.nameError,
      this.phoneError,
      required this.isSaving});

  @override
  final String name;
  @override
  final String phone;
  @override
  final String? nameError;
  @override
  final String? phoneError;
  @override
  final bool isSaving;

  /// Create a copy of AddCustomerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddCustomerStateCopyWith<_AddCustomerState> get copyWith =>
      __$AddCustomerStateCopyWithImpl<_AddCustomerState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddCustomerState &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.nameError, nameError) ||
                other.nameError == nameError) &&
            (identical(other.phoneError, phoneError) ||
                other.phoneError == phoneError) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, name, phone, nameError, phoneError, isSaving);

  @override
  String toString() {
    return 'AddCustomerState(name: $name, phone: $phone, nameError: $nameError, phoneError: $phoneError, isSaving: $isSaving)';
  }
}

/// @nodoc
abstract mixin class _$AddCustomerStateCopyWith<$Res>
    implements $AddCustomerStateCopyWith<$Res> {
  factory _$AddCustomerStateCopyWith(
          _AddCustomerState value, $Res Function(_AddCustomerState) _then) =
      __$AddCustomerStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      String phone,
      String? nameError,
      String? phoneError,
      bool isSaving});
}

/// @nodoc
class __$AddCustomerStateCopyWithImpl<$Res>
    implements _$AddCustomerStateCopyWith<$Res> {
  __$AddCustomerStateCopyWithImpl(this._self, this._then);

  final _AddCustomerState _self;
  final $Res Function(_AddCustomerState) _then;

  /// Create a copy of AddCustomerState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? phone = null,
    Object? nameError = freezed,
    Object? phoneError = freezed,
    Object? isSaving = null,
  }) {
    return _then(_AddCustomerState(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      nameError: freezed == nameError
          ? _self.nameError
          : nameError // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneError: freezed == phoneError
          ? _self.phoneError
          : phoneError // ignore: cast_nullable_to_non_nullable
              as String?,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$AddEntryFormState {
  String get amountString;
  String get note;
  String? get amountError;
  bool get isSaving;
  String? get saveError;

  /// Create a copy of AddEntryFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddEntryFormStateCopyWith<AddEntryFormState> get copyWith =>
      _$AddEntryFormStateCopyWithImpl<AddEntryFormState>(
          this as AddEntryFormState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddEntryFormState &&
            (identical(other.amountString, amountString) ||
                other.amountString == amountString) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.amountError, amountError) ||
                other.amountError == amountError) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, amountString, note, amountError, isSaving, saveError);

  @override
  String toString() {
    return 'AddEntryFormState(amountString: $amountString, note: $note, amountError: $amountError, isSaving: $isSaving, saveError: $saveError)';
  }
}

/// @nodoc
abstract mixin class $AddEntryFormStateCopyWith<$Res> {
  factory $AddEntryFormStateCopyWith(
          AddEntryFormState value, $Res Function(AddEntryFormState) _then) =
      _$AddEntryFormStateCopyWithImpl;
  @useResult
  $Res call(
      {String amountString,
      String note,
      String? amountError,
      bool isSaving,
      String? saveError});
}

/// @nodoc
class _$AddEntryFormStateCopyWithImpl<$Res>
    implements $AddEntryFormStateCopyWith<$Res> {
  _$AddEntryFormStateCopyWithImpl(this._self, this._then);

  final AddEntryFormState _self;
  final $Res Function(AddEntryFormState) _then;

  /// Create a copy of AddEntryFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amountString = null,
    Object? note = null,
    Object? amountError = freezed,
    Object? isSaving = null,
    Object? saveError = freezed,
  }) {
    return _then(_self.copyWith(
      amountString: null == amountString
          ? _self.amountString
          : amountString // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      amountError: freezed == amountError
          ? _self.amountError
          : amountError // ignore: cast_nullable_to_non_nullable
              as String?,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      saveError: freezed == saveError
          ? _self.saveError
          : saveError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AddEntryFormState].
extension AddEntryFormStatePatterns on AddEntryFormState {
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
    TResult Function(_AddEntryFormState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddEntryFormState() when $default != null:
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
    TResult Function(_AddEntryFormState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddEntryFormState():
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
    TResult? Function(_AddEntryFormState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddEntryFormState() when $default != null:
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
    TResult Function(String amountString, String note, String? amountError,
            bool isSaving, String? saveError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddEntryFormState() when $default != null:
        return $default(_that.amountString, _that.note, _that.amountError,
            _that.isSaving, _that.saveError);
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
    TResult Function(String amountString, String note, String? amountError,
            bool isSaving, String? saveError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddEntryFormState():
        return $default(_that.amountString, _that.note, _that.amountError,
            _that.isSaving, _that.saveError);
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
    TResult? Function(String amountString, String note, String? amountError,
            bool isSaving, String? saveError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddEntryFormState() when $default != null:
        return $default(_that.amountString, _that.note, _that.amountError,
            _that.isSaving, _that.saveError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AddEntryFormState implements AddEntryFormState {
  const _AddEntryFormState(
      {required this.amountString,
      required this.note,
      this.amountError,
      required this.isSaving,
      this.saveError});

  @override
  final String amountString;
  @override
  final String note;
  @override
  final String? amountError;
  @override
  final bool isSaving;
  @override
  final String? saveError;

  /// Create a copy of AddEntryFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddEntryFormStateCopyWith<_AddEntryFormState> get copyWith =>
      __$AddEntryFormStateCopyWithImpl<_AddEntryFormState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddEntryFormState &&
            (identical(other.amountString, amountString) ||
                other.amountString == amountString) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.amountError, amountError) ||
                other.amountError == amountError) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, amountString, note, amountError, isSaving, saveError);

  @override
  String toString() {
    return 'AddEntryFormState(amountString: $amountString, note: $note, amountError: $amountError, isSaving: $isSaving, saveError: $saveError)';
  }
}

/// @nodoc
abstract mixin class _$AddEntryFormStateCopyWith<$Res>
    implements $AddEntryFormStateCopyWith<$Res> {
  factory _$AddEntryFormStateCopyWith(
          _AddEntryFormState value, $Res Function(_AddEntryFormState) _then) =
      __$AddEntryFormStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String amountString,
      String note,
      String? amountError,
      bool isSaving,
      String? saveError});
}

/// @nodoc
class __$AddEntryFormStateCopyWithImpl<$Res>
    implements _$AddEntryFormStateCopyWith<$Res> {
  __$AddEntryFormStateCopyWithImpl(this._self, this._then);

  final _AddEntryFormState _self;
  final $Res Function(_AddEntryFormState) _then;

  /// Create a copy of AddEntryFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? amountString = null,
    Object? note = null,
    Object? amountError = freezed,
    Object? isSaving = null,
    Object? saveError = freezed,
  }) {
    return _then(_AddEntryFormState(
      amountString: null == amountString
          ? _self.amountString
          : amountString // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      amountError: freezed == amountError
          ? _self.amountError
          : amountError // ignore: cast_nullable_to_non_nullable
              as String?,
      isSaving: null == isSaving
          ? _self.isSaving
          : isSaving // ignore: cast_nullable_to_non_nullable
              as bool,
      saveError: freezed == saveError
          ? _self.saveError
          : saveError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
