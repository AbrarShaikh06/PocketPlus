import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../shared/widgets/widgets.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/entities/invoice.dart';
import '../invoice_providers.dart';

class InvoiceDetailScreen extends ConsumerStatefulWidget {
  const InvoiceDetailScreen({
    required this.invoiceId,
    super.key,
  });

  final String invoiceId;

  @override
  ConsumerState<InvoiceDetailScreen> createState() =>
      _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends ConsumerState<InvoiceDetailScreen> {
  Invoice? _invoice;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupSubscription();
  }

  void _setupSubscription() {
    final profile = ref.read(currentProfileProvider);
    if (profile == null) return;

    ref
        .read(invoiceRepositoryProvider)
        .watchInvoices(userId: profile.userId, profileId: profile.id)
        .listen((invoices) {
      final match = invoices.where((i) => i.id == widget.invoiceId).firstOrNull;
      if (mounted) {
        setState(() {
          _invoice = match;
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(_invoice?.invoiceNumber ??
            AppLocalizations.of(context)!.invoiceTitle),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: _isLoading
          ? const LoadingShimmer()
          : _invoice == null
              ? Center(
                  child: Text(AppLocalizations.of(context)!.invoiceNotFound))
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final invoice = _invoice!;
    final statusColor = switch (invoice.status) {
      InvoiceStatus.draft => AppColors.onSurfaceMuted,
      InvoiceStatus.sent => AppColors.orange,
      InvoiceStatus.paid => AppColors.primary,
      InvoiceStatus.partial => AppColors.orange,
      InvoiceStatus.cancelled => AppColors.error,
    };
    final l = AppLocalizations.of(context)!;
    final statusLabel = switch (invoice.status) {
      InvoiceStatus.draft => l.statusDraft,
      InvoiceStatus.sent => l.statusSent,
      InvoiceStatus.paid => l.statusPaid,
      InvoiceStatus.partial => l.statusPartial,
      InvoiceStatus.cancelled => l.statusCancelled,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status chip
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.spacing16,
                vertical: AppSizes.spacing4,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.spacing8),
              ),
              child: Text(
                statusLabel,
                style: AppTextStyles.titleMedium(context, color: statusColor),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.spacing16),

          // Invoice number and customer
          _InfoRow(label: l.invoiceTitle, value: invoice.invoiceNumber),
          _InfoRow(label: l.customer, value: invoice.customerName),
          if (invoice.customerPhone != null)
            _InfoRow(label: l.phone, value: invoice.customerPhone!),
          _InfoRow(
            label: l.issueDate,
            value: DateFormatter.display(invoice.issueDate),
          ),
          if (invoice.dueDate != null)
            _InfoRow(
              label: l.dueDate,
              value: DateFormatter.display(invoice.dueDate!),
            ),

          const SizedBox(height: AppSizes.spacing16),

          // Line items table
          Text(l.items, style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSizes.spacing8),
          ...invoice.lineItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.spacing4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.description,
                      style: AppTextStyles.bodyMedium(context),
                    ),
                  ),
                  Text(
                    '${item.quantity}x ${CurrencyFormatter.formatRupees(item.unitPrice)}',
                    style: AppTextStyles.bodyMedium(
                      context,
                      color: AppColors.onSurfaceMuted,
                    ),
                  ),
                  const SizedBox(width: AppSizes.spacing8),
                  Text(
                    CurrencyFormatter.formatRupees(item.lineTotal),
                    style: AppTextStyles.bodyLarge(context),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: AppSizes.spacing16),

          // Totals
          _SummaryRow(label: l.subtotal, amount: invoice.subtotal),
          if (invoice.totalGst > 0)
            _SummaryRow(label: l.gstTotal, amount: invoice.totalGst),
          if (invoice.discount > 0)
            _SummaryRow(
              label: l.discount,
              amount: invoice.discount,
              isNegative: true,
            ),
          const Divider(),
          _SummaryRow(
            label: l.grandTotal,
            amount: invoice.grandTotal,
            isBold: true,
          ),

          if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
            const SizedBox(height: AppSizes.spacing16),
            Text(
              l.notesArg(invoice.notes!),
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.onSurfaceMuted,
              ),
            ),
          ],

          const SizedBox(height: AppSizes.spacing24),

          // Action buttons
          ..._buildActionButtons(invoice),

          const SizedBox(height: AppSizes.spacing32),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(Invoice invoice) {
    final l = AppLocalizations.of(context)!;
    switch (invoice.status) {
      case InvoiceStatus.draft:
        return [
          AppButton(
            label: l.markAsSent,
            onPressed: () => _markAsSent(),
          ),
          const SizedBox(height: AppSizes.spacing8),
          AppButton(
            label: l.edit,
            onPressed: () {},
            variant: AppButtonVariant.outline,
          ),
          const SizedBox(height: AppSizes.spacing8),
          AppButton(
            label: l.delete,
            onPressed: () => _deleteInvoice(),
            variant: AppButtonVariant.text,
          ),
        ];
      case InvoiceStatus.sent:
        return [
          AppButton(
            label: l.markAsPaid,
            onPressed: () => _confirmMarkAsPaid(invoice),
          ),
          const SizedBox(height: AppSizes.spacing8),
          AppButton(
            label: l.shareViaWhatsapp,
            onPressed: () => _sharePdf(invoice),
            variant: AppButtonVariant.outline,
          ),
        ];
      case InvoiceStatus.paid:
        return [
          AppButton(
            label: l.downloadPdf,
            onPressed: () => _sharePdf(invoice),
            variant: AppButtonVariant.outline,
          ),
        ];
      case InvoiceStatus.partial:
      case InvoiceStatus.cancelled:
        return [];
    }
  }

  Future<void> _markAsSent() async {
    final invoice = _invoice!;
    final updated = invoice.copyWith(
      status: InvoiceStatus.sent,
      updatedAt: DateTime.now(),
    );
    final result =
        await ref.read(invoiceRepositoryProvider).updateInvoice(updated);
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
      (_) {},
    );
  }

