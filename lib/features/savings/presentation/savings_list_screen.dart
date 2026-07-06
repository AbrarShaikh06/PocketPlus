import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../domain/savings_goal.dart';
import 'savings_providers.dart';
import 'savings_view_model.dart';
import 'widgets/add_entry_bottom_sheet.dart';
import 'widgets/dream_card.dart';

class SavingsListScreen extends ConsumerStatefulWidget {
  const SavingsListScreen({super.key});

  @override
  ConsumerState<SavingsListScreen> createState() => _SavingsListScreenState();
}

class _SavingsListScreenState extends ConsumerState<SavingsListScreen> {
  // Toggle between viewing active vs completed dreams (matches mockup's View History style)
  bool _showActive = true;

  void _showAddMoneyBottomSheet(BuildContext context, SavingsGoal goal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AddSavingsEntryBottomSheet(goal: goal),
    ).then((outcome) {
      // The detail screen celebrates via its own reactive trigger, but money
      // can also be added straight from this list — so completing the goal here
      // must navigate to the reward (celebration) screen too.
      if (outcome == AddEntryOutcome.goalCompleted && context.mounted) {
        context.push(RouteNames.savingsReward(goal.id));
      }
    });
  }

  Future<void> _handleDelete(SavingsGoal goal) async {
    final repository = ref.read(savingsRepositoryProvider);
    final result = await repository.softDeleteGoal(goal.id);

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete: ${failure.message}')),
          );
        }
      },
      (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Goal "${goal.name}" deleted'),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Undo',
                textColor: AppColors.primaryLight,
                onPressed: () async {
                  await repository.restoreGoal(goal.id);
                },
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeGoalsAsync = ref.watch(activeGoalsProvider);
    final achievedGoalsAsync = ref.watch(achievedGoalsProvider);
    final goalsStream = ref.watch(savingsGoalsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Savings Goals',
          style:
              AppTextStyles.titleLarge(context, color: Colors.white).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSizes.spacing16),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuD0VvnuvSMp7Vhaab3nceUFvL46XpdQhMCrNZKsDErXdASEuhzI8jkfF5qmnJ5F7aOWMka1L3pU2Yhj-LIkK_5FKPIyAlalS20UEJzArCMut1n4KDrj9gMKE__AT_xfWYq0XsoS73TXra4xO-4QjDLUpNlPYbfZ56uxvf_Pso3gKLiaQFWaNfWdDt4Y17M77uPY4-kOTNSOO8mJfW18mjwcvvXxiFWciwNViA9LeA0BITnMUn6-Gj9jyny2dA1BZxxaMzzhR_Ug1eA',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: goalsStream.when(
        data: (goalsList) {
          final activeGoals = activeGoalsAsync;
          final achievedGoals = achievedGoalsAsync;
          final currentGoals = _showActive ? activeGoals : achievedGoals;

          // Calculate total saved amount in all goals combined
          final int totalSaved =
              goalsList.fold(0, (sum, g) => sum + g.savedAmount);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacing16,
              vertical: AppSizes.spacing24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Section: Total Saved Summary Card
                _buildTotalSavedCard(totalSaved),
                const SizedBox(height: AppSizes.spacing24),

                // Goal List Header (Dreams header)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _showActive ? 'Your Dreams' : 'Completed Dreams',
                      style: AppTextStyles.titleMedium(context).copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showActive = !_showActive;
                        });
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        _showActive ? 'View Completed' : 'View Active',
                        style: AppTextStyles.labelLarge(
                          context,
                          color: AppColors.primary,
                        ).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing16),

                // Goal cards stack
                if (currentGoals.isEmpty)
                  _buildEmptyState()
                else
                  Column(
                    children: List.generate(currentGoals.length, (index) {
                      final goal = currentGoals[index];
                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSizes.spacing16),
                        child: Dismissible(
                          key: Key(goal.id),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => _handleDelete(goal),
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(
                              right: AppSizes.spacing24,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          child: DreamCard(
                            goal: goal,
                            onAddMoney: () =>
                                _showAddMoneyBottomSheet(context, goal),
                          ),
                        ),
                      );
                    }),
                  ),

                // Empty state quote card
                const SizedBox(height: AppSizes.spacing8),
                _buildQuoteCard(),
              ],
            ),
          );
        },
        loading: () => const _SavingsSkeletonLoading(),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.spacing24),
            child: EmptyState(
              message: 'Failed to load savings goals: $err',
              ctaLabel: 'Retry',
              onCtaPressed: () => ref.invalidate(savingsGoalsStreamProvider),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => context.push(RouteNames.savingsNew),
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add New Goal',
          style:
              AppTextStyles.labelLarge(context, color: Colors.white).copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTotalSavedCard(int totalSaved) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
      ),
      child: Stack(
        children: [
          // Decorative background blur circle
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL SAVED',
                style: AppTextStyles.labelSmall(
                  context,
                  color: AppColors.onSurfaceMuted,
                ).copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSizes.spacing8),
              Text(
                CurrencyFormatter.formatRupees(totalSaved),
                style: AppTextStyles.displayLarge(
                  context,
                  color: AppColors.primary,
                ).copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSizes.spacing12),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                  border: Border.all(
                    color: AppColors.secondary.withValues(alpha: 0.2),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 14,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '12% more than last month',
                      style: AppTextStyles.labelSmall(context).copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.spacing32,
        horizontal: AppSizes.spacing16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      child: EmptyState(
        message: _showActive
            ? 'What are you saving for?'
            : 'No completed goals yet.\nKeep saving toward your dreams!',
        illustration: Icon(
          _showActive ? Icons.star_outline : Icons.emoji_events_outlined,
          size: 64,
          color: AppColors.primary.withValues(alpha: 0.6),
        ),
        ctaLabel: _showActive ? 'Add Dream Goal' : null,
        onCtaPressed:
            _showActive ? () => context.push(RouteNames.savingsNew) : null,
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(
          color: AppColors.outline.withValues(alpha: 0.3),
          style: BorderStyle
              .solid, // dashed border emulation using opacity & light outlines
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.savings, color: AppColors.onSurfaceMuted, size: 24),
          SizedBox(width: AppSizes.spacing8),
          Flexible(
            child: Text(
              '"A penny saved is a penny earned."',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: AppColors.onSurfaceMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SavingsSkeletonLoading extends StatelessWidget {
  const _SavingsSkeletonLoading();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacing24),
      child: Column(
        children: [
          LoadingShimmer.card(height: 160),
          const SizedBox(height: AppSizes.spacing24),
          LoadingShimmer.card(height: 120),
          const SizedBox(height: AppSizes.spacing16),
          LoadingShimmer.card(height: 120),
        ],
      ),
    );
  }
}
