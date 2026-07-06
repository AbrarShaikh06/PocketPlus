import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_formatter.dart';
import '../../../shared/models/transaction_filter.dart';
import '../../../shared/models/transaction_type.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/entities/transaction.dart';
import '../transactions_providers.dart';

class TransactionHistoryState {
  const TransactionHistoryState({
    this.searchQuery = '',
    this.activeFilters = const {TransactionFilter.all},
    this.transactions = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
    this.groupedTransactions = const {},
    this.error,
  });

  final String searchQuery;
  final Set<TransactionFilter> activeFilters;
  final List<Transaction> transactions;
  final bool isLoadingMore;
  final bool hasMore;
  final Map<DateTime, List<Transaction>> groupedTransactions;
  final String? error;

  TransactionHistoryState copyWith({
    String? searchQuery,
    Set<TransactionFilter>? activeFilters,
    List<Transaction>? transactions,
    bool? isLoadingMore,
    bool? hasMore,
    Map<DateTime, List<Transaction>>? groupedTransactions,
    String? error,
    bool clearError = false,
  }) {
    return TransactionHistoryState(
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilters: activeFilters ?? this.activeFilters,
      transactions: transactions ?? this.transactions,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      groupedTransactions: groupedTransactions ?? this.groupedTransactions,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

final transactionHistoryViewModelProvider =
    NotifierProvider<TransactionHistoryViewModel, TransactionHistoryState>(
  TransactionHistoryViewModel.new,
);

class TransactionHistoryViewModel extends Notifier<TransactionHistoryState> {
  List<Transaction> _allTransactions = [];
  int _visibleCount = 50;
  static const int _pageSize = 50;
  Timer? _debounceTimer;
  StreamSubscription<List<Transaction>>? _subscription;

  @override
  TransactionHistoryState build() {
    ref.onDispose(() {
      _subscription?.cancel();
      _debounceTimer?.cancel();
    });

    _startListening();
    return const TransactionHistoryState();
  }

  void _startListening() {
    final profile = ref.read(currentProfileProvider);
    final userId = profile?.userId;
    if (userId == null || profile == null) return;

    final stream = ref
        .read(transactionRepositoryProvider)
        .watchTransactions(userId: userId, profileId: profile.id);

    _subscription = stream.listen((txns) {
      _allTransactions = txns;
      _applyFiltersAndPagination();
    });
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _visibleCount = _pageSize;
      _applyFiltersAndPagination();
    });
  }

  void toggleFilter(TransactionFilter filter) {
    final current = Set<TransactionFilter>.from(state.activeFilters);

    if (filter == TransactionFilter.all) {
      state = state.copyWith(activeFilters: {TransactionFilter.all});
    } else {
      current.remove(TransactionFilter.all);
      if (current.contains(filter)) {
        current.remove(filter);
        if (current.isEmpty) {
          current.add(TransactionFilter.all);
        }
      } else {
        current.add(filter);
      }
      state = state.copyWith(activeFilters: current);
    }

    _visibleCount = _pageSize;
    _debounceTimer?.cancel();
    _applyFiltersAndPagination();
  }

  void loadMore() {
    if (state.isLoadingMore || !state.hasMore) return;
    state = state.copyWith(isLoadingMore: true);
    _visibleCount += _pageSize;
    _applyFiltersAndPagination();
  }

  void _applyFiltersAndPagination() {
    var filtered = _allTransactions.where((t) => !t.isDeleted).toList();
    filtered = _applySearch(filtered);
    filtered = _applyTypeFilters(filtered);
    filtered = _applyDateFilters(filtered);
    // Newest first by transaction time, with deterministic tie-breakers so
    // transactions sharing a timestamp keep a stable, predictable order.
    filtered.sort((a, b) {
      final byDate = b.transactionDate.compareTo(a.transactionDate);
      if (byDate != 0) return byDate;
      final byCreated = b.createdAt.compareTo(a.createdAt);
      if (byCreated != 0) return byCreated;
      return b.id.compareTo(a.id);
    });

    final hasMore = filtered.length > _visibleCount;
    final visible = filtered.take(_visibleCount).toList();

    state = state.copyWith(
      transactions: visible,
      groupedTransactions: _groupByDate(visible),
      isLoadingMore: false,
      hasMore: hasMore,
      error: null,
    );
  }

  List<Transaction> _applySearch(List<Transaction> txns) {
    final query = state.searchQuery.trim().toLowerCase();
    if (query.isEmpty) return txns;
    return txns.where((t) {
      return (t.merchantName?.toLowerCase().contains(query) ?? false) ||
          (t.note?.toLowerCase().contains(query) ?? false) ||
          t.amount.toString().contains(query);
    }).toList();
  }

  List<Transaction> _applyTypeFilters(List<Transaction> txns) {
    final filters = state.activeFilters;
    if (filters.length == 1 && filters.contains(TransactionFilter.all)) {
      return txns;
    }

    final hasIncome = filters.contains(TransactionFilter.income);
    final hasExpense = filters.contains(TransactionFilter.expense);

    if (hasIncome && !hasExpense) {
      return txns.where((t) => t.type == TransactionType.income).toList();
    }
    if (hasExpense && !hasIncome) {
      return txns.where((t) => t.type == TransactionType.expense).toList();
    }
    return txns;
  }

  List<Transaction> _applyDateFilters(List<Transaction> txns) {
    final filters = state.activeFilters;
    final now = DateTime.now();

    final hasThisMonth = filters.contains(TransactionFilter.thisMonth);
    final hasLastMonth = filters.contains(TransactionFilter.lastMonth);
    final hasCustomDate = filters.contains(TransactionFilter.customDate);

    if (!hasThisMonth && !hasLastMonth && !hasCustomDate) return txns;

    return txns.where((t) {
      final txnDate = DateTime(
        t.transactionDate.year,
        t.transactionDate.month,
        t.transactionDate.day,
      );

      if (hasThisMonth) {
        final thisMonthStart = DateTime(now.year, now.month, 1);
        final nextMonthStart = DateTime(now.year, now.month + 1, 1);
        if (txnDate.isBefore(thisMonthStart) ||
            txnDate.compareTo(nextMonthStart) >= 0) {
          return false;
        }
      }

      if (hasLastMonth) {
        final thisMonthStart = DateTime(now.year, now.month, 1);
        final lastMonthStart = DateTime(now.year, now.month - 1, 1);
        if (txnDate.isBefore(lastMonthStart) ||
            txnDate.compareTo(thisMonthStart) >= 0) {
          return false;
        }
      }

      if (hasCustomDate) {
        // Custom date range not yet implemented — wire in live ticket
        return true;
      }

      return true;
    }).toList();
  }

  Map<DateTime, List<Transaction>> _groupByDate(List<Transaction> txns) {
    final map = <DateTime, List<Transaction>>{};
    for (final txn in txns) {
      final date = DateTime(
        txn.transactionDate.year,
        txn.transactionDate.month,
        txn.transactionDate.day,
      );
      map.putIfAbsent(date, () => []);
      map[date]!.add(txn);
    }
    final sortedKeys = map.keys.toList()..sort((a, b) => b.compareTo(a));
    final sortedMap = <DateTime, List<Transaction>>{};
    for (final key in sortedKeys) {
      sortedMap[key] = map[key]!;
    }
    return sortedMap;
  }

  String formatDateGroup(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';
    return DateFormatter.display(date);
  }
}
