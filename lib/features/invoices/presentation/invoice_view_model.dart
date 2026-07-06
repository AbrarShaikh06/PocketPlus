import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:pocket_plus/core/errors/error_codes.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/entities/invoice.dart';
import '../invoice_providers.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/utils/phone_validator.dart';

part 'invoice_view_model.freezed.dart';

int _computeLineTotal(double quantity, int unitPrice) {
  return (quantity * unitPrice).round();
}

int _computeGstAmount(int lineTotal, double gstPercent) {
  return (lineTotal * gstPercent / 100).round();
}

@freezed
abstract class InvoiceFormState with _$InvoiceFormState {
  const factory InvoiceFormState({
    required String customerName,
    String? customerNameError,
    required String customerPhone,
    String? customerPhoneError,
    required DateTime issueDate,
    DateTime? dueDate,
    required List<InvoiceLineItemForm> lineItems,
    required int discount,
    required String notes,
    String? notesError,
    required bool isSaving,
    String? saveError,
  }) = _InvoiceFormState;
}

@freezed
abstract class InvoiceLineItemForm with _$InvoiceLineItemForm {
  const factory InvoiceLineItemForm({
    required String description,
    String? descriptionError,
    required String quantityString,
    required String unitPriceString,
    required double gstPercent,
    @Default(0) int lineTotal,
    @Default(0) int gstAmount,
  }) = _InvoiceLineItemForm;
}

class InvoiceViewModel extends Notifier<InvoiceFormState> {
  @override
  InvoiceFormState build() {
    return InvoiceFormState(
      customerName: '',
      customerPhone: '',
      issueDate: DateTime.now(),
      lineItems: const [
        InvoiceLineItemForm(
          description: '',
          quantityString: '1',
          unitPriceString: '0',
          gstPercent: 0,
        ),
      ],
      discount: 0,
      notes: '',
      isSaving: false,
    );
  }

  void setCustomerName(String value) {
    state = state.copyWith(customerName: value, customerNameError: null);
  }

  void setCustomerPhone(String value) {
    state = state.copyWith(customerPhone: value, customerPhoneError: null);
  }

  void setIssueDate(DateTime date) {
    state = state.copyWith(issueDate: date);
  }

  void setDueDate(DateTime? date) {
    state = state.copyWith(dueDate: date);
  }

  void setDiscount(int paise) {
    state = state.copyWith(discount: paise);
  }

  void setNotes(String value) {
    if (value.length > 1000) return;
    state = state.copyWith(notes: value);
  }

  void addLineItem() {
    state = state.copyWith(
      lineItems: [
        ...state.lineItems,
        const InvoiceLineItemForm(
          description: '',
          quantityString: '1',
          unitPriceString: '0',
          gstPercent: 0,
        ),
      ],
    );
  }

  void removeLineItem(int index) {
    if (state.lineItems.length <= 1) return;
    state = state.copyWith(
      lineItems: [...state.lineItems]..removeAt(index),
    );
  }

  void updateLineItemDescription(int index, String value) {
    final items = [...state.lineItems];
    items[index] =
        items[index].copyWith(description: value, descriptionError: null);
    state = state.copyWith(lineItems: items);
  }

  void updateLineItemQuantity(int index, String value) {
    final items = [...state.lineItems];
    items[index] = items[index].copyWith(quantityString: value);
    _recalcLineItem(index, items);
    state = state.copyWith(lineItems: items);
  }

  void updateLineItemUnitPrice(int index, String value) {
    final items = [...state.lineItems];
    items[index] = items[index].copyWith(unitPriceString: value);
    _recalcLineItem(index, items);
    state = state.copyWith(lineItems: items);
  }

  void updateLineItemGst(int index, double gstPercent) {
    final items = [...state.lineItems];
    items[index] = items[index].copyWith(gstPercent: gstPercent);
    _recalcLineItem(index, items);
    state = state.copyWith(lineItems: items);
  }

