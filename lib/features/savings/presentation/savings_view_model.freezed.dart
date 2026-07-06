// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateSavingsGoalState {
  String get name;
  SavingsCategory get category;
  String get targetAmountString;
  DateTime? get targetDate;
  String get notes;
  String? get nameError;
  String? get targetAmountError;
  String? get targetDateError;
  bool get isSaving;
  String? get saveError;

  /// Create a copy of CreateSavingsGoalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateSavingsGoalStateCopyWith<CreateSavingsGoalState> get copyWith =>
      _$CreateSavingsGoalStateCopyWithImpl<CreateSavingsGoalState>(
          this as CreateSavingsGoalState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateSavingsGoalState &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.targetAmountString, targetAmountString) ||
                other.targetAmountString == targetAmountString) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.nameError, nameError) ||
                other.nameError == nameError) &&
            (identical(other.targetAmountError, targetAmountError) ||
                other.targetAmountError == targetAmountError) &&
            (identical(other.targetDateError, targetDateError) ||
                other.targetDateError == targetDateError) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      category,
      targetAmountString,
      targetDate,
      notes,
      nameError,
      targetAmountError,
      targetDateError,
      isSaving,
      saveError);

  @override
  String toString() {
    return 'CreateSavingsGoalState(name: $name, category: $category, targetAmountString: $targetAmountString, targetDate: $targetDate, notes: $notes, nameError: $nameError, targetAmountError: $targetAmountError, targetDateError: $targetDateError, isSaving: $isSaving, saveError: $saveError)';
  }
}

/// @nodoc
abstract mixin class $CreateSavingsGoalStateCopyWith<$Res> {
  factory $CreateSavingsGoalStateCopyWith(CreateSavingsGoalState value,
          $Res Function(CreateSavingsGoalState) _then) =
      _$CreateSavingsGoalStateCopyWithImpl;
  @useResult
  $Res call(
      {String name,
      SavingsCategory category,
      String targetAmountString,
      DateTime? targetDate,
      String notes,
      String? nameError,
      String? targetAmountError,
      String? targetDateError,
      bool isSaving,
      String? saveError});
}

/// @nodoc
class _$CreateSavingsGoalStateCopyWithImpl<$Res>
    implements $CreateSavingsGoalStateCopyWith<$Res> {
  _$CreateSavingsGoalStateCopyWithImpl(this._self, this._then);

  final CreateSavingsGoalState _self;
  final $Res Function(CreateSavingsGoalState) _then;

  /// Create a copy of CreateSavingsGoalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? category = null,
    Object? targetAmountString = null,
    Object? targetDate = freezed,
    Object? notes = null,
    Object? nameError = freezed,
    Object? targetAmountError = freezed,
    Object? targetDateError = freezed,
    Object? isSaving = null,
    Object? saveError = freezed,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as SavingsCategory,
      targetAmountString: null == targetAmountString
          ? _self.targetAmountString
          : targetAmountString // ignore: cast_nullable_to_non_nullable
              as String,
      targetDate: freezed == targetDate
          ? _self.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      nameError: freezed == nameError
          ? _self.nameError
          : nameError // ignore: cast_nullable_to_non_nullable
              as String?,
      targetAmountError: freezed == targetAmountError
          ? _self.targetAmountError
          : targetAmountError // ignore: cast_nullable_to_non_nullable
              as String?,
      targetDateError: freezed == targetDateError
          ? _self.targetDateError
          : targetDateError // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [CreateSavingsGoalState].
extension CreateSavingsGoalStatePatterns on CreateSavingsGoalState {
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
    TResult Function(_CreateSavingsGoalState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateSavingsGoalState() when $default != null:
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
    TResult Function(_CreateSavingsGoalState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateSavingsGoalState():
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
    TResult? Function(_CreateSavingsGoalState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateSavingsGoalState() when $default != null:
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
            String name,
            SavingsCategory category,
            String targetAmountString,
            DateTime? targetDate,
            String notes,
            String? nameError,
            String? targetAmountError,
            String? targetDateError,
            bool isSaving,
            String? saveError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateSavingsGoalState() when $default != null:
        return $default(
            _that.name,
            _that.category,
            _that.targetAmountString,
            _that.targetDate,
            _that.notes,
            _that.nameError,
            _that.targetAmountError,
            _that.targetDateError,
            _that.isSaving,
            _that.saveError);
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
            String name,
            SavingsCategory category,
            String targetAmountString,
            DateTime? targetDate,
            String notes,
            String? nameError,
            String? targetAmountError,
            String? targetDateError,
            bool isSaving,
            String? saveError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateSavingsGoalState():
        return $default(
            _that.name,
            _that.category,
            _that.targetAmountString,
            _that.targetDate,
            _that.notes,
            _that.nameError,
            _that.targetAmountError,
            _that.targetDateError,
            _that.isSaving,
            _that.saveError);
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
            String name,
            SavingsCategory category,
            String targetAmountString,
            DateTime? targetDate,
            String notes,
            String? nameError,
            String? targetAmountError,
            String? targetDateError,
            bool isSaving,
            String? saveError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateSavingsGoalState() when $default != null:
        return $default(
            _that.name,
            _that.category,
            _that.targetAmountString,
            _that.targetDate,
            _that.notes,
            _that.nameError,
            _that.targetAmountError,
            _that.targetDateError,
            _that.isSaving,
            _that.saveError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _CreateSavingsGoalState implements CreateSavingsGoalState {
  const _CreateSavingsGoalState(
      {this.name = '',
      this.category = SavingsCategory.OTHER,
      this.targetAmountString = '0',
      this.targetDate,
      this.notes = '',
      this.nameError,
      this.targetAmountError,
      this.targetDateError,
      this.isSaving = false,
      this.saveError});

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final SavingsCategory category;
  @override
  @JsonKey()
  final String targetAmountString;
  @override
  final DateTime? targetDate;
  @override
  @JsonKey()
  final String notes;
  @override
  final String? nameError;
  @override
  final String? targetAmountError;
  @override
  final String? targetDateError;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  final String? saveError;

  /// Create a copy of CreateSavingsGoalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateSavingsGoalStateCopyWith<_CreateSavingsGoalState> get copyWith =>
      __$CreateSavingsGoalStateCopyWithImpl<_CreateSavingsGoalState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateSavingsGoalState &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.targetAmountString, targetAmountString) ||
                other.targetAmountString == targetAmountString) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.nameError, nameError) ||
                other.nameError == nameError) &&
            (identical(other.targetAmountError, targetAmountError) ||
                other.targetAmountError == targetAmountError) &&
            (identical(other.targetDateError, targetDateError) ||
                other.targetDateError == targetDateError) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      category,
      targetAmountString,
      targetDate,
      notes,
      nameError,
      targetAmountError,
      targetDateError,
      isSaving,
      saveError);

  @override
  String toString() {
    return 'CreateSavingsGoalState(name: $name, category: $category, targetAmountString: $targetAmountString, targetDate: $targetDate, notes: $notes, nameError: $nameError, targetAmountError: $targetAmountError, targetDateError: $targetDateError, isSaving: $isSaving, saveError: $saveError)';
  }
}

/// @nodoc
abstract mixin class _$CreateSavingsGoalStateCopyWith<$Res>
    implements $CreateSavingsGoalStateCopyWith<$Res> {
  factory _$CreateSavingsGoalStateCopyWith(_CreateSavingsGoalState value,
          $Res Function(_CreateSavingsGoalState) _then) =
      __$CreateSavingsGoalStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String name,
      SavingsCategory category,
      String targetAmountString,
      DateTime? targetDate,
      String notes,
      String? nameError,
      String? targetAmountError,
      String? targetDateError,
      bool isSaving,
      String? saveError});
}

