import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'khata_view_model.dart';

class AddEntryBottomSheet extends ConsumerStatefulWidget {
  const AddEntryBottomSheet({
    required this.customerId,
    required this.isCredit,
    super.key,
  });

  final String customerId;
  final bool isCredit;

  @override
  ConsumerState<AddEntryBottomSheet> createState() =>
      _AddEntryBottomSheetState();
}

class _AddEntryBottomSheetState extends ConsumerState<AddEntryBottomSheet> {
  @override
  void initState() {
    super.initState();
    ref.invalidate(addEntryViewModelProvider);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addEntryViewModelProvider);
    final notifier = ref.read(addEntryViewModelProvider.notifier);
    final title = widget.isCredit
        ? AppLocalizations.of(context)!.giveCredit
        : AppLocalizations.of(context)!.recordRepayment;

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
          Text(
            title,
            style: AppTextStyles.titleMedium(context),
          ),
          const SizedBox(height: AppSizes.spacing20),
          Center(
            child: Text(
              '₹ ${_formatAmount(state.amountString)}',
              style: AppTextStyles.displayLarge(context),
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
          const SizedBox(height: AppSizes.spacing20),
          _buildKeypad(context, notifier),
          const SizedBox(height: AppSizes.spacing16),
          AppTextField(
            hint: AppLocalizations.of(context)!.noteOptionalHint,
            maxLength: 500,
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
                  child: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSizes.spacing16),
          AppButton(
            label: widget.isCredit
                ? AppLocalizations.of(context)!.giveCredit
                : AppLocalizations.of(context)!.recordRepayment,
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

  Widget _buildKeypad(BuildContext context, AddEntryViewModel notifier) {
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

  Future<void> _save(AddEntryViewModel notifier) async {
    final success = await notifier.save(
      customerId: widget.customerId,
      isCredit: widget.isCredit,
    );

    if (success && mounted) {
      context.pop();
    } else if (mounted) {
      final state = ref.read(addEntryViewModelProvider);
      if (state.saveError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.saveError!),
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.retry,
              onPressed: () => _save(notifier),
            ),
          ),
        );
      }
    }
  }
}
