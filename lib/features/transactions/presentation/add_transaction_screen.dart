import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:pocket_plus/l10n/app_localizations.dart';
import 'package:pocket_plus/core/errors/error_localizer.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/app_button.dart';
import '../../categories/domain/entities/category.dart';
import 'add_transaction_view_model.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _noteController.addListener(_onNoteChanged);
  }

  @override
  void dispose() {
    _noteController.removeListener(_onNoteChanged);
    _noteController.dispose();
    super.dispose();
  }

  void _onNoteChanged() {
    ref
        .read(addTransactionViewModelProvider.notifier)
        .changeNote(_noteController.text);
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'restaurant':
        return Icons.restaurant;
      case 'work':
        return Icons.work;
      case 'home':
        return Icons.home;
      case 'inventory':
        return Icons.inventory_2;
      case 'bolt':
        return Icons.bolt;
      case 'directions_bus':
        return Icons.directions_bus;
      case 'medical_services':
        return Icons.medical_services;
      case 'people':
        return Icons.people;
      case 'monetization_on':
        return Icons.monetization_on;
      case 'add_circle':
        return Icons.add_circle;
      case 'remove_circle':
        return Icons.remove_circle;
      case 'help_outline':
        return Icons.help_outline;
      default:
        return Icons.receipt_long;
    }
  }

  void _showCategoryPicker(
    BuildContext context,
    WidgetRef ref,
    List<Category> categories,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.spacing24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.selectCategory,
                style: AppTextStyles.titleMedium(context),
              ),
              const SizedBox(height: AppSizes.spacing16),
              if (categories.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.category_outlined,
                          size: 48,
                          color: AppColors.onSurfaceMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          AppLocalizations.of(context)!.noCategoriesFound,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: AppColors.onSurfaceMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(addTransactionViewModelProvider.notifier)
                              .selectCategory(cat.id);
                          Navigator.of(context).pop();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: Icon(
                                _getIconData(cat.icon),
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cat.name,
                              style: AppTextStyles.labelSmall(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    final state = ref.read(addTransactionViewModelProvider);
    final isDirty = state.amountString != '0' ||
        state.note.isNotEmpty ||
        state.selectedCategoryId != null;

    if (isDirty) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.discardChangesTitle),
          content: Text(AppLocalizations.of(context)!.discardChangesMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.keepEditing),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context)!.discard),
            ),
          ],
        ),
      );
      return discard ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addTransactionViewModelProvider);

    // Sync note controller value when note changes outside of typing (e.g. from voice pre-fill)
    ref.listen(addTransactionViewModelProvider.select((s) => s.note),
        (previous, next) {
      if (next != _noteController.text) {
        _noteController.text = next;
      }
    });

    // Handle ocr errors
    ref.listen(addTransactionViewModelProvider.select((s) => s.ocrError),
        (previous, next) {
      if (next != null) {
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.hideCurrentSnackBar();
        scaffold.showSnackBar(
          SnackBar(
            content: Text(localizeError(context, next)),
            duration: const Duration(seconds: 4),
          ),
        );
        ref.read(addTransactionViewModelProvider.notifier).clearOcrError();
      }
    });

    // Handle voice errors
    ref.listen(addTransactionViewModelProvider.select((s) => s.voiceError),
        (previous, next) {
      if (next != null) {
        final scaffold = ScaffoldMessenger.of(context);
        scaffold.hideCurrentSnackBar();
        scaffold.showSnackBar(
          SnackBar(
            content: Text(localizeError(context, next)),
            duration: const Duration(seconds: 4),
          ),
        );
        ref.read(addTransactionViewModelProvider.notifier).clearVoiceError();
      }
    });

    // Handle foreign currency detection pending dialog
    ref.listen(
        addTransactionViewModelProvider.select((s) => s.pendingOcrResult),
        (previous, next) {
      if (next != null && next.isForeignCurrency && previous != next) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) {
            return AlertDialog(
              title:
                  Text(AppLocalizations.of(context)!.foreignCurrencyDetected),
              content: Text(
                AppLocalizations.of(context)!.foreignCurrencyConvertMessage(
                  next.currencyCode ??
                      AppLocalizations.of(context)!.foreignCurrency,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    ref
                        .read(addTransactionViewModelProvider.notifier)
                        .rejectPendingOcrResult();
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.no),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(addTransactionViewModelProvider.notifier)
                        .acceptPendingOcrResult();
                    Navigator.of(dialogContext).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.yes),
                ),
              ],
            );
          },
        );
      }
    });

    // Handle save errors
    ref.listen(addTransactionViewModelProvider.select((s) => s.saveError),
        (previous, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeError(context, next))),
        );
      }
    });

    final amountColor = state.type == TransactionType.income
        ? AppColors.income
        : AppColors.expense;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.newTransaction,
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            tooltip: AppLocalizations.of(context)!.close,
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                context.pop();
              }
            },
          ),
          elevation: 0,
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spacing16,
              AppSizes.spacing20,
              AppSizes.spacing16,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Income/Expense Switcher (Income Left, Expense Right)
                CustomSegmentedControl(
                  selectedType: state.type,
                  onChanged: (newType) {
                    if (newType != state.type) {
                      ref
                          .read(addTransactionViewModelProvider.notifier)
                          .toggleType();
                    }
                  },
                ),
                const SizedBox(height: AppSizes.spacing12),

                // Amount Entry Section (Combined Card)
                Container(
                  padding: const EdgeInsets.all(AppSizes.spacing16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppSizes.radius16),
                    border: Border.all(
                      color: AppColors.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(bottom: AppSizes.spacing8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.outline.withValues(alpha: 0.3),
                              width: 2.0,
                            ),
                          ),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: BlinkingCursorAmount(
                            key: ValueKey(state.amountString),
                            amount: state.amountString,
                            color: amountColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing16),
                      _buildKeypad(context),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.spacing24),

                // Category Grid
                _buildCategoryGrid(context, state),
                const SizedBox(height: AppSizes.spacing24),

                // Scan Bill Button
                _buildScanButton(context, state),
                const SizedBox(height: AppSizes.spacing12),

                // Voice Entry Button (hold to speak)
                _buildVoiceButton(context, state),
                const SizedBox(height: AppSizes.spacing24),

                // Date Picker Card
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppSizes.radius12),
                    border: Border.all(
                      color: AppColors.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(AppSizes.radius12),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      leading: const Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                      ),
                      title: Text(AppLocalizations.of(context)!.date),
                      trailing: Text(
                        DateFormat('dd MMM yyyy').format(state.transactionDate),
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        ref
                            .read(addTransactionViewModelProvider.notifier)
                            .clearVoiceError();

                        final now = DateTime.now();
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: state.transactionDate,
                          firstDate: DateTime(now.year - 1),
                          lastDate: now.add(const Duration(days: 1)),
                        );
                        if (selectedDate != null) {
                          ref
                              .read(addTransactionViewModelProvider.notifier)
                              .changeDate(selectedDate);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spacing16),

                // Note Card
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppSizes.radius12),
                    border: Border.all(
                      color: AppColors.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.spacing12,
                  ),
                  child: TextField(
                    controller: _noteController,
                    maxLines: 1,
                    maxLength: 500,
                    style: AppTextStyles.bodyLarge(context),
                    decoration: InputDecoration(
                      icon:
                          const Icon(Icons.edit_note, color: AppColors.primary),
                      hintText: AppLocalizations.of(context)!.addNote,
                      border: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.spacing24),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(AppSizes.spacing16),
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border(
              top: BorderSide(
                color: AppColors.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: SafeArea(
            child: Builder(
              builder: (context) {
                final amount = double.tryParse(state.amountString) ?? 0.0;
                final canSave = amount > 0;
                developer.log(
                  '[AddTx.UI] rebuild | amount=$amount amountStr=${state.amountString} '
                  'category=${state.selectedCategoryId} canSave=$canSave',
                  name: 'PocketPlus.Debug',
                );
                return AppButton(
                  label: AppLocalizations.of(context)!.save,
                  icon: Icons.check_circle,
                  isLoading: state.isSaving,
                  onPressed: !canSave
                      ? null
                      : () async {
                          final success = await ref
                              .read(addTransactionViewModelProvider.notifier)
                              .saveTransaction();
                          if (success && context.mounted) {
                            HapticFeedback.mediumImpact();
                            context.pop();
                          }
                        },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad(BuildContext context) {
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
                      backgroundColor: AppColors.card,
                      foregroundColor: AppColors.onSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.radius8),
                        side: BorderSide(
                          color: AppColors.outline.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    onPressed: () {
                      ref
                          .read(addTransactionViewModelProvider.notifier)
                          .pressKey(key);
                    },
                    child: key == 'backspace'
                        ? const Icon(
                            Icons.backspace_outlined,
                            color: AppColors.primary,
                          )
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

  Widget _buildCategoryGrid(BuildContext context, AddTransactionState state) {
    final filtered =
        state.categories.where((c) => c.type == state.type).toList();
    final displayed = filtered.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.category,
          style: AppTextStyles.bodyLarge(context).copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurfaceMuted,
          ),
        ),
        const SizedBox(height: AppSizes.spacing8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.8,
          ),
          itemCount: displayed.length + 1,
          itemBuilder: (context, index) {
            if (index == displayed.length) {
              return InkWell(
                onTap: () => _showCategoryPicker(context, ref, filtered),
                borderRadius: BorderRadius.circular(AppSizes.radius12),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppSizes.radius12),
                    border: Border.all(
                      color: AppColors.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.more_horiz,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: AppSizes.spacing2),
                      Text(
                        AppLocalizations.of(context)!.more,
                        style: AppTextStyles.labelSmall(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurfaceMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final cat = displayed[index];
            final isSelected = state.selectedCategoryId == cat.id;

            return MockupCategoryChip(
              label: Text(cat.name),
              selected: isSelected,
              onSelected: (selected) {
                ref
                    .read(addTransactionViewModelProvider.notifier)
                    .selectCategory(cat.id);
              },
              customLayout: InkWell(
                onTap: () {
                  ref
                      .read(addTransactionViewModelProvider.notifier)
                      .selectCategory(cat.id);
                },
                borderRadius: BorderRadius.circular(AppSizes.radius12),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.secondaryLight : AppColors.card,
                    borderRadius: BorderRadius.circular(AppSizes.radius12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.secondary
                          : AppColors.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIconData(cat.icon),
                        color: isSelected
                            ? AppColors.secondary
                            : AppColors.primary,
                      ),
                      const SizedBox(height: AppSizes.spacing2),
                      Text(
                        cat.name,
                        style: AppTextStyles.labelSmall(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? AppColors.secondary
                              : AppColors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildScanButton(BuildContext context, AddTransactionState state) {
    return InkWell(
      onTap: state.isScanningReceipt
          ? null
          : () {
              ref.read(addTransactionViewModelProvider.notifier).scanReceipt();
            },
      borderRadius: BorderRadius.circular(AppSizes.radius12),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.radius12),
          border: Border.all(
            color: AppColors.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: state.isScanningReceipt
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.photo_camera, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.scanBill,
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.onSurfaceMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildVoiceButton(BuildContext context, AddTransactionState state) {
    final isActive = state.isRecording || state.isProcessingVoice;
    return GestureDetector(
      onLongPressStart: (_) =>
          ref.read(addTransactionViewModelProvider.notifier).startRecording(),
      onLongPressEnd: (_) =>
          ref.read(addTransactionViewModelProvider.notifier).stopRecording(),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryLight : AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.radius12),
          border: Border.all(
            color: AppColors.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Center(
          child: state.isProcessingVoice
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      state.isRecording ? Icons.mic : Icons.mic_none,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.holdToSpeak,
                      style: AppTextStyles.bodyMedium(context).copyWith(
                        color: AppColors.onSurfaceMuted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class CustomSegmentedControl extends StatelessWidget {
  final TransactionType selectedType;
  final ValueChanged<TransactionType> onChanged;

  const CustomSegmentedControl({
    required this.selectedType,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radius24),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.all(AppSizes.spacing4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(TransactionType.income),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSizes.spacing12),
                decoration: BoxDecoration(
                  color: selectedType == TransactionType.income
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSizes.radius24),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.income,
                  style: AppTextStyles.labelLarge(
                    context,
                    color: selectedType == TransactionType.income
                        ? Colors.white
                        : AppColors.onSurfaceMuted,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(TransactionType.expense),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSizes.spacing12),
                decoration: BoxDecoration(
                  color: selectedType == TransactionType.expense
                      ? AppColors.error
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppSizes.radius24),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.expense,
                  style: AppTextStyles.labelLarge(
                    context,
                    color: selectedType == TransactionType.expense
                        ? Colors.white
                        : AppColors.onSurfaceMuted,
                  ).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BlinkingCursorAmount extends StatefulWidget {
  final String amount;
  final Color color;

  const BlinkingCursorAmount({
    required this.amount,
    required this.color,
    super.key,
  });

  @override
  State<BlinkingCursorAmount> createState() => _BlinkingCursorAmountState();
}

class _BlinkingCursorAmountState extends State<BlinkingCursorAmount>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showPlaceholder = widget.amount == '0' || widget.amount.isEmpty;
    final textToDisplay = showPlaceholder ? '0.00' : widget.amount;
    final displayColor =
        showPlaceholder ? AppColors.onSurfaceMuted : widget.color;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '₹',
          style: AppTextStyles.displayLarge(context, color: displayColor),
        ),
        const SizedBox(width: 4),
        Text(
          textToDisplay,
          style: AppTextStyles.displayLarge(context, color: displayColor),
        ),
        FadeTransition(
          opacity: _opacity,
          child: Text(
            '|',
            style: AppTextStyles.displayLarge(context, color: displayColor),
          ),
        ),
      ],
    );
  }
}

class MockupCategoryChip extends ChoiceChip {
  final Widget customLayout;

  const MockupCategoryChip({
    required super.label,
    required super.selected,
    required super.onSelected,
    required this.customLayout,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return customLayout;
  }
}
