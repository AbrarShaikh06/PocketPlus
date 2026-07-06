import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/budget.dart';
import '../budget_view_model.dart';
import '../providers/budget_providers.dart';
import '../budget_helpers.dart';

class CreateBudgetScreen extends ConsumerStatefulWidget {
  const CreateBudgetScreen({super.key, this.editBudgetId});

  final String? editBudgetId;

  @override
  ConsumerState<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends ConsumerState<CreateBudgetScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(createBudgetViewModelProvider);
    _nameController = TextEditingController(text: initial.name);
    _amountController = TextEditingController(text: initial.amountString);

    if (widget.editBudgetId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final budget = ref.read(budgetByIdProvider(widget.editBudgetId!));
        if (budget != null) {
          ref.read(createBudgetViewModelProvider.notifier).editFrom(budget);
        }
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createBudgetViewModelProvider);
    final notifier = ref.read(createBudgetViewModelProvider.notifier);

    ref.listen<CreateBudgetState>(createBudgetViewModelProvider, (prev, next) {
      if (prev?.name != next.name) {
        _nameController.text = next.name;
      }
      if (prev?.amountString != next.amountString) {
        _amountController.text = next.amountString;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(state.isEditing ? 'Edit Budget' : 'Create Budget'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Budget Name',
              hint: 'e.g. Monthly Groceries',
              errorText: state.nameError,
              onChanged: notifier.setName,
              controller: _nameController,
            ),
            const SizedBox(height: AppSizes.spacing16),
            AppTextField(
              label: 'Amount (₹)',
              hint: 'e.g. 10000',
              keyboardType: TextInputType.number,
              errorText: state.amountError,
              onChanged: notifier.setAmount,
              controller: _amountController,
            ),
            const SizedBox(height: AppSizes.spacing24),
            _periodSelector(context, state, notifier),
            const SizedBox(height: AppSizes.spacing16),
            _dateRangePicker(context, state, notifier),
            const SizedBox(height: AppSizes.spacing24),
            _sectionHeader(context, 'Appearance'),
            const SizedBox(height: AppSizes.spacing12),
            _colorPicker(context, state, notifier),
            const SizedBox(height: AppSizes.spacing16),
            _iconPicker(context, state, notifier),
            const SizedBox(height: AppSizes.spacing24),
            _sectionHeader(context, 'Alert'),
            const SizedBox(height: AppSizes.spacing12),
            _thresholdSlider(context, state, notifier),
            if (state.saveError != null) ...[
              const SizedBox(height: AppSizes.spacing12),
              Text(
                state.saveError!,
                style:
                    AppTextStyles.bodyMedium(context, color: AppColors.error),
              ),
            ],
            const SizedBox(height: AppSizes.spacing32),
            AppButton(
              label: state.isEditing ? 'Update Budget' : 'Create Budget',
              onPressed: () async {
                final success = await notifier.save();
                if (success && context.mounted) context.pop();
              },
              isLoading: state.isSaving,
            ),
            const SizedBox(height: AppSizes.spacing32),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.titleMedium(context, color: AppColors.onSurface),
    );
  }

  Widget _periodSelector(BuildContext context, CreateBudgetState state,
      CreateBudgetViewModel notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Period', style: AppTextStyles.labelLarge(context)),
        const SizedBox(height: AppSizes.spacing8),
        SegmentedButton<BudgetPeriod>(
          segments: [
            const ButtonSegment(
                value: BudgetPeriod.weekly, label: Text('Weekly')),
            const ButtonSegment(
                value: BudgetPeriod.monthly, label: Text('Monthly')),
            const ButtonSegment(
                value: BudgetPeriod.yearly, label: Text('Yearly')),
          ],
          selected: {state.period},
          onSelectionChanged: (set) => notifier.setPeriod(set.first),
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.onPrimary;
              }
              return null;
            }),
          ),
        ),
      ],
    );
  }

  Widget _dateRangePicker(BuildContext context, CreateBudgetState state,
      CreateBudgetViewModel notifier) {
    return Row(
      children: [
        Expanded(
          child: _dateButton(context, 'Start Date', state.startDate, () async {
            final date = await showDatePicker(
              context: context,
              initialDate: state.startDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
            );
            if (date != null) notifier.setStartDate(date);
          }),
        ),
        const SizedBox(width: AppSizes.spacing12),
        Expanded(
          child: _dateButton(context, 'End Date', state.endDate, () async {
            final date = await showDatePicker(
              context: context,
              initialDate: state.endDate ??
                  state.startDate.add(const Duration(days: 30)),
              firstDate: state.startDate,
              lastDate: DateTime(2035),
            );
            if (date != null) notifier.setEndDate(date);
          }),
        ),
      ],
    );
  }

  Widget _dateButton(
      BuildContext context, String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.spacing8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.spacing8),
            borderSide: const BorderSide(color: AppColors.outline),
          ),
        ),
        child: Text(
          date != null ? '${date.day}/${date.month}/${date.year}' : 'Not set',
          style: AppTextStyles.bodyMedium(context),
        ),
      ),
    );
  }

  Widget _colorPicker(BuildContext context, CreateBudgetState state,
      CreateBudgetViewModel notifier) {
    return Wrap(
      spacing: AppSizes.spacing8,
      runSpacing: AppSizes.spacing8,
      children: BudgetHelpers.brandColors.map((hex) {
        final isSelected = state.colorHex == hex;
        final color = BudgetHelpers.parseBudgetColor(hex);
        return Padding(
          padding: const EdgeInsets.all(4),
          child: GestureDetector(
            onTap: () => notifier.setColorHex(hex),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: AppColors.onSurface, width: 3)
                    : null,
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _iconPicker(BuildContext context, CreateBudgetState state,
      CreateBudgetViewModel notifier) {
    const icons = [
      'account_balance_wallet',
      'restaurant',
      'directions_car',
      'home',
      'shopping_cart',
      'flight',
      'local_gas_station',
      'medical_services',
      'school',
      'work',
      'sports_esports',
      'subscriptions',
      'movie',
      'checkroom',
      'pets',
      'fitness_center',
    ];

    return Wrap(
      spacing: AppSizes.spacing8,
      runSpacing: AppSizes.spacing8,
      children: icons.map((iconName) {
        final isSelected = state.icon == iconName;
        return Padding(
          padding: const EdgeInsets.all(2),
          child: GestureDetector(
            onTap: () => notifier.setIcon(iconName),
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : AppColors.card,
                borderRadius: BorderRadius.circular(AppSizes.spacing8),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.outline,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Icon(
                BudgetHelpers.budgetIconData(iconName),
                color: isSelected ? AppColors.primary : AppColors.onSurface,
                size: 22,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _thresholdSlider(BuildContext context, CreateBudgetState state,
      CreateBudgetViewModel notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alert at ${state.alertThreshold.round()}%',
            style: AppTextStyles.labelLarge(context)),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            thumbColor: AppColors.primary,
            inactiveTrackColor: AppColors.outline.withValues(alpha: 0.3),
          ),
          child: Slider(
            value: state.alertThreshold,
            min: 50,
            max: 100,
            divisions: 10,
            label: '${state.alertThreshold.round()}%',
            onChanged: notifier.setAlertThreshold,
          ),
        ),
      ],
    );
  }
}
