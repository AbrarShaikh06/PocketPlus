// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvoiceFormState {
  String get customerName;
  String? get customerNameError;
  String get customerPhone;
  String? get customerPhoneError;
  DateTime get issueDate;
  DateTime? get dueDate;
  List<InvoiceLineItemForm> get lineItems;
  int get discount;
  String get notes;
  String? get notesError;
  bool get isSaving;
  String? get saveError;

  /// Create a copy of InvoiceFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InvoiceFormStateCopyWith<InvoiceFormState> get copyWith =>
      _$InvoiceFormStateCopyWithImpl<InvoiceFormState>(
          this as InvoiceFormState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InvoiceFormState &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerNameError, customerNameError) ||
                other.customerNameError == customerNameError) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerPhoneError, customerPhoneError) ||
                other.customerPhoneError == customerPhoneError) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            const DeepCollectionEquality().equals(other.lineItems, lineItems) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.notesError, notesError) ||
                other.notesError == notesError) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      customerName,
      customerNameError,
      customerPhone,
      customerPhoneError,
      issueDate,
      dueDate,
      const DeepCollectionEquality().hash(lineItems),
      discount,
      notes,
      notesError,
      isSaving,
      saveError);

  @override
  String toString() {
    return 'InvoiceFormState(customerName: $customerName, customerNameError: $customerNameError, customerPhone: $customerPhone, customerPhoneError: $customerPhoneError, issueDate: $issueDate, dueDate: $dueDate, lineItems: $lineItems, discount: $discount, notes: $notes, notesError: $notesError, isSaving: $isSaving, saveError: $saveError)';
  }
}

/// @nodoc
abstract mixin class $InvoiceFormStateCopyWith<$Res> {
  factory $InvoiceFormStateCopyWith(
          InvoiceFormState value, $Res Function(InvoiceFormState) _then) =
      _$InvoiceFormStateCopyWithImpl;
  @useResult
  $Res call(
      {String customerName,
      String? customerNameError,
      String customerPhone,
      String? customerPhoneError,
      DateTime issueDate,
      DateTime? dueDate,
      List<InvoiceLineItemForm> lineItems,
      int discount,
      String notes,
      String? notesError,
      bool isSaving,
      String? saveError});
}

