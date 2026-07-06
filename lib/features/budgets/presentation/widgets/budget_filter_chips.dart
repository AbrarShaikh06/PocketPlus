import 'package:flutter/material.dart';

import 'package:pocket_plus/core/constants/app_colors.dart';
import 'package:pocket_plus/core/constants/app_sizes.dart';
import 'package:pocket_plus/core/constants/app_text_styles.dart';
import 'package:pocket_plus/features/budgets/domain/entities/budget.dart';

class BudgetFilterChips extends StatelessWidget {
  const BudgetFilterChips({
    required this.selectedPeriod,
    required this.onSelected,
    super.key,
  });

  final BudgetPeriod? selectedPeriod;
  final void Function(BudgetPeriod?) onSelected;

  static const _periods = <BudgetPeriod?>[
    null,
    BudgetPeriod.weekly,
    BudgetPeriod.monthly,
    BudgetPeriod.yearly
  ];

  String _label(BudgetPeriod? period) {
    switch (period) {
      case null:
        return 'All';
      case BudgetPeriod.weekly:
        return 'Weekly';
      case BudgetPeriod.monthly:
        return 'Monthly';
      case BudgetPeriod.yearly:
        return 'Yearly';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
      child: Row(
        children: _periods.map((period) {
          final isSelected = selectedPeriod == period;
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.spacing8),
            child: FilterChip(
              label: Text(
                _label(period),
                style: AppTextStyles.labelLarge(
                  context,
                  color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onSelected(period),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.card,
              checkmarkColor: AppColors.onPrimary,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.outline,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