  void _recalcLineItem(int index, List<InvoiceLineItemForm> items) {
    final item = items[index];
    final qty = double.tryParse(item.quantityString) ?? 0;
    final price = int.tryParse(item.unitPriceString) ?? 0;
    final lineTotal = _computeLineTotal(qty, price);
    final gstAmount = _computeGstAmount(lineTotal, item.gstPercent);
    items[index] = items[index].copyWith(
      lineTotal: lineTotal,
      gstAmount: gstAmount,
    );
  }

  int get subtotal {
    return state.lineItems.fold(0, (total, item) => total + item.lineTotal);
  }

  int get totalGst {
    return state.lineItems.fold(0, (total, item) => total + item.gstAmount);
  }

  int get grandTotal {
    return subtotal + totalGst - state.discount;
  }

  String? _validatePhone(String phone) => PhoneValidator.validate(phone);

  Future<Invoice?> saveAsDraft() async {
    final name = state.customerName.trim();
    if (name.length < 2 || name.length > 200) {
      state = state.copyWith(customerNameError: ErrorCodes.nameMinLength);
      return null;
    }

    final phoneError = _validatePhone(state.customerPhone);
    if (phoneError != null) {
      state = state.copyWith(customerPhoneError: phoneError);
      return null;
    }

    bool hasError = false;
    final items = [...state.lineItems];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.description.trim().isEmpty) {
        items[i] =
            items[i].copyWith(descriptionError: ErrorCodes.descriptionRequired);
        hasError = true;
      }
      final qty = double.tryParse(item.quantityString) ?? 0;
      if (qty <= 0) hasError = true;
    }
    if (hasError) {
      state = state.copyWith(lineItems: items);
      return null;
    }

    state = state.copyWith(isSaving: true, saveError: null);

    final profile = ref.read(currentProfileProvider);
    if (profile == null) {
      state = state.copyWith(isSaving: false);
      return null;
    }

    // Paywalls removed: invoice creation is unconditional and free.
    final now = DateTime.now();
    final lineItemEntities = state.lineItems.map((f) {
      final qty = double.tryParse(f.quantityString) ?? 0;
      final price = int.tryParse(f.unitPriceString) ?? 0;
      return InvoiceLineItem(
        description: f.description.trim(),
        quantity: qty,
        unitPrice: price,
        gstPercent: f.gstPercent,
        gstAmount: f.gstAmount,
        lineTotal: f.lineTotal,
      );
    }).toList();

    final invoice = Invoice(
      id: const Uuid().v4(),
      userId: profile.userId,
      profileId: profile.id,
      invoiceNumber: '',
      customerName: name,
      customerPhone: state.customerPhone.trim().isEmpty
          ? null
          : state.customerPhone.trim(),
      issueDate: state.issueDate,
      dueDate: state.dueDate,
      lineItems: lineItemEntities,
      subtotal: subtotal,
      totalGst: totalGst,
      discount: state.discount,
      grandTotal: grandTotal,
      status: InvoiceStatus.draft,
      createdAt: now,
      updatedAt: now,
    );

    final repo = ref.read(invoiceRepositoryProvider);
    final result = await repo.createInvoice(invoice);

    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false, saveError: failure.message);
        return null;
      },
      (created) {
        ref.read(analyticsServiceProvider).logInvoiceCreated(
              hasGst: totalGst > 0,
              planAtCreation: 'FREE',
            );
        ref.invalidate(monthlyInvoiceCountProvider(profile.userId));
        state = state.copyWith(isSaving: false);
        return created;
      },
    );
  }
}

final invoiceViewModelProvider =
    NotifierProvider<InvoiceViewModel, InvoiceFormState>(
  InvoiceViewModel.new,
);

@freezed
abstract class InvoiceListState with _$InvoiceListState {
  const factory InvoiceListState({
    required List<Invoice> invoices,
    required bool isLoading,
    String? error,
  }) = _InvoiceListState;
}

final invoiceListViewModelProvider =
    StreamProvider.autoDispose<List<Invoice>>((ref) {
  final profile = ref.watch(currentProfileProvider);
  if (profile == null) return const Stream.empty();
  return ref
      .watch(invoiceRepositoryProvider)
      .watchInvoices(userId: profile.userId, profileId: profile.id);
});
