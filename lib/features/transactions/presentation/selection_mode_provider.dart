import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/transaction_type.dart';
import '../domain/entities/transaction.dart';

class SelectionState {
  const SelectionState({
    this.isActive = false,
    this.selectedIds = const {},
    this.selectedTransactions = const [],
  });

  final bool isActive;
  final Set<String> selectedIds;
  final List<Transaction> selectedTransactions;

  SelectionState copyWith({
    bool? isActive,
    Set<String>? selectedIds,
    List<Transaction>? selectedTransactions,
  }) {
    return SelectionState(
      isActive: isActive ?? this.isActive,
      selectedIds: selectedIds ?? this.selectedIds,
      selectedTransactions: selectedTransactions ?? this.selectedTransactions,
    );
  }
}

class SelectionModeNotifier extends Notifier<SelectionState> {
  @override
  SelectionState build() => const SelectionState();

  void enterMode(String id, Transaction txn) {
    state = SelectionState(
      isActive: true,
      selectedIds: {id},
      selectedTransactions: [txn],
    );
  }

  void toggleSelection(String id, Transaction txn) {
    final ids = Set<String>.from(state.selectedIds);
    final txns = List<Transaction>.from(state.selectedTransactions);

    if (ids.contains(id)) {
      ids.remove(id);
      txns.removeWhere((t) => t.id == id);
      if (ids.isEmpty) {
        state = const SelectionState();
        return;
      }
    } else {
      ids.add(id);
      txns.add(txn);
    }

    state = SelectionState(
      isActive: true,
      selectedIds: ids,
      selectedTransactions: txns,
    );
  }

  void exitMode() {
    state = const SelectionState();
  }

  void selectAll(List<Transaction> transactions) {
    state = SelectionState(
      isActive: true,
      selectedIds: transactions.map((t) => t.id).toSet(),
      selectedTransactions: List<Transaction>.from(transactions),
    );
  }
}

final selectionModeProvider =
    NotifierProvider.autoDispose<SelectionModeNotifier, SelectionState>(
  SelectionModeNotifier.new,
);

final selectedIncomeProvider = Provider.autoDispose<int>((ref) {
  final state = ref.watch(selectionModeProvider);
  return state.selectedTransactions
      .where((t) => t.type == TransactionType.income)
      .fold<int>(0, (sum, t) => sum + t.amount);
});

final selectedExpenseProvider = Provider.autoDispose<int>((ref) {
  final state = ref.watch(selectionModeProvider);
  return state.selectedTransactions
      .where((t) => t.type == TransactionType.expense)
      .fold<int>(0, (sum, t) => sum + t.amount);
});

final selectedNetProvider = Provider.autoDispose<int>((ref) {
  final income = ref.watch(selectedIncomeProvider);
  final expense = ref.watch(selectedExpenseProvider);
  return income - expense;
});