  Future<void> _deleteInvoice() async {
    final result = await ref
        .read(invoiceRepositoryProvider)
        .softDeleteInvoice(widget.invoiceId);
    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
      (_) {
        if (mounted) Navigator.of(context).pop();
      },
    );
  }

  void _confirmMarkAsPaid(Invoice invoice) {
    final l = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.markInvoicePaidTitle(invoice.invoiceNumber)),
        content: Text(
          l.markPaidIncomeBody(
              CurrencyFormatter.formatRupees(invoice.grandTotal)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _markAsPaid();
            },
            child: Text(l.markPaid),
          ),
        ],
      ),
    );
  }

  Future<void> _markAsPaid() async {
    final result =
        await ref.read(invoiceRepositoryProvider).markAsPaid(widget.invoiceId);

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.couldNotSave),
              action: SnackBarAction(
                label: AppLocalizations.of(context)!.retry,
                onPressed: _markAsPaid,
              ),
            ),
          );
        }
      },
      (_) {},
    );
  }

  Future<void> _sharePdf(Invoice invoice) async {
    try {
      // Paywalls removed: invoice PDF sharing is unconditional and free.
      await _doSharePdf(invoice);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> _doSharePdf(Invoice invoice) async {
    final pdf = await _generatePdf(invoice);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(pdf.path)],
        text: 'Invoice ${invoice.invoiceNumber} — ${invoice.customerName}',
      ),
    );
    ref.read(analyticsServiceProvider).logInvoiceShared();
  }

  Future<File> _generatePdf(Invoice invoice) async {
    final pdf = pw.Document();
    final df = DateFormat('d MMM yyyy');
    final businessName = ref.read(currentProfileProvider)?.name ?? 'Business';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  businessName,
                  style: const pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                pw.Text(
                  'INVOICE',
                  style: const pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 24,
                    color: PdfColors.green700,
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Invoice info
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Invoice No: ${invoice.invoiceNumber}'),
                  pw.Text('Issue Date: ${df.format(invoice.issueDate)}'),
                  if (invoice.dueDate != null)
                    pw.Text('Due Date: ${df.format(invoice.dueDate!)}'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Customer: ${invoice.customerName}'),
                  if (invoice.customerPhone != null)
                    pw.Text('Phone: ${invoice.customerPhone}'),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 25),

          // Line items table
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            columnWidths: const {
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(2),
              3: pw.FlexColumnWidth(1),
              4: pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey100),
                children: [
                  _pdfCell('Description', isHeader: true),
                  _pdfCell('Qty', isHeader: true),
                  _pdfCell('Rate', isHeader: true),
                  _pdfCell('GST', isHeader: true),
                  _pdfCell('Amount', isHeader: true),
                ],
              ),
              ...invoice.lineItems.map((item) {
                return pw.TableRow(
                  children: [
                    _pdfCell(item.description),
                    _pdfCell('${item.quantity}'),
                    _pdfCell(CurrencyFormatter.formatPdf(item.unitPrice)),
                    _pdfCell('${item.gstPercent}%'),
                    _pdfCell(CurrencyFormatter.formatPdf(item.lineTotal)),
                  ],
                );
              }),
            ],
          ),
          pw.SizedBox(height: 15),

          // Totals
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Subtotal:'),
                  if (invoice.totalGst > 0) pw.Text('GST:'),
                  if (invoice.discount > 0) pw.Text('Discount:'),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Grand Total:',
                    style: const pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(width: 40),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(CurrencyFormatter.formatPdf(invoice.subtotal)),
                  if (invoice.totalGst > 0)
                    pw.Text(CurrencyFormatter.formatPdf(invoice.totalGst)),
                  if (invoice.discount > 0)
                    pw.Text(
                      '-${CurrencyFormatter.formatPdf(invoice.discount)}',
                    ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    CurrencyFormatter.formatPdf(invoice.grandTotal),
                    style: const pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 16,
                      color: PdfColors.green700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text('Notes: ${invoice.notes}'),
          ],
        ],
        footer: (context) {
          final nowStr =
              DateFormat('d MMM yyyy hh:mm a').format(DateTime.now());
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 20),
            child: pw.Text(
              'Generated by PocketPlus — $nowStr',
              style: const pw.TextStyle(color: PdfColors.grey500, fontSize: 8),
            ),
          );
        },
      ),
    );

    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/Invoice_${invoice.invoiceNumber}_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _pdfCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          fontSize: isHeader ? 10 : 9,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacing4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium(
                context,
                color: AppColors.onSurfaceMuted,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyLarge(context)),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing2),
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
