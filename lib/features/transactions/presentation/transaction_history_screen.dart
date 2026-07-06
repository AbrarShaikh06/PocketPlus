import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:pocket_plus/l10n/app_localizations.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_names.dart';
import '../../../shared/models/models.dart';
import '../../../shared/models/transaction_filter.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/transaction_list_tile.dart';
import '../../categories/domain/entities/category.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/entities/transaction.dart';
import '../transactions_providers.dart';
import 'selection_calculator_bar.dart';
import 'selection_mode_provider.dart';
import 'transaction_history_view_model.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(transactionHistoryViewModelProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionHistoryViewModelProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectionState = ref.watch(selectionModeProvider);
    final isSelectionMode = selectionState.isActive;

    return PopScope(
      canPop: !isSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && isSelectionMode) {
          ref.read(selectionModeProvider.notifier).exitMode();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          title: Text(AppLocalizations.of(context)!.history),
          titleTextStyle: AppTextStyles.titleMedium(
            context,
            color: AppColors.onSurface,
          ),
          actions: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isSelectionMode
                  ? Row(
                      key: const ValueKey('selection_actions'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.countSelected(
                            selectionState.selectedIds.length.toString(),
                          ),
                          style: AppTextStyles.labelSmall(context),
                        ),
                        const SizedBox(width: AppSizes.spacing8),
                        TextButton(
                          onPressed: () {
                            final allVisible = state.groupedTransactions.values
                                .expand((list) => list)
                                .toList();
                            ref
                                .read(selectionModeProvider.notifier)
                                .selectAll(allVisible);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.selectAll,
                            style: AppTextStyles.labelSmall(
                              context,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.spacing8),
                      ],
                    )
                  : const SizedBox(
                      key: ValueKey('normal_actions'),
                      width: 0,
                    ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Column(
              children: [
                _SearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    ref
                        .read(transactionHistoryViewModelProvider.notifier)
                        .setSearchQuery(value);
                  },
                ),
                _FilterChipsRow(
                  activeFilters: state.activeFilters,
                  onFilterToggled: (filter) {
                    ref
                        .read(transactionHistoryViewModelProvider.notifier)
                        .toggleFilter(filter);
                  },
                ),
                const _AnomalyBanner(),
                const SizedBox(height: AppSizes.spacing12),
                Expanded(
                  child: categoriesAsync.when(
                    data: (categories) {
                      if (state.groupedTransactions.isEmpty) {
                        return EmptyState(
                          message:
                              AppLocalizations.of(context)!.noTransactionsFound,
                          illustration: const Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: AppColors.onSurfaceMuted,
                          ),
                        );
                      }
                      return _TransactionList(
                        scrollController: _scrollController,
                        groupedTransactions: state.groupedTransactions,
                        categories: categories,
                        isLoadingMore: state.isLoadingMore,
                        formatDateGroup: ref
                            .read(transactionHistoryViewModelProvider.notifier)
                            .formatDateGroup,
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .errorWithMessage(e.toString()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SelectionCalculatorBar(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => context.push(RouteNames.addTransaction),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spacing24,
        AppSizes.spacing8,
        AppSizes.spacing24,
        AppSizes.spacing4,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchHint,
          hintStyle: AppTextStyles.bodyMedium(
            context,
            color: AppColors.onSurfaceMuted,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.onSurfaceMuted,
          ),
          filled: true,
          fillColor: AppColors.card,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing16,
            vertical: AppSizes.spacing12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _FilterChipsRow extends StatelessWidget {
  const _FilterChipsRow({
    required this.activeFilters,
    required this.onFilterToggled,
  });

  final Set<TransactionFilter> activeFilters;
  final ValueChanged<TransactionFilter> onFilterToggled;

  static const _allFilters = [
    TransactionFilter.all,
    TransactionFilter.income,
    TransactionFilter.expense,
    TransactionFilter.thisMonth,
    TransactionFilter.lastMonth,
  ];

  String _label(BuildContext context, TransactionFilter filter) {
    switch (filter) {
      case TransactionFilter.all:
        return AppLocalizations.of(context)!.all;
      case TransactionFilter.income:
        return AppLocalizations.of(context)!.income;
      case TransactionFilter.expense:
        return AppLocalizations.of(context)!.expense;
      case TransactionFilter.thisMonth:
        return AppLocalizations.of(context)!.thisMonth;
      case TransactionFilter.lastMonth:
        return AppLocalizations.of(context)!.lastMonth;
      case TransactionFilter.customDate:
        return AppLocalizations.of(context)!.custom;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing24),
        itemCount: _allFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSizes.spacing8),
        itemBuilder: (context, index) {
          final filter = _allFilters[index];
          final isSelected = activeFilters.contains(filter);
          return Center(
            child: _FilterChip(
              label: _label(context, filter),
              isSelected: isSelected,
              onTap: () => onFilterToggled(filter),
            ),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing16,
          vertical: AppSizes.spacing8,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.radius12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.outline.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall(
            context,
            color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
          ).copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _AnomalyBanner extends StatelessWidget {
  const _AnomalyBanner();

  @override
  Widget build(BuildContext context) {
    // TODO: wire to live anomaly detection in IGR-XXX
    return const SizedBox.shrink();
  }
}

class _TransactionList extends ConsumerWidget {
  const _TransactionList({
    required this.scrollController,
    required this.groupedTransactions,
    required this.categories,
    required this.isLoadingMore,
    required this.formatDateGroup,
  });

  final ScrollController scrollController;
  final Map<DateTime, List<Transaction>> groupedTransactions;
  final List<Category> categories;
  final bool isLoadingMore;
  final String Function(DateTime) formatDateGroup;

  Category _findCategory(BuildContext context, String? categoryId) {
    if (categoryId != null && categoryId.startsWith('sys_unaccounted')) {
      return Category(
        id: categoryId,
        name: 'Unaccounted',
        icon: 'help_outline',
        colorHex: '#9E9E9E',
        type: TransactionType.expense,
      );
    }
    return categories.firstWhere(
      (c) => c.id == categoryId,
      orElse: () => Category(
        id: 'unknown',
        name: AppLocalizations.of(context)!.unknown,
        icon: 'receipt_long',
        colorHex: '#607D8B',
        type: TransactionType.expense,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messenger = ScaffoldMessenger.of(context);
    final localizations = AppLocalizations.of(context)!;
    final isSelectionMode = ref.watch(selectionModeProvider).isActive;
    final selectedIds = ref.watch(selectionModeProvider).selectedIds;
    final selectionNotifier = ref.read(selectionModeProvider.notifier);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        ...groupedTransactions.entries.map((entry) {
          return [
            SliverToBoxAdapter(
              // Inline (non-pinned) header that scrolls with its own day's
              // transactions. Pinned SliverPersistentHeaders trip a framework
              // assertion here ("layoutExtent exceeds paintExtent") that blanks
              // the whole list, so the date is shown inline above each group.
              child: _DateGroupHeader(
                label: formatDateGroup(entry.key),
                count: entry.value.length,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (itemContext, index) {
                  final txn = entry.value[index];
                  final category = _findCategory(itemContext, txn.categoryId);
                  final isSelected = selectedIds.contains(txn.id);
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.spacing24,
                      vertical: AppSizes.spacing4,
                    ),
                    child: Dismissible(
                      key: ValueKey(txn.id),
                      direction: isSelectionMode
                          ? DismissDirection.none
                          : DismissDirection.endToStart,
                      resizeDuration: Duration.zero,
                      confirmDismiss: (direction) async {
                        final repo = ref.read(transactionRepositoryProvider);
                        final result = await repo.softDeleteTransaction(txn.id);
                        if (result.isRight()) {
                          // Show SnackBar here while context is still mounted.
                          // onDismissed fires after the element is deactivated
                          // (with resizeDuration: zero), making OF lookups unsafe.
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(localizations.transactionDeleted),
                              duration: const Duration(seconds: 5),
                              action: SnackBarAction(
                                label: localizations.undo,
                                onPressed: () async {
                                  await repo.restoreTransaction(txn.id);
                                  messenger.hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );
                        }
                        return result.isRight();
                      },
                      onDismissed: (_) {},
                      child: TransactionListTile(
                        transaction: txn,
                        category: category,
                        isSelectionMode: isSelectionMode,
                        isSelected: isSelected,
                        onTap: isSelectionMode
                            ? () {
                                HapticFeedback.selectionClick();
                                selectionNotifier.toggleSelection(
                                  txn.id,
                                  txn,
                                );
                              }
                            : () => context.push(
                                  RouteNames.transactionDetail(txn.id),
                                ),
                        onLongPress: isSelectionMode
                            ? null
                            : () {
                                HapticFeedback.lightImpact();
                                selectionNotifier.enterMode(txn.id, txn);
                              },
                      ),
                    ),
                  );
                },
                childCount: entry.value.length,
              ),
            ),
          ];
        }).expand((e) => e),
        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSizes.spacing24),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

/// Inline date separator shown above each day's transactions. Scrolls with the
/// list (not pinned) — pinned persistent headers trip a framework assertion in
/// this list that blanks the transactions, so a reliable inline marker is used.
class _DateGroupHeader extends StatelessWidget {
  const _DateGroupHeader({required this.label, required this.count});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSizes.spacing24,
        AppSizes.spacing16,
        AppSizes.spacing24,
        AppSizes.spacing8,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing12,
              vertical: AppSizes.spacing4,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSizes.radius8),
            ),
            child: Text(
              label,
              style: AppTextStyles.labelSmall(
                context,
                color: AppColors.primary,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Divider(
              color: AppColors.outline.withValues(alpha: 0.4),
              height: 1,
            ),
          ),
          const SizedBox(width: AppSizes.spacing12),
          Text(
            '$count',
            style: AppTextStyles.labelSmall(
              context,
              color: AppColors.onSurfaceMuted,
            ),
          ),
        ],
      ),
    );
  }
}
