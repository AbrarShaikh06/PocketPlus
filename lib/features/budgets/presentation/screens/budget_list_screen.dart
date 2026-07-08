import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/budget.dart';
import '../providers/budget_providers.dart';
import '../widgets/budget_card.dart';
import '../widgets/budget_empty_state.dart';
import '../widgets/budget_filter_chips.dart';

class BudgetListScreen extends ConsumerStatefulWidget {
  const BudgetListScreen({super.key});

  @override
  ConsumerState<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends ConsumerState<BudgetListScreen> {
  BudgetPeriod? _selectedPeriod;

  @override
  Widget build(BuildContext context) {
    final asyncBudgets = ref.watch(calculatedBudgetsProvider);
    final paused = ref.watch(pausedBudgetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.budgets),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context)!.createBudget,
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/budgets/new'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(budgetsStreamProvider);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.spacing8),
            BudgetFilterChips(
              selectedPeriod: _selectedPeriod,
              onSelected: (period) => setState(() => _selectedPeriod = period),
            ),
            const SizedBox(height: AppSizes.spacing8),
            Expanded(
              child: _buildContent(context, asyncBudgets, paused),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context, List<Budget> budgets, List<Budget> paused) {
    if (budgets.isEmpty && paused.isEmpty) {
      return const BudgetEmptyState();
    }

    var filtered = budgets;
    if (_selectedPeriod != null) {
      filtered = budgets.where((b) => b.period == _selectedPeriod).toList();
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
      children: [
        if (filtered.isEmpty && budgets.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSizes.spacing32),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.noBudgetsMatchFilter,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceMuted,
                    ),
              ),
            ),
          ),
        ...filtered.map((budget) => BudgetCard(budget: budget)),
        if (paused.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spacing16),
          Text(
            AppLocalizations.of(context)!.paused,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.onSurfaceMuted,
                ),
          ),
          const SizedBox(height: AppSizes.spacing8),
          ...paused.map((budget) => BudgetCard(budget: budget)),
        ],
        const SizedBox(height: AppSizes.spacing48), // FAB padding
      ],
    );
  }
}
