import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../core/utils/whatsapp_utils.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../shared/widgets/widgets.dart';
import '../../home/presentation/home_providers.dart';
import '../domain/entities/khata_customer.dart';
import '../domain/entities/khata_entry.dart';
import '../khata_providers.dart';
import 'add_entry_bottom_sheet.dart';

class KhataCustomerDetailScreen extends ConsumerStatefulWidget {
  const KhataCustomerDetailScreen({
    required this.customerId,
    super.key,
  });

  final String customerId;

  @override
  ConsumerState<KhataCustomerDetailScreen> createState() =>
      _KhataCustomerDetailScreenState();
}

class _KhataCustomerDetailScreenState
    extends ConsumerState<KhataCustomerDetailScreen> {
  KhataCustomer? _customer;
  List<KhataEntry> _entries = [];
  bool _isLoading = true;
  StreamSubscription? _customerSub;
  StreamSubscription? _entriesSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupSubscriptions();
  }

  @override
  void dispose() {
    _customerSub?.cancel();
    _entriesSub?.cancel();
    super.dispose();
  }

  void _setupSubscriptions() {
    final profile = ref.read(currentProfileProvider);
    if (profile == null) return;

    final repository = ref.read(khataRepositoryProvider);

    _customerSub = repository
        .watchCustomers(userId: profile.userId, profileId: profile.id)
        .listen((customers) {
      final match =
          customers.where((c) => c.id == widget.customerId).firstOrNull;
      if (mounted) {
        setState(() => _customer = match);
      }
    });

    _entriesSub =
        repository.watchCustomerEntries(widget.customerId).listen((entries) {
      if (mounted) {
        setState(() {
          _entries = entries;
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
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: _isLoading
          ? const LoadingShimmer()
          : _customer == null
              ? Center(
                  child: Text(AppLocalizations.of(context)!.customerNotFound),
                )
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    final customer = _customer!;
    final balanceColor = customer.balance > 0
        ? AppColors.primary
        : customer.balance < 0
            ? AppColors.error
            : AppColors.onSurfaceMuted;

    final balanceLabel = customer.balance > 0
        ? AppLocalizations.of(context)!.customerOwesYou
        : customer.balance < 0
            ? AppLocalizations.of(context)!.youOweCustomer
            : AppLocalizations.of(context)!.settled;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSizes.spacing24),
          child: Column(
            children: [
              Text(
                customer.name,
                style: AppTextStyles.titleLarge(context),
              ),
              const SizedBox(height: AppSizes.spacing12),
              Text(
                CurrencyFormatter.formatRupees(customer.balance.abs()),
                style: AppTextStyles.displayHero(context, color: balanceColor),
              ),
              const SizedBox(height: AppSizes.spacing4),
              Text(
                balanceLabel,
                style: AppTextStyles.bodyMedium(
                  context,
                  color: AppColors.onSurfaceMuted,
                ),
              ),
              if (customer.phone != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSizes.spacing4),
                  child: Text(
                    customer.phone!,
                    style: AppTextStyles.bodyMedium(
                      context,
                      color: AppColors.onSurfaceMuted,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  label: AppLocalizations.of(context)!.giveCredit,
                  onPressed: () => _showAddEntrySheet(true),
                  icon: Icons.add_circle_outline,
                ),
              ),
              const SizedBox(width: AppSizes.spacing12),
              Expanded(
                child: AppButton(
                  label: AppLocalizations.of(context)!.recordRepayment,
                  onPressed: () => _showAddEntrySheet(false),
                  icon: Icons.remove_circle_outline,
                  variant: AppButtonVariant.outline,
                ),
              ),
            ],
          ),
        ),
        if (customer.phone != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.spacing16,
              AppSizes.spacing12,
              AppSizes.spacing16,
              0,
            ),
            child: AppButton(
              label: AppLocalizations.of(context)!.whatsappReminder,
              onPressed: () => _sendWhatsAppReminder(customer),
              icon: Icons.chat,
              variant: AppButtonVariant.text,
            ),
          ),
        const SizedBox(height: AppSizes.spacing16),
        Expanded(
          child: _entries.isEmpty
              ? EmptyState(message: AppLocalizations.of(context)!.noEntriesYet)
              : _buildEntriesList(),
        ),
      ],
    );
  }

  void _showAddEntrySheet(bool isCredit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddEntryBottomSheet(
        customerId: widget.customerId,
        isCredit: isCredit,
      ),
    );
  }

  void _sendWhatsAppReminder(KhataCustomer customer) {
    final businessName = ref.read(currentProfileProvider)?.name ??
        AppLocalizations.of(context)!.business;

    final message = AppLocalizations.of(context)!.whatsappReminderTemplate(
      CurrencyFormatter.formatRupees(customer.balance.abs()),
      businessName,
      customer.name,
    );
    final whatsappUrl = buildWhatsAppUrl(customer.phone, message);

    if (whatsappUrl == null) return;

    ref.read(analyticsServiceProvider).logKhataReminderSent(
          balanceInPaise: customer.balance,
        );

    launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
  }

  Widget _buildEntriesList() {
    final grouped = <String, List<KhataEntry>>{};
    for (final entry in _entries) {
      final key = DateFormatter.toIso(entry.entryDate);
      grouped.putIfAbsent(key, () => []).add(entry);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
      children: sortedKeys.map((dateKey) {
        final dateEntries = grouped[dateKey]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.spacing8),
              child: Text(
                DateFormatter.groupHeader(DateTime.parse(dateKey)),
                style: AppTextStyles.labelSmall(context),
              ),
            ),
            ...dateEntries.map((entry) => _EntryTile(entry: entry)),
          ],
        );
      }).toList(),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry});

  final KhataEntry entry;

  @override
  Widget build(BuildContext context) {
    final isCredit = entry.entryType == KhataEntryType.creditGiven;
    final amountColor = isCredit ? AppColors.primary : AppColors.error;
    final prefix = isCredit ? '+' : '-';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.spacing4),
      child: Row(
        children: [
          Icon(
            isCredit ? Icons.arrow_upward : Icons.arrow_downward,
            color: amountColor,
            size: 18,
          ),
          const SizedBox(width: AppSizes.spacing8),
          Expanded(
            child: Text(
              entry.note ??
                  (isCredit
                      ? AppLocalizations.of(context)!.creditGiven
                      : AppLocalizations.of(context)!.repaymentReceived),
              style: AppTextStyles.bodyMedium(context),
            ),
          ),
          Text(
            '$prefix${CurrencyFormatter.formatRupees(entry.amount)}',
            style: AppTextStyles.bodyLarge(context, color: amountColor),
          ),
        ],
      ),
    );
  }
}
