import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../shared/models/models.dart';
import '../../../shared/widgets/widgets.dart';
import '../../profiles/profiles_providers.dart';
import '../domain/entities/invoice.dart';
import 'invoice_view_model.dart';

class InvoiceListScreen extends ConsumerWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(userPlanProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.invoicesTitle),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: planAsync.when(
        data: (plan) {
          if (plan == PlanType.free) {
            return _buildUpgradePrompt(context);
          }
          return _buildInvoiceList(context, ref);
        },
        loading: () => const LoadingShimmer(),
        error: (_, __) => _buildInvoiceList(context, ref),
      ),
      floatingActionButton: planAsync.when(
        data: (plan) {
          if (plan == PlanType.free) return null;
          return FloatingActionButton(
            backgroundColor: AppColors.primary,
            onPressed: () => context.push('/invoices/new'),
            child: const Icon(Icons.add, color: AppColors.onPrimary),
          );
        },
        loading: () => null,
        error: (_, __) => FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => context.push('/invoices/new'),
          child: const Icon(Icons.add, color: AppColors.onPrimary),
        ),
      ),
    );
  }

  Widget _buildUpgradePrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 80,
              color: AppColors.onSurfaceMuted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSizes.spacing24),
            Text(
              AppLocalizations.of(context)!.invoiceFeatureBasic,
              style: AppTextStyles.titleMedium(
                context,
                color: AppColors.onSurfaceMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacing24),
            AppButton(
              label: AppLocalizations.of(context)!.seePlans,
              onPressed: () => context.push('/upgrade'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceList(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoiceListViewModelProvider);

    return invoicesAsync.when(
      data: (invoices) {
        if (invoices.isEmpty) {
          return _buildEmptyState(context);
        }
        return _buildGroupedList(context, invoices);
      },
      loading: () => const LoadingShimmer(),
      error: (e, _) => Center(
        child: Text(AppLocalizations.of(context)!.errorWithMessage('$e')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyState(
      message: AppLocalizations.of(context)!.createFirstInvoice,
      illustration: Icon(
        Icons.receipt_long_outlined,
        size: 80,
        color: AppColors.onSurfaceMuted.withValues(alpha: 0.5),
      ),
      ctaLabel: AppLocalizations.of(context)!.newInvoicePlus,
      onCtaPressed: () => context.push('/invoices/new'),
    );
  }

  Widget _buildGroupedList(BuildContext context, List<Invoice> invoices) {
    final sent = invoices.where((i) => i.status == InvoiceStatus.sent).toList();
    final draft =
        invoices.where((i) => i.status == InvoiceStatus.draft).toList();
    final paid = invoices.where((i) => i.status == InvoiceStatus.paid).toList();

    final l = AppLocalizations.of(context)!;
    final sections = <String, List<Invoice>>{};
    if (sent.isNotEmpty) sections[l.pendingPayment] = sent;
    if (draft.isNotEmpty) sections[l.drafts] = draft;
    if (paid.isNotEmpty) sections[l.paidSection] = paid;

    return ListView(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      children: sections.entries.map((section) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: AppSizes.spacing8,
                bottom: AppSizes.spacing8,
              ),
              child: Text(
                section.key,
                style: AppTextStyles.labelSmall(context),
              ),
            ),
            ...section.value.map((inv) => _InvoiceTile(invoice: inv)),
            const SizedBox(height: AppSizes.spacing16),
          ],
        );
      }).toList(),
    );
  }
}

class _InvoiceTile extends ConsumerWidget {
  const _InvoiceTile({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppCard(
      onTap: () => context.push('/invoices/${invoice.id}'),
      margin: const EdgeInsets.only(bottom: AppSizes.spacing8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: AppTextStyles.labelLarge(context),
                ),
                const SizedBox(height: AppSizes.spacing2),
                Text(
                  invoice.customerName,
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
                Text(
                  DateFormatter.display(invoice.issueDate),
                  style: AppTextStyles.bodyMedium(
                    context,
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.formatRupees(invoice.grandTotal),
                style: AppTextStyles.titleMedium(context),
              ),
              const SizedBox(height: AppSizes.spacing4),
              _StatusChip(status: invoice.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final (Color color, String label) = switch (status) {
      InvoiceStatus.draft => (AppColors.onSurfaceMuted, l.statusDraft),
      InvoiceStatus.sent => (AppColors.orange, l.statusSent),
      InvoiceStatus.paid => (AppColors.primary, l.statusPaid),
      InvoiceStatus.partial => (AppColors.orange, l.statusPartial),
      InvoiceStatus.cancelled => (AppColors.error, l.statusCancelled),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing8,
        vertical: AppSizes.spacing2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSizes.spacing4),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall(context, color: color),
      ),
    );
  }
}