/// @nodoc
class _$InvoiceFormStateCopyWithImpl<$Res>
    implements $InvoiceFormStateCopyWith<$Res> {
  _$InvoiceFormStateCopyWithImpl(this._self, this._then);

  final InvoiceFormState _self;
  final $Res Function(InvoiceFormState) _then;

  /// Create a copy of InvoiceFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customerName = null,
    Object? customerNameError = freezed,
    Object? customerPhone = null,
    Object? customerPhoneError = freezed,
    Object? issueDate = null,
    Object? dueDate = freezed,
    Object? lineItems = null,
    Object? discount = null,
    Object? notes = null,
    Object? notesError = freezed,
    Object? isSaving = null,
    Object? saveError = freezed,
  }) {
    return _then(_self.copyWith(
      customerName: null == customerName
          ? _self.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerNameError: freezed == customerNameError
          ? _self.customerNameError
          : customerNameError // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: null == customerPhone
          ? _self.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhoneError: freezed == customerPhoneError
          ? _self.customerPhoneError
          : customerPhoneError // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: null == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dueDate: freezed == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lineItems: null == lineItems
          ? _self.lineItems
          : lineItems // ignore: cast_nullable_to_non_nullable
              as List<InvoiceLineItemForm>,
      discount: null == discount
          ? _self.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      notesError: freezed == notesError
          ? _self.notesError
          : notesError // ignore: cast_nullable_to_non_nullable
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

/// Adds pattern-matching-related methods to [InvoiceFormState].
extension InvoiceFormStatePatterns on InvoiceFormState {
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
    TResult Function(_InvoiceFormState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InvoiceFormState() when $default != null:
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
    TResult Function(_InvoiceFormState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceFormState():
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
    TResult? Function(_InvoiceFormState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceFormState() when $default != null:
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
            String customerName,
            String? customerNameError,
            String customerPhone,
            String? customerPhoneError,
            DateTime issueDate,
            DateTime? dueDate,
            List<InvoiceLineItemForm> lineItems,
            int discount,
            String notes,
            String? notesError,
            bool isSaving,
            String? saveError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InvoiceFormState() when $default != null:
        return $default(
            _that.customerName,
            _that.customerNameError,
            _that.customerPhone,
            _that.customerPhoneError,
            _that.issueDate,
            _that.dueDate,
            _that.lineItems,
            _that.discount,
            _that.notes,
            _that.notesError,
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
            String customerName,
            String? customerNameError,
            String customerPhone,
            String? customerPhoneError,
            DateTime issueDate,
            DateTime? dueDate,
            List<InvoiceLineItemForm> lineItems,
            int discount,
            String notes,
            String? notesError,
            bool isSaving,
            String? saveError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceFormState():
        return $default(
            _that.customerName,
            _that.customerNameError,
            _that.customerPhone,
            _that.customerPhoneError,
            _that.issueDate,
            _that.dueDate,
            _that.lineItems,
            _that.discount,
            _that.notes,
            _that.notesError,
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
            String customerName,
            String? customerNameError,
            String customerPhone,
            String? customerPhoneError,
            DateTime issueDate,
            DateTime? dueDate,
            List<InvoiceLineItemForm> lineItems,
            int discount,
            String notes,
            String? notesError,
            bool isSaving,
            String? saveError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceFormState() when $default != null:
        return $default(
            _that.customerName,
            _that.customerNameError,
            _that.customerPhone,
            _that.customerPhoneError,
            _that.issueDate,
            _that.dueDate,
            _that.lineItems,
            _that.discount,
            _that.notes,
            _that.notesError,
            _that.isSaving,
            _that.saveError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _InvoiceFormState implements InvoiceFormState {
  const _InvoiceFormState(
      {required this.customerName,
      this.customerNameError,
      required this.customerPhone,
      this.customerPhoneError,
      required this.issueDate,
      this.dueDate,
      required final List<InvoiceLineItemForm> lineItems,
      required this.discount,
      required this.notes,
      this.notesError,
      required this.isSaving,
      this.saveError})
      : _lineItems = lineItems;

  @override
  final String customerName;
  @override
  final String? customerNameError;
  @override
  final String customerPhone;
  @override
  final String? customerPhoneError;
  @override
  final DateTime issueDate;
  @override
  final DateTime? dueDate;
  final List<InvoiceLineItemForm> _lineItems;
  @override
  List<InvoiceLineItemForm> get lineItems {
    if (_lineItems is EqualUnmodifiableListView) return _lineItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lineItems);
  }

  @override
  final int discount;
  @override
  final String notes;
  @override
  final String? notesError;
  @override
  final bool isSaving;
  @override
  final String? saveError;

  /// Create a copy of InvoiceFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InvoiceFormStateCopyWith<_InvoiceFormState> get copyWith =>
      __$InvoiceFormStateCopyWithImpl<_InvoiceFormState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InvoiceFormState &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.customerNameError, customerNameError) ||
                other.customerNameError == customerNameError) &&
            (identical(other.customerPhone, customerPhone) ||
                other.customerPhone == customerPhone) &&
            (identical(other.customerPhoneError, customerPhoneError) ||
                other.customerPhoneError == customerPhoneError) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            const DeepCollectionEquality()
                .equals(other._lineItems, _lineItems) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.notesError, notesError) ||
                other.notesError == notesError) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      customerName,
      customerNameError,
      customerPhone,
      customerPhoneError,
      issueDate,
      dueDate,
      const DeepCollectionEquality().hash(_lineItems),
      discount,
      notes,
      notesError,
      isSaving,
      saveError);

  @override
  String toString() {
    return 'InvoiceFormState(customerName: $customerName, customerNameError: $customerNameError, customerPhone: $customerPhone, customerPhoneError: $customerPhoneError, issueDate: $issueDate, dueDate: $dueDate, lineItems: $lineItems, discount: $discount, notes: $notes, notesError: $notesError, isSaving: $isSaving, saveError: $saveError)';
  }
}

/// @nodoc
abstract mixin class _$InvoiceFormStateCopyWith<$Res>
    implements $InvoiceFormStateCopyWith<$Res> {
  factory _$InvoiceFormStateCopyWith(
          _InvoiceFormState value, $Res Function(_InvoiceFormState) _then) =
      __$InvoiceFormStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String customerName,
      String? customerNameError,
      String customerPhone,
      String? customerPhoneError,
      DateTime issueDate,
      DateTime? dueDate,
      List<InvoiceLineItemForm> lineItems,
      int discount,
      String notes,
      String? notesError,
      bool isSaving,
      String? saveError});
}

/// @nodoc
class __$InvoiceFormStateCopyWithImpl<$Res>
    implements _$InvoiceFormStateCopyWith<$Res> {
  __$InvoiceFormStateCopyWithImpl(this._self, this._then);

  final _InvoiceFormState _self;
  final $Res Function(_InvoiceFormState) _then;

  /// Create a copy of InvoiceFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? customerName = null,
    Object? customerNameError = freezed,
    Object? customerPhone = null,
    Object? customerPhoneError = freezed,
    Object? issueDate = null,
    Object? dueDate = freezed,
    Object? lineItems = null,
    Object? discount = null,
    Object? notes = null,
    Object? notesError = freezed,
    Object? isSaving = null,
    Object? saveError = freezed,
  }) {
    return _then(_InvoiceFormState(
      customerName: null == customerName
          ? _self.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      customerNameError: freezed == customerNameError
          ? _self.customerNameError
          : customerNameError // ignore: cast_nullable_to_non_nullable
              as String?,
      customerPhone: null == customerPhone
          ? _self.customerPhone
          : customerPhone // ignore: cast_nullable_to_non_nullable
              as String,
      customerPhoneError: freezed == customerPhoneError
          ? _self.customerPhoneError
          : customerPhoneError // ignore: cast_nullable_to_non_nullable
              as String?,
      issueDate: null == issueDate
          ? _self.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dueDate: freezed == dueDate
          ? _self.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lineItems: null == lineItems
          ? _self._lineItems
          : lineItems // ignore: cast_nullable_to_non_nullable
              as List<InvoiceLineItemForm>,
      discount: null == discount
          ? _self.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as int,
      notes: null == notes
          ? _self.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      notesError: freezed == notesError
          ? _self.notesError
          : notesError // ignore: cast_nullable_to_non_nullable
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
mixin _$InvoiceLineItemForm {
  String get description;
  String? get descriptionError;
  String get quantityString;
  String get unitPriceString;
  double get gstPercent;
  int get lineTotal;
  int get gstAmount;

  /// Create a copy of InvoiceLineItemForm
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InvoiceLineItemFormCopyWith<InvoiceLineItemForm> get copyWith =>
      _$InvoiceLineItemFormCopyWithImpl<InvoiceLineItemForm>(
          this as InvoiceLineItemForm, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InvoiceLineItemForm &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.descriptionError, descriptionError) ||
                other.descriptionError == descriptionError) &&
            (identical(other.quantityString, quantityString) ||
                other.quantityString == quantityString) &&
            (identical(other.unitPriceString, unitPriceString) ||
                other.unitPriceString == unitPriceString) &&
            (identical(other.gstPercent, gstPercent) ||
                other.gstPercent == gstPercent) &&
            (identical(other.lineTotal, lineTotal) ||
                other.lineTotal == lineTotal) &&
            (identical(other.gstAmount, gstAmount) ||
                other.gstAmount == gstAmount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, descriptionError,
      quantityString, unitPriceString, gstPercent, lineTotal, gstAmount);

  @override
  String toString() {
    return 'InvoiceLineItemForm(description: $description, descriptionError: $descriptionError, quantityString: $quantityString, unitPriceString: $unitPriceString, gstPercent: $gstPercent, lineTotal: $lineTotal, gstAmount: $gstAmount)';
  }
}

/// @nodoc
abstract mixin class $InvoiceLineItemFormCopyWith<$Res> {
  factory $InvoiceLineItemFormCopyWith(
          InvoiceLineItemForm value, $Res Function(InvoiceLineItemForm) _then) =
      _$InvoiceLineItemFormCopyWithImpl;
  @useResult
  $Res call(
      {String description,
      String? descriptionError,
      String quantityString,
      String unitPriceString,
      double gstPercent,
      int lineTotal,
      int gstAmount});
}

/// @nodoc
class _$InvoiceLineItemFormCopyWithImpl<$Res>
    implements $InvoiceLineItemFormCopyWith<$Res> {
  _$InvoiceLineItemFormCopyWithImpl(this._self, this._then);

  final InvoiceLineItemForm _self;
  final $Res Function(InvoiceLineItemForm) _then;

  /// Create a copy of InvoiceLineItemForm
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? descriptionError = freezed,
    Object? quantityString = null,
    Object? unitPriceString = null,
    Object? gstPercent = null,
    Object? lineTotal = null,
    Object? gstAmount = null,
  }) {
    return _then(_self.copyWith(
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionError: freezed == descriptionError
          ? _self.descriptionError
          : descriptionError // ignore: cast_nullable_to_non_nullable
              as String?,
      quantityString: null == quantityString
          ? _self.quantityString
          : quantityString // ignore: cast_nullable_to_non_nullable
              as String,
      unitPriceString: null == unitPriceString
          ? _self.unitPriceString
          : unitPriceString // ignore: cast_nullable_to_non_nullable
              as String,
      gstPercent: null == gstPercent
          ? _self.gstPercent
          : gstPercent // ignore: cast_nullable_to_non_nullable
              as double,
      lineTotal: null == lineTotal
          ? _self.lineTotal
          : lineTotal // ignore: cast_nullable_to_non_nullable
              as int,
      gstAmount: null == gstAmount
          ? _self.gstAmount
          : gstAmount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [InvoiceLineItemForm].
extension InvoiceLineItemFormPatterns on InvoiceLineItemForm {
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
    TResult Function(_InvoiceLineItemForm value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InvoiceLineItemForm() when $default != null:
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
    TResult Function(_InvoiceLineItemForm value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceLineItemForm():
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
    TResult? Function(_InvoiceLineItemForm value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceLineItemForm() when $default != null:
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
            String description,
            String? descriptionError,
            String quantityString,
            String unitPriceString,
            double gstPercent,
            int lineTotal,
            int gstAmount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InvoiceLineItemForm() when $default != null:
        return $default(
            _that.description,
            _that.descriptionError,
            _that.quantityString,
            _that.unitPriceString,
            _that.gstPercent,
            _that.lineTotal,
            _that.gstAmount);
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
            String description,
            String? descriptionError,
            String quantityString,
            String unitPriceString,
            double gstPercent,
            int lineTotal,
            int gstAmount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceLineItemForm():
        return $default(
            _that.description,
            _that.descriptionError,
            _that.quantityString,
            _that.unitPriceString,
            _that.gstPercent,
            _that.lineTotal,
            _that.gstAmount);
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
            String description,
            String? descriptionError,
            String quantityString,
            String unitPriceString,
            double gstPercent,
            int lineTotal,
            int gstAmount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceLineItemForm() when $default != null:
        return $default(
            _that.description,
            _that.descriptionError,
            _that.quantityString,
            _that.unitPriceString,
            _that.gstPercent,
            _that.lineTotal,
            _that.gstAmount);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _InvoiceLineItemForm implements InvoiceLineItemForm {
  const _InvoiceLineItemForm(
      {required this.description,
      this.descriptionError,
      required this.quantityString,
      required this.unitPriceString,
      required this.gstPercent,
      this.lineTotal = 0,
      this.gstAmount = 0});

  @override
  final String description;
  @override
  final String? descriptionError;
  @override
  final String quantityString;
  @override
  final String unitPriceString;
  @override
  final double gstPercent;
  @override
  @JsonKey()
  final int lineTotal;
  @override
  @JsonKey()
  final int gstAmount;

  /// Create a copy of InvoiceLineItemForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InvoiceLineItemFormCopyWith<_InvoiceLineItemForm> get copyWith =>
      __$InvoiceLineItemFormCopyWithImpl<_InvoiceLineItemForm>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InvoiceLineItemForm &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.descriptionError, descriptionError) ||
                other.descriptionError == descriptionError) &&
            (identical(other.quantityString, quantityString) ||
                other.quantityString == quantityString) &&
            (identical(other.unitPriceString, unitPriceString) ||
                other.unitPriceString == unitPriceString) &&
            (identical(other.gstPercent, gstPercent) ||
                other.gstPercent == gstPercent) &&
            (identical(other.lineTotal, lineTotal) ||
                other.lineTotal == lineTotal) &&
            (identical(other.gstAmount, gstAmount) ||
                other.gstAmount == gstAmount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, descriptionError,
      quantityString, unitPriceString, gstPercent, lineTotal, gstAmount);

  @override
  String toString() {
    return 'InvoiceLineItemForm(description: $description, descriptionError: $descriptionError, quantityString: $quantityString, unitPriceString: $unitPriceString, gstPercent: $gstPercent, lineTotal: $lineTotal, gstAmount: $gstAmount)';
  }
}

/// @nodoc
abstract mixin class _$InvoiceLineItemFormCopyWith<$Res>
    implements $InvoiceLineItemFormCopyWith<$Res> {
  factory _$InvoiceLineItemFormCopyWith(_InvoiceLineItemForm value,
          $Res Function(_InvoiceLineItemForm) _then) =
      __$InvoiceLineItemFormCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String description,
      String? descriptionError,
      String quantityString,
      String unitPriceString,
      double gstPercent,
      int lineTotal,
      int gstAmount});
}

/// @nodoc
class __$InvoiceLineItemFormCopyWithImpl<$Res>
    implements _$InvoiceLineItemFormCopyWith<$Res> {
  __$InvoiceLineItemFormCopyWithImpl(this._self, this._then);

  final _InvoiceLineItemForm _self;
  final $Res Function(_InvoiceLineItemForm) _then;

  /// Create a copy of InvoiceLineItemForm
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? description = null,
    Object? descriptionError = freezed,
    Object? quantityString = null,
    Object? unitPriceString = null,
    Object? gstPercent = null,
    Object? lineTotal = null,
    Object? gstAmount = null,
  }) {
    return _then(_InvoiceLineItemForm(
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      descriptionError: freezed == descriptionError
          ? _self.descriptionError
          : descriptionError // ignore: cast_nullable_to_non_nullable
              as String?,
      quantityString: null == quantityString
          ? _self.quantityString
          : quantityString // ignore: cast_nullable_to_non_nullable
              as String,
      unitPriceString: null == unitPriceString
          ? _self.unitPriceString
          : unitPriceString // ignore: cast_nullable_to_non_nullable
              as String,
      gstPercent: null == gstPercent
          ? _self.gstPercent
          : gstPercent // ignore: cast_nullable_to_non_nullable
              as double,
      lineTotal: null == lineTotal
          ? _self.lineTotal
          : lineTotal // ignore: cast_nullable_to_non_nullable
              as int,
      gstAmount: null == gstAmount
          ? _self.gstAmount
          : gstAmount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$InvoiceListState {
  List<Invoice> get invoices;
  bool get isLoading;
  String? get error;

  /// Create a copy of InvoiceListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $InvoiceListStateCopyWith<InvoiceListState> get copyWith =>
      _$InvoiceListStateCopyWithImpl<InvoiceListState>(
          this as InvoiceListState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is InvoiceListState &&
            const DeepCollectionEquality().equals(other.invoices, invoices) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(invoices), isLoading, error);

  @override
  String toString() {
    return 'InvoiceListState(invoices: $invoices, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class $InvoiceListStateCopyWith<$Res> {
  factory $InvoiceListStateCopyWith(
          InvoiceListState value, $Res Function(InvoiceListState) _then) =
      _$InvoiceListStateCopyWithImpl;
  @useResult
  $Res call({List<Invoice> invoices, bool isLoading, String? error});
}

/// @nodoc
class _$InvoiceListStateCopyWithImpl<$Res>
    implements $InvoiceListStateCopyWith<$Res> {
  _$InvoiceListStateCopyWithImpl(this._self, this._then);

  final InvoiceListState _self;
  final $Res Function(InvoiceListState) _then;

  /// Create a copy of InvoiceListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? invoices = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_self.copyWith(
      invoices: null == invoices
          ? _self.invoices
          : invoices // ignore: cast_nullable_to_non_nullable
              as List<Invoice>,
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

/// Adds pattern-matching-related methods to [InvoiceListState].
extension InvoiceListStatePatterns on InvoiceListState {
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
    TResult Function(_InvoiceListState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InvoiceListState() when $default != null:
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
    TResult Function(_InvoiceListState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceListState():
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
    TResult? Function(_InvoiceListState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceListState() when $default != null:
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
    TResult Function(List<Invoice> invoices, bool isLoading, String? error)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _InvoiceListState() when $default != null:
        return $default(_that.invoices, _that.isLoading, _that.error);
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
    TResult Function(List<Invoice> invoices, bool isLoading, String? error)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceListState():
        return $default(_that.invoices, _that.isLoading, _that.error);
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
    TResult? Function(List<Invoice> invoices, bool isLoading, String? error)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _InvoiceListState() when $default != null:
        return $default(_that.invoices, _that.isLoading, _that.error);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _InvoiceListState implements InvoiceListState {
  const _InvoiceListState(
      {required final List<Invoice> invoices,
      required this.isLoading,
      this.error})
      : _invoices = invoices;

  final List<Invoice> _invoices;
  @override
  List<Invoice> get invoices {
    if (_invoices is EqualUnmodifiableListView) return _invoices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_invoices);
  }

  @override
  final bool isLoading;
  @override
  final String? error;

  /// Create a copy of InvoiceListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InvoiceListStateCopyWith<_InvoiceListState> get copyWith =>
      __$InvoiceListStateCopyWithImpl<_InvoiceListState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _InvoiceListState &&
            const DeepCollectionEquality().equals(other._invoices, _invoices) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_invoices), isLoading, error);

  @override
  String toString() {
    return 'InvoiceListState(invoices: $invoices, isLoading: $isLoading, error: $error)';
  }
}

/// @nodoc
abstract mixin class _$InvoiceListStateCopyWith<$Res>
    implements $InvoiceListStateCopyWith<$Res> {
  factory _$InvoiceListStateCopyWith(
          _InvoiceListState value, $Res Function(_InvoiceListState) _then) =
      __$InvoiceListStateCopyWithImpl;
  @override
  @useResult
  $Res call({List<Invoice> invoices, bool isLoading, String? error});
}

/// @nodoc
class __$InvoiceListStateCopyWithImpl<$Res>
    implements _$InvoiceListStateCopyWith<$Res> {
  __$InvoiceListStateCopyWithImpl(this._self, this._then);

  final _InvoiceListState _self;
  final $Res Function(_InvoiceListState) _then;

  /// Create a copy of InvoiceListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? invoices = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_InvoiceListState(
      invoices: null == invoices
          ? _self._invoices
          : invoices // ignore: cast_nullable_to_non_nullable
              as List<Invoice>,
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

// dart format on
