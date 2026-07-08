import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/widgets.dart';
import 'package:pocket_plus/core/errors/error_localizer.dart';
import 'invoice_view_model.dart';

class CreateInvoiceScreen extends ConsumerStatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  ConsumerState<CreateInvoiceScreen> createState() =>
      _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends ConsumerState<CreateInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceViewModelProvider);
    final notifier = ref.read(invoiceViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.newInvoice),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          tooltip: AppLocalizations.of(context)!.close,
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCustomerSection(state, notifier),
            const SizedBox(height: AppSizes.spacing24),
            _buildLineItemsSection(state, notifier),
            const SizedBox(height: AppSizes.spacing24),
            _buildSummaryFooter(context, state, notifier),
            const SizedBox(height: AppSizes.spacing16),
            _buildNotesSection(state, notifier),
            const SizedBox(height: AppSizes.spacing24),
            AppButton(
              label: AppLocalizations.of(context)!.saveAsDraft,
              isLoading: state.isSaving,
              onPressed: state.isSaving ? null : () => _save(notifier),
            ),
            if (state.saveError != null) ...[
              const SizedBox(height: AppSizes.spacing12),
              Text(
                localizeError(context, state.saveError),
                style: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.error,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppSizes.spacing32),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSection(
    InvoiceFormState state,
    InvoiceViewModel notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.customer,
            style: AppTextStyles.titleMedium(context)),
        const SizedBox(height: AppSizes.spacing12),
        AppTextField(
          label: AppLocalizations.of(context)!.customerNameRequired,
          hint: AppLocalizations.of(context)!.fullName,
          errorText: state.customerNameError,
          onChanged: (v) => notifier.setCustomerName(v),
        ),
        const SizedBox(height: AppSizes.spacing12),
        AppTextField(
          label: AppLocalizations.of(context)!.phoneOptional,
          hint: AppLocalizations.of(context)!.phoneHintIndian,
          errorText: state.customerPhoneError,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          onChanged: (v) => notifier.setCustomerPhone(v),
        ),
        const SizedBox(height: AppSizes.spacing12),
        Row(
          children: [
            Expanded(
              child: _DateField(
                label: AppLocalizations.of(context)!.issueDate,
                date: state.issueDate,
                onChanged: (d) => notifier.setIssueDate(d),
              ),
            ),
            const SizedBox(width: AppSizes.spacing12),
            Expanded(
              child: _DateField(
                label: AppLocalizations.of(context)!.dueDateOptional,
                date: state.dueDate,
                onChanged: (d) => notifier.setDueDate(d),
                optional: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineItemsSection(
    InvoiceFormState state,
    InvoiceViewModel notifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.lineItems,
                style: AppTextStyles.titleMedium(context)),
            IconButton(
              tooltip: AppLocalizations.of(context)!.addLineItem,
              icon: const Icon(Icons.add_circle_outline),
              color: AppColors.primary,
              onPressed: notifier.addLineItem,
            ),
          ],
        ),
        ...state.lineItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return _LineItemCard(
            index: index,
            item: item,
            canRemove: state.lineItems.length > 1,
            notifier: notifier,
          );
        }),
      ],
    );
  }

  Widget _buildSummaryFooter(
    BuildContext context,
    InvoiceFormState state,
    InvoiceViewModel notifier,
  ) {
    final subtotal = notifier.subtotal;
    final totalGst = notifier.totalGst;
    final grandTotal = notifier.grandTotal;

    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.spacing12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          _SummaryRow(
              label: AppLocalizations.of(context)!.subtotal, amount: subtotal),
          if (totalGst > 0)
            _SummaryRow(
                label: AppLocalizations.of(context)!.gstTotal,
                amount: totalGst),
          _SummaryRow(
            label: AppLocalizations.of(context)!.discount,
            amount: state.discount,
            isNegative: true,
          ),
          const Divider(),
          _SummaryRow(
            label: AppLocalizations.of(context)!.grandTotal,
            amount: grandTotal,
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(
    InvoiceFormState state,
    InvoiceViewModel notifier,
  ) {
    return AppTextField(
      label: AppLocalizations.of(context)!.notesOptional,
      maxLength: 1000,
      onChanged: (v) => notifier.setNotes(v),
    );
  }

  Future<void> _save(InvoiceViewModel notifier) async {
    final invoice = await notifier.saveAsDraft();
    if (invoice != null && mounted) {
      context.go('/invoices/${invoice.id}');
    }
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.onChanged,
    this.optional = false,
  });

  final String label;
  final DateTime? date;
  final ValueChanged<DateTime> onChanged;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.spacing16,
          vertical: AppSizes.spacing12,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.spacing8),
          border: Border.all(color: AppColors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.onSurfaceMuted,
              ),
            ),
            const SizedBox(height: AppSizes.spacing4),
            Text(
              date != null
                  ? DateFormat('d MMM yyyy').format(date!)
                  : AppLocalizations.of(context)!.selectDate,
              style: AppTextStyles.bodyLarge(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineItemCard extends StatelessWidget {
  const _LineItemCard({
    required this.index,
    required this.item,
    required this.canRemove,
    required this.notifier,
  });

  final int index;
  final InvoiceLineItemForm item;
  final bool canRemove;
  final InvoiceViewModel notifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.spacing12),
      padding: const EdgeInsets.all(AppSizes.spacing12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.spacing12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.itemNumber(index + 1),
                  style: AppTextStyles.labelSmall(context),
                ),
              ),
              if (canRemove)
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: AppColors.error,
                    size: 20,
                  ),
                  onPressed: () => notifier.removeLineItem(index),
                ),
            ],
          ),
          AppTextField(
            hint: AppLocalizations.of(context)!.descriptionRequired,
            errorText: item.descriptionError,
            onChanged: (v) => notifier.updateLineItemDescription(index, v),
          ),
          const SizedBox(height: AppSizes.spacing8),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  hint: AppLocalizations.of(context)!.qtyHint,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => notifier.updateLineItemQuantity(index, v),
                ),
              ),
              const SizedBox(width: AppSizes.spacing8),
              Expanded(
                child: AppTextField(
                  hint: AppLocalizations.of(context)!.unitPrice,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => notifier.updateLineItemUnitPrice(index, v),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing8),
          Row(
            children: [
              _GstDropdown(
                value: item.gstPercent,
                onChanged: (v) => notifier.updateLineItemGst(index, v),
              ),
              const SizedBox(width: AppSizes.spacing16),
              Text(
                AppLocalizations.of(context)!.lineTotalArg(
                    CurrencyFormatter.formatRupees(item.lineTotal)),
                style: AppTextStyles.bodyMedium(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GstDropdown extends StatelessWidget {
  const _GstDropdown({
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.spacing8),
        border: Border.all(color: AppColors.outline),
      ),
      child: DropdownButton<double>(
        value: value,
        underline: const SizedBox(),
        items: [
          DropdownMenuItem(
              value: 0.0,
              child: Text(AppLocalizations.of(context)!.gstPercent(0))),
          DropdownMenuItem(
              value: 5.0,
              child: Text(AppLocalizations.of(context)!.gstPercent(5))),
          DropdownMenuItem(
              value: 12.0,
              child: Text(AppLocalizations.of(context)!.gstPercent(12))),
          DropdownMenuItem(
              value: 18.0,
              child: Text(AppLocalizations.of(context)!.gstPercent(18))),
          DropdownMenuItem(
              value: 28.0,
              child: Text(AppLocalizations.of(context)!.gstPercent(28))),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    this.isNegative = false,
    this.isBold = false,
  });

  final String label;
  final int amount;
  final bool isNegative;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? AppTextStyles.titleMedium(context)
                : AppTextStyles.bodyMedium(context),
          ),
          Text(
            '${isNegative ? '- ' : ''}${CurrencyFormatter.formatRupees(amount)}',
            style: isBold
                ? AppTextStyles.titleMedium(context)
                : AppTextStyles.bodyLarge(context),
          ),
        ],
      ),
    );
  }
}
