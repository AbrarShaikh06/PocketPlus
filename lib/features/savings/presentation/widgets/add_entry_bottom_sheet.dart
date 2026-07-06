import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/savings_goal.dart';
import '../savings_view_model.dart';

class AddSavingsEntryBottomSheet extends ConsumerStatefulWidget {
  const AddSavingsEntryBottomSheet({
    required this.goal,
    super.key,
  });

  final SavingsGoal goal;

  @override
  ConsumerState<AddSavingsEntryBottomSheet> createState() =>
      _AddSavingsEntryBottomSheetState();
}

class _AddSavingsEntryBottomSheetState
    extends ConsumerState<AddSavingsEntryBottomSheet> {
  @override
  void initState() {
    super.initState();
    ref.invalidate(addSavingsEntryViewModelProvider);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addSavingsEntryViewModelProvider);
    final notifier = ref.read(addSavingsEntryViewModelProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSizes.spacing24,
        right: AppSizes.spacing24,
        top: AppSizes.spacing24,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.spacing24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add to ${widget.goal.name}',
                style: AppTextStyles.titleMedium(context),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing12),
          Text(
            'How much have you added to your dream today?',
            style: AppTextStyles.bodyMedium(context).copyWith(
              color: AppColors.onSurfaceMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.spacing16),
          Center(
            child: Text(
              '₹ ${_formatAmount(state.amountString)}',
              style: AppTextStyles.displayLarge(context).copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          if (state.amountError != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.spacing4),
              child: Text(
                state.amountError!,
                style: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: AppSizes.spacing16),
          _buildKeypad(context, notifier),
          const SizedBox(height: AppSizes.spacing16),
          Row(
            children: [
              Expanded(
                child: Text(
                  state.entryDate == null
                      ? 'Select date'
                      : 'Date: ${_formatDate(state.entryDate!)}',
                  style: AppTextStyles.bodyMedium(context),
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today, size: 18),
                label: const Text('Change'),
                onPressed: () => _selectDate(context, state, notifier),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing12),
          AppTextField(
            hint: 'Note (optional)',
            maxLength: 200,
            onChanged: (value) => notifier.setNote(value),
          ),
          if (state.saveError != null) ...[
            const SizedBox(height: AppSizes.spacing12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    state.saveError!,
                    style: AppTextStyles.bodyMedium(
                      context,
                      color: AppColors.error,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _save(notifier),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSizes.spacing16),
          AppButton(
            label: 'Add to Dream',
            isLoading: state.isSaving,
            onPressed: state.isSaving ? null : () => _save(notifier),
          ),
        ],
      ),
    );
  }

  String _formatAmount(String amountString) {
    if (amountString == '0') return '0';
    if (!amountString.contains('.')) return amountString;
    final parts = amountString.split('.');
    if (parts.length == 2) {
      if (parts[1].isEmpty) return '${parts[0]}.';
      return amountString;
    }
    return amountString;
  }

  Widget _buildKeypad(BuildContext context, AddSavingsEntryViewModel notifier) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', 'backspace'],
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: keys.map((row) {
        return Row(
          children: row.map((key) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: AspectRatio(
                  aspectRatio: 2.2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColors.outline.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    onPressed: () => notifier.pressKey(key),
                    child: key == 'backspace'
                        ? const Icon(Icons.backspace_outlined)
                        : Text(
                            key,
                            style: AppTextStyles.titleMedium(context),
                          ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    AddSavingsEntryFormState state,
    AddSavingsEntryViewModel notifier,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: state.entryDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      notifier.setEntryDate(picked);
    }
  }

  Future<void> _save(AddSavingsEntryViewModel notifier) async {
    final outcome = await notifier.save(goal: widget.goal);
    if (!mounted) return;

    if (outcome == AddEntryOutcome.failed) {
      final state = ref.read(addSavingsEntryViewModelProvider);
      if (state.saveError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.saveError!),
          ),
        );
      }
      return;
    }

    // Hand the outcome back so the opener can show the reward celebration
    // when this entry completed the goal.
    context.pop(outcome);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