/// @nodoc
class __$CreateSavingsGoalStateCopyWithImpl<$Res>
    implements _$CreateSavingsGoalStateCopyWith<$Res> {
  __$CreateSavingsGoalStateCopyWithImpl(this._self, this._then);

  final _CreateSavingsGoalState _self;
  final $Res Function(_CreateSavingsGoalState) _then;

  /// Create a copy of CreateSavingsGoalState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? category = null,
    Object? targetAmountString = null,
    Object? targetDate = freezed,
    Object? notes = null,
    Object? nameError = freezed,
    Object? targetAmountError = freezed,
    Object? targetDateError = freezed,
    Object? isSaving = null,
    Object? saveError = freezed,
  }) {
    return _then(_CreateSavingsGoalState(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as SavingsCategory,
      targetAmountString: null == targetAmountString
          ? _self.targetAmountString
          : targetAmountString // ignore: cast_nullable_to_non_nullable
              as String,
      targetDate: freezed == targetDate
          ? _self.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      nameError: freezed == nameError
          ? _self.nameError
          : nameError // ignore: cast_nullable_to_non_nullable
              as String?,
      targetAmountError: freezed == targetAmountError
          ? _self.targetAmountError
          : targetAmountError // ignore: cast_nullable_to_non_nullable
              as String?,
      targetDateError: freezed == targetDateError
          ? _self.targetDateError
          : targetDateError // ignore: cast_nullable_to_non_nullable
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

/// @nodoc
mixin _$AddSavingsEntryFormState {
  String get amountString;
  String get note;
  DateTime? get entryDate;
  String? get amountError;
  bool get isSaving;
  String? get saveError;

  /// Create a copy of AddSavingsEntryFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddSavingsEntryFormStateCopyWith<AddSavingsEntryFormState> get copyWith =>
      _$AddSavingsEntryFormStateCopyWithImpl<AddSavingsEntryFormState>(
          this as AddSavingsEntryFormState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddSavingsEntryFormState &&
            (identical(other.amountString, amountString) ||
                other.amountString == amountString) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.amountError, amountError) ||
                other.amountError == amountError) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amountString, note, entryDate,
      amountError, isSaving, saveError);

  @override
  String toString() {
    return 'AddSavingsEntryFormState(amountString: $amountString, note: $note, entryDate: $entryDate, amountError: $amountError, isSaving: $isSaving, saveError: $saveError)';
  }
}

/// @nodoc
abstract mixin class $AddSavingsEntryFormStateCopyWith<$Res> {
  factory $AddSavingsEntryFormStateCopyWith(AddSavingsEntryFormState value,
          $Res Function(AddSavingsEntryFormState) _then) =
      _$AddSavingsEntryFormStateCopyWithImpl;
  @useResult
  $Res call(
      {String amountString,
      String note,
      DateTime? entryDate,
      String? amountError,
      bool isSaving,
      String? saveError});
}

/// @nodoc
class _$AddSavingsEntryFormStateCopyWithImpl<$Res>
    implements $AddSavingsEntryFormStateCopyWith<$Res> {
  _$AddSavingsEntryFormStateCopyWithImpl(this._self, this._then);

  final AddSavingsEntryFormState _self;
  final $Res Function(AddSavingsEntryFormState) _then;

  /// Create a copy of AddSavingsEntryFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amountString = null,
    Object? note = null,
    Object? entryDate = freezed,
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
      entryDate: freezed == entryDate
          ? _self.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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

/// Adds pattern-matching-related methods to [AddSavingsEntryFormState].
extension AddSavingsEntryFormStatePatterns on AddSavingsEntryFormState {
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
    TResult Function(_AddSavingsEntryFormState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddSavingsEntryFormState() when $default != null:
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
    TResult Function(_AddSavingsEntryFormState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddSavingsEntryFormState():
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
    TResult? Function(_AddSavingsEntryFormState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddSavingsEntryFormState() when $default != null:
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
    TResult Function(String amountString, String note, DateTime? entryDate,
            String? amountError, bool isSaving, String? saveError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddSavingsEntryFormState() when $default != null:
        return $default(_that.amountString, _that.note, _that.entryDate,
            _that.amountError, _that.isSaving, _that.saveError);
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
    TResult Function(String amountString, String note, DateTime? entryDate,
            String? amountError, bool isSaving, String? saveError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddSavingsEntryFormState():
        return $default(_that.amountString, _that.note, _that.entryDate,
            _that.amountError, _that.isSaving, _that.saveError);
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
    TResult? Function(String amountString, String note, DateTime? entryDate,
            String? amountError, bool isSaving, String? saveError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddSavingsEntryFormState() when $default != null:
        return $default(_that.amountString, _that.note, _that.entryDate,
            _that.amountError, _that.isSaving, _that.saveError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AddSavingsEntryFormState implements AddSavingsEntryFormState {
  const _AddSavingsEntryFormState(
      {this.amountString = '0',
      this.note = '',
      this.entryDate,
      this.amountError,
      this.isSaving = false,
      this.saveError});

  @override
  @JsonKey()
  final String amountString;
  @override
  @JsonKey()
  final String note;
  @override
  final DateTime? entryDate;
  @override
  final String? amountError;
  @override
  @JsonKey()
  final bool isSaving;
  @override
  final String? saveError;

  /// Create a copy of AddSavingsEntryFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddSavingsEntryFormStateCopyWith<_AddSavingsEntryFormState> get copyWith =>
      __$AddSavingsEntryFormStateCopyWithImpl<_AddSavingsEntryFormState>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddSavingsEntryFormState &&
            (identical(other.amountString, amountString) ||
                other.amountString == amountString) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.entryDate, entryDate) ||
                other.entryDate == entryDate) &&
            (identical(other.amountError, amountError) ||
                other.amountError == amountError) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, amountString, note, entryDate,
      amountError, isSaving, saveError);

  @override
  String toString() {
    return 'AddSavingsEntryFormState(amountString: $amountString, note: $note, entryDate: $entryDate, amountError: $amountError, isSaving: $isSaving, saveError: $saveError)';
  }
}

/// @nodoc
abstract mixin class _$AddSavingsEntryFormStateCopyWith<$Res>
    implements $AddSavingsEntryFormStateCopyWith<$Res> {
  factory _$AddSavingsEntryFormStateCopyWith(_AddSavingsEntryFormState value,
          $Res Function(_AddSavingsEntryFormState) _then) =
      __$AddSavingsEntryFormStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String amountString,
      String note,
      DateTime? entryDate,
      String? amountError,
      bool isSaving,
      String? saveError});
}

/// @nodoc
class __$AddSavingsEntryFormStateCopyWithImpl<$Res>
    implements _$AddSavingsEntryFormStateCopyWith<$Res> {
  __$AddSavingsEntryFormStateCopyWithImpl(this._self, this._then);

  final _AddSavingsEntryFormState _self;
  final $Res Function(_AddSavingsEntryFormState) _then;

  /// Create a copy of AddSavingsEntryFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? amountString = null,
    Object? note = null,
    Object? entryDate = freezed,
    Object? amountError = freezed,
    Object? isSaving = null,
    Object? saveError = freezed,
  }) {
    return _then(_AddSavingsEntryFormState(
      amountString: null == amountString
          ? _self.amountString
          : amountString // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      entryDate: freezed == entryDate
          ? _self.entryDate
          : entryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
