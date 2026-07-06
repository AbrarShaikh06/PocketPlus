import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/route_names.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../domain/savings_goal.dart';
import 'savings_providers.dart';
import 'widgets/add_entry_bottom_sheet.dart';
import 'widgets/confetti_animation.dart';
import 'widgets/savings_progress_bar.dart';

class DreamDetailScreen extends ConsumerStatefulWidget {
  const DreamDetailScreen({
    required this.goalId,
    super.key,
  });

  final String goalId;

  @override
  ConsumerState<DreamDetailScreen> createState() => _DreamDetailScreenState();
}

class _DreamDetailScreenState extends ConsumerState<DreamDetailScreen> {
  bool _hasCelebrated = false;

  void _showAddMoneyBottomSheet(BuildContext context, SavingsGoal goal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => AddSavingsEntryBottomSheet(goal: goal),
    );
    // No navigation needed here: when the entry completes the goal, the
    // streamed goal becomes achieved and the reactive trigger in build()
    // pushes the reward (celebration) screen.
  }

  void _showEditGoalDialog(BuildContext context, SavingsGoal goal) {
    final nameController = TextEditingController(text: goal.name);
    final notesController = TextEditingController(text: goal.notes ?? '');
    final amountController = TextEditingController(
      text: (goal.targetAmount / 100).toStringAsFixed(0),
    );
    DateTime? pickedDate = goal.targetDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: AppSizes.spacing24,
                right: AppSizes.spacing24,
                top: AppSizes.spacing24,
                bottom: MediaQuery.of(context).viewInsets.bottom +
                    AppSizes.spacing24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Edit Savings Goal',
                    style: AppTextStyles.titleMedium(context),
                  ),
                  const SizedBox(height: AppSizes.spacing16),
                  AppTextField(
                    controller: nameController,
                    label: 'Goal Name',
                    maxLength: 100,
                  ),
                  const SizedBox(height: AppSizes.spacing12),
                  AppTextField(
                    controller: amountController,
                    label: 'Target Amount (₹)',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: AppSizes.spacing12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          pickedDate == null
                              ? 'No Target Date set'
                              : 'Target Date: ${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}',
                          style: AppTextStyles.bodyMedium(context),
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: const Text('Change'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: pickedDate ??
                                DateTime.now().add(const Duration(days: 30)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setModalState(() {
                              pickedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.spacing12),
                  AppTextField(
                    controller: notesController,
                    label: 'Notes / Description (Optional)',
                    maxLength: 200,
                  ),
                  const SizedBox(height: AppSizes.spacing20),
                  AppButton(
                    label: 'Update Goal',
                    onPressed: () async {
                      final name = nameController.text.trim();
                      final amountVal =
                          double.tryParse(amountController.text) ?? 0.0;
                      final targetAmount = (amountVal * 100).round();

                      if (name.isEmpty ||
                          name.length < 2 ||
                          targetAmount <= 0) {
                        return;
                      }

                      final updated = goal.copyWith(
                        name: name,
                        targetAmount: targetAmount,
                        targetDate: pickedDate,
                        notes: notesController.text.trim().isEmpty
                            ? null
                            : notesController.text.trim(),
                        updatedAt: DateTime.now(),
                      );

                      final result = await ref
                          .read(savingsRepositoryProvider)
                          .updateGoal(updated);

                      result.fold(
                        (f) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${f.message}')),
                        ),
                        (_) {
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Goal updated successfully'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _markAsAchieved(SavingsGoal goal) async {
    final updated = goal.copyWith(
      isAchieved: true,
      achievedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result =
        await ref.read(savingsRepositoryProvider).updateGoal(updated);

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${failure.message}')),
          );
        }
      },
      (_) {
        setState(() {
          _hasCelebrated = false; // Reset to allow celebration
        });
      },
    );
  }

  String _getCategoryEmoji(SavingsCategory category) {
    switch (category) {
      case SavingsCategory.CAR:
        return '🚗';
      case SavingsCategory.HOUSE:
        return '🏠';
      case SavingsCategory.EDUCATION:
        return '📚';
      case SavingsCategory.BUSINESS:
        return '🏪';
      case SavingsCategory.TRAVEL:
        return '✈️';
      case SavingsCategory.OTHER:
        return '⭐';
    }
  }

  int? _daysRemaining(DateTime? targetDate) {
    if (targetDate == null) return null;
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final targetDateOnly =
        DateTime(targetDate.year, targetDate.month, targetDate.day);
    final diff = targetDateOnly.difference(todayDate).inDays;
    return diff < 0 ? 0 : diff;
  }

  @override
  Widget build(BuildContext context) {
    final goalsStream = ref.watch(savingsGoalsStreamProvider);

    return goalsStream.when(
      data: (goals) {
        final goalIndex = goals.indexWhere((g) => g.id == widget.goalId);
        if (goalIndex == -1) {
          return const Scaffold(
            body: Center(child: Text('Savings Goal not found')),
          );
        }

        final goal = goals[goalIndex];
        final entriesAsync = ref.watch(savingsEntriesStreamProvider(goal.id));

        final double percentage = goal.targetAmount > 0
            ? (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0)
            : 0.0;
        final int percentInt = (percentage * 100).round();
        final daysLeft = _daysRemaining(goal.targetDate);

        final isAchieved =
            goal.isAchieved || (goal.savedAmount >= goal.targetAmount);

        // Navigate to reward screen when goal is achieved
        if (isAchieved && !_hasCelebrated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _hasCelebrated = true;
            });
            // Brief confetti on detail screen, then navigate to full reward screen
            Future.delayed(const Duration(milliseconds: 400), () {
              if (context.mounted) {
                context.push(RouteNames.savingsReward(goal.id));
              }
            });
          });
        }

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: Text(
              goal.name,
              style: AppTextStyles.titleLarge(context),
            ),
            actions: [
              IconButton(
                tooltip: 'Edit goal',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _showEditGoalDialog(context, goal),
              ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(AppSizes.spacing24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hero Section
                    Card(
                      elevation: 0,
                      color: AppColors.card,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: AppColors.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSizes.spacing24),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSizes.spacing16),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.outline.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                _getCategoryEmoji(goal.category),
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                            const SizedBox(height: AppSizes.spacing16),
                            Text(
                              goal.name,
                              style:
                                  AppTextStyles.titleMedium(context).copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (goal.notes != null &&
                                goal.notes!.isNotEmpty) ...[
                              const SizedBox(height: AppSizes.spacing4),
                              Text(
                                goal.notes!,
                                style:
                                    AppTextStyles.bodyMedium(context).copyWith(
                                  color: AppColors.onSurfaceMuted,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const SizedBox(height: AppSizes.spacing24),
                            SavingsProgressBar(
                              savedAmount: goal.savedAmount,
                              targetAmount: goal.targetAmount,
                            ),
                            const SizedBox(height: AppSizes.spacing16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${CurrencyFormatter.formatRupees(goal.savedAmount)} saved',
                                  style:
                                      AppTextStyles.bodyLarge(context).copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  'of ${CurrencyFormatter.formatRupees(goal.targetAmount)}',
                                  style: AppTextStyles.bodyMedium(context)
                                      .copyWith(
                                    color: AppColors.onSurfaceMuted,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSizes.spacing16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.spacing12,
                                    vertical: AppSizes.spacing8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isAchieved
                                        ? AppColors.primaryLight
                                        : AppColors.outline
                                            .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    isAchieved
                                        ? 'Achieved 🎉'
                                        : '$percentInt% Completed',
                                    style: AppTextStyles.labelSmall(context)
                                        .copyWith(
                                      color: isAchieved
                                          ? AppColors.primary
                                          : AppColors.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (daysLeft != null && !isAchieved)
                                  Text(
                                    '$daysLeft days remaining',
                                    style: AppTextStyles.labelSmall(context),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.spacing20),

                    // Actions
                    if (!isAchieved) ...[
                      AppButton(
                        label: 'Add Money Today',
                        onPressed: () =>
                            _showAddMoneyBottomSheet(context, goal),
                      ),
                      const SizedBox(height: AppSizes.spacing12),
                      AppButton(
                        label: 'Mark as Achieved',
                        variant: AppButtonVariant.outline,
                        onPressed: () => _markAsAchieved(goal),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(AppSizes.spacing16),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'You reached this savings dream! 🎉',
                            style: AppTextStyles.titleMedium(context).copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSizes.spacing24),

                    // Contribution History
                    Text(
                      'Contribution History',
                      style: AppTextStyles.titleMedium(context),
                    ),
                    const SizedBox(height: AppSizes.spacing12),

                    entriesAsync.when(
                      data: (entries) {
                        if (entries.isEmpty) {
                          return Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 24.0),
                              child: Text(
                                'No money added yet.\nStart saving today!',
                                style: AppTextStyles.bodyMedium(
                                  context,
                                  color: AppColors.onSurfaceMuted,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: entries.length,
                          separatorBuilder: (_, __) => Divider(
                            color: AppColors.outline.withValues(alpha: 0.3),
                          ),
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                CurrencyFormatter.formatRupees(entry.amount),
                                style:
                                    AppTextStyles.bodyLarge(context).copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              subtitle:
                                  entry.note != null && entry.note!.isNotEmpty
                                      ? Text(entry.note!)
                                      : null,
                              trailing: Text(
                                '${entry.entryDate.day}/${entry.entryDate.month}/${entry.entryDate.year}',
                                style: AppTextStyles.labelSmall(context),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const LoadingShimmerList(itemCount: 2),
                      error: (err, _) => Text('Error loading entries: $err'),
                    ),
                  ],
                ),
              ),
              ConfettiAnimation(isTriggered: _hasCelebrated),
            ],
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}
