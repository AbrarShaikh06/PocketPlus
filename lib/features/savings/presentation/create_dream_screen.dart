import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocket_plus/core/errors/error_localizer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../domain/savings_goal.dart';
import 'savings_view_model.dart';

class CreateDreamScreen extends ConsumerStatefulWidget {
  const CreateDreamScreen({super.key});

  @override
  ConsumerState<CreateDreamScreen> createState() => _CreateDreamScreenState();
}

class _CreateDreamScreenState extends ConsumerState<CreateDreamScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
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

  String _getCategoryName(SavingsCategory category) {
    switch (category) {
      case SavingsCategory.CAR:
        return 'Car';
      case SavingsCategory.HOUSE:
        return 'House';
      case SavingsCategory.EDUCATION:
        return 'Education';
      case SavingsCategory.BUSINESS:
        return 'Business';
      case SavingsCategory.TRAVEL:
        return 'Travel';
      case SavingsCategory.OTHER:
        return 'Other';
    }
  }

  Future<void> _selectDate(
    BuildContext context,
    CreateSavingsGoalState state,
    CreateSavingsGoalViewModel notifier,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          state.targetDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      notifier.setTargetDate(picked);
    }
  }

  Future<void> _save(CreateSavingsGoalViewModel notifier) async {
    final goal = await notifier.save();
    if (goal != null && mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createSavingsGoalViewModelProvider);
    final notifier = ref.read(createSavingsGoalViewModelProvider.notifier);

    final isFormValid = state.name.trim().isNotEmpty &&
        state.targetAmountString.trim().isNotEmpty &&
        state.targetAmountString != '0';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'New Savings Dream',
          style: AppTextStyles.titleLarge(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'What is your next big purchase? 💭',
              style: AppTextStyles.titleMedium(context),
            ),
            const SizedBox(height: AppSizes.spacing20),

            // Dream Name Input
            AppTextField(
              controller: _nameController,
              label: AppLocalizations.of(context)!.dreamName,
              hint: AppLocalizations.of(context)!.dreamNameHint,
              errorText: state.nameError,
              maxLength: 100,
              onChanged: (value) => notifier.setName(value),
            ),
            const SizedBox(height: AppSizes.spacing16),

            // Target Amount Input
            AppTextField(
              controller: _amountController,
              label: AppLocalizations.of(context)!.targetAmountRupees,
              hint: AppLocalizations.of(context)!.enterAmountRupees,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              errorText: state.targetAmountError,
              onChanged: (value) => notifier.setTargetAmountString(value),
            ),
            const SizedBox(height: AppSizes.spacing20),

            // Category Chips Selection
            Text(
              'Select Category',
              style: AppTextStyles.labelLarge(context),
            ),
            const SizedBox(height: AppSizes.spacing8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: SavingsCategory.values.map((cat) {
                final isSelected = state.category == cat;
                return ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_getCategoryEmoji(cat)),
                      const SizedBox(width: 4),
                      Text(_getCategoryName(cat)),
                    ],
                  ),
                  selected: isSelected,
                  selectedColor: AppColors.primaryLight,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.onSurfaceMuted,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.outline.withValues(alpha: 0.5),
                  ),
                  backgroundColor: AppColors.card,
                  onSelected: (selected) {
                    if (selected) {
                      notifier.setCategory(cat);
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSizes.spacing20),

            // Target Date Selection
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Date (Optional)',
                        style: AppTextStyles.labelLarge(context),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.targetDate == null
                            ? 'No deadline set'
                            : 'Reach by: ${state.targetDate!.day}/${state.targetDate!.month}/${state.targetDate!.year}',
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: AppColors.onSurfaceMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(state.targetDate == null ? 'Set Date' : 'Change'),
                  onPressed: () => _selectDate(context, state, notifier),
                ),
                if (state.targetDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => notifier.setTargetDate(null),
                  ),
              ],
            ),
            if (state.targetDateError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 12),
                child: Text(
                  state.targetDateError!,
                  style:
                      AppTextStyles.bodyMedium(context, color: AppColors.error),
                ),
              ),
            const SizedBox(height: AppSizes.spacing16),

            // Notes Input
            AppTextField(
              controller: _notesController,
              label: AppLocalizations.of(context)!.notesDescriptionOptional,
              hint: AppLocalizations.of(context)!.whyDreamImportant,
              maxLength: 200,
              onChanged: (value) => notifier.setNotes(value),
            ),
            const SizedBox(height: AppSizes.spacing32),

            if (state.saveError != null) ...[
              Text(
                localizeError(context, state.saveError),
                style:
                    AppTextStyles.bodyMedium(context, color: AppColors.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacing12),
            ],

            // Save Button
            AppButton(
              label: AppLocalizations.of(context)!.saveDream,
              isLoading: state.isSaving,
              onPressed:
                  isFormValid && !state.isSaving ? () => _save(notifier) : null,
            ),
          ],
        ),
      ),
    );
  }
}
