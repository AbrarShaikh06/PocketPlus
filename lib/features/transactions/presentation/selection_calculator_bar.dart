import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import 'package:pocket_plus/l10n/app_localizations.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../home/presentation/home_providers.dart';
import 'selection_mode_provider.dart';

class SelectionCalculatorBar extends ConsumerWidget {
  const SelectionCalculatorBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectionModeProvider);
    final income = ref.watch(selectedIncomeProvider);
    final expense = ref.watch(selectedExpenseProvider);
    final net = ref.watch(selectedNetProvider);
    final isVisible = state.isActive && state.selectedIds.isNotEmpty;
    final hasIncome = income > 0;
    final hasExpense = expense > 0;
    final isMixed = hasIncome && hasExpense;
    final barHeight = isMixed ? 110.0 : 72.0;

    return ClipRect(
      child: AnimatedSlide(
        offset: isVisible ? Offset.zero : const Offset(0, 1),
        duration: isVisible
            ? const Duration(milliseconds: 250)
            : const Duration(milliseconds: 200),
        curve: isVisible ? Curves.easeOut : Curves.easeIn,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: barHeight,
          decoration: BoxDecoration(
            color: AppColors.card,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: isVisible
              ? isMixed
                  ? _MixedContent(
                      income: income,
                      expense: expense,
                      net: net,
                      count: state.selectedIds.length,
                    )
                  : _PureContent(
                      income: income,
                      expense: expense,
                      net: net,
                      count: state.selectedIds.length,
                    )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}

class _PureContent extends ConsumerWidget {
  const _PureContent({
    required this.income,
    required this.expense,
    required this.net,
    required this.count,
  });

  final int income;
  final int expense;
  final int net;
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIncome = income > 0;
    final total = isIncome ? income : expense;
    final label = isIncome
        ? AppLocalizations.of(context)!.totalIncomeSelected
        : AppLocalizations.of(context)!.totalExpensesSelected;
    final totalColor = isIncome ? AppColors.primary : AppColors.error;
    final formattedTotal = CurrencyFormatter.formatRupees(total);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(flex: 1),
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.countSelected(count.toString()),
                style: AppTextStyles.labelSmall(context),
              ),
              const Spacer(),
              Text(
                label,
                style: AppTextStyles.labelSmall(
                  context,
                  color: AppColors.onSurfaceMuted,
                ),
              ),
              const Spacer(),
              _ActionIcons(
                onShare: () =>
                    _share(context, ref, count, income, expense, net),
                onClose: () =>
                    ref.read(selectionModeProvider.notifier).exitMode(),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing4),
          Center(
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: formattedTotal));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.totalCopiedToClipboard,
                    ),
                  ),
                );
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                child: Text(
                  formattedTotal,
                  key: ValueKey(total),
                  style: AppTextStyles.displayLarge(context, color: totalColor),
                ),
              ),
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}

class _MixedContent extends ConsumerWidget {
  const _MixedContent({
    required this.income,
    required this.expense,
    required this.net,
    required this.count,
  });

  final int income;
  final int expense;
  final int net;
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing16,
        vertical: AppSizes.spacing12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                AppLocalizations.of(context)!.countSelected(count.toString()),
                style: AppTextStyles.labelSmall(context),
              ),
              const Spacer(),
              _ActionIcons(
                onShare: () =>
                    _share(context, ref, count, income, expense, net),
                onClose: () =>
                    ref.read(selectionModeProvider.notifier).exitMode(),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NetRow(
                  prefix: AppLocalizations.of(context)!.incomePrefixPlus,
                  amount: income,
                  color: AppColors.primary,
                ),
                _NetRow(
                  prefix: AppLocalizations.of(context)!.expensesPrefixMinus,
                  amount: expense,
                  color: AppColors.expense,
                ),
                _NetRow(
                  prefix: AppLocalizations.of(context)!.netPrefix,
                  amount: net,
                  color: net >= 0 ? AppColors.primary : AppColors.expense,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NetRow extends StatelessWidget {
  const _NetRow({
    required this.prefix,
    required this.amount,
    required this.color,
  });

  final String prefix;
  final int amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final formatted = CurrencyFormatter.formatRupees(amount);
    return Row(
      children: [
        Expanded(
          child: Text(
            '$prefix$formatted',
            style: AppTextStyles.bodyMedium(context, color: color),
          ),
        ),
      ],
    );
  }
}

class _ActionIcons extends StatelessWidget {
  const _ActionIcons({
    required this.onShare,
    required this.onClose,
  });

  final VoidCallback onShare;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onShare,
          child: const Icon(
            Icons.share,
            size: 20,
            color: AppColors.onSurfaceMuted,
          ),
        ),
        const SizedBox(width: AppSizes.spacing16),
        GestureDetector(
          onTap: onClose,
          child: const Icon(
            Icons.close,
            size: 20,
            color: AppColors.onSurfaceMuted,
          ),
        ),
      ],
    );
  }
}

void _share(
  BuildContext context,
  WidgetRef ref,
  int count,
  int income,
  int expense,
  int net,
) {
  final profile = ref.read(currentProfileProvider);
  final businessName = profile?.name ?? AppLocalizations.of(context)!.appName;
  final countLabel = count == 1
      ? AppLocalizations.of(context)!.transactionCountOne
      : AppLocalizations.of(context)!.transactionCountMany(count.toString());

  final text = '${AppLocalizations.of(context)!.shareSummaryTitle}\n'
      '$countLabel selected\n'
      '${AppLocalizations.of(context)!.shareIncomeLabel}${CurrencyFormatter.formatRupees(income)}\n'
      '${AppLocalizations.of(context)!.shareExpensesLabel}${CurrencyFormatter.formatRupees(expense)}\n'
      '${AppLocalizations.of(context)!.shareNetLabel}${CurrencyFormatter.formatRupees(net)}\n'
      '${AppLocalizations.of(context)!.shareFromBusiness(businessName)}';

  SharePlus.instance.share(ShareParams(text: text));
}
