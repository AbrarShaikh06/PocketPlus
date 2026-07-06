import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/widgets.dart';
import '../domain/entities/khata_customer.dart';
import 'add_khata_customer_bottom_sheet.dart';
import 'khata_view_model.dart';

class KhataListScreen extends ConsumerWidget {
  const KhataListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(khataListViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.khata),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: customersAsync.when(
        data: (customers) => customers.isEmpty
            ? _buildEmptyState(context, ref)
            : _buildCustomerList(context, customers),
        loading: () => const LoadingShimmer(),
        error: (e, _) => Center(
          child: Text(
            AppLocalizations.of(context)!.errorWithMessage(e.toString()),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddCustomerSheet(context, ref),
        child: const Icon(Icons.person_add, color: AppColors.onPrimary),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return EmptyState(
      message: AppLocalizations.of(context)!.addFirstCreditCustomer,
      illustration: Icon(
        Icons.people_alt_outlined,
        size: 80,
        color: AppColors.onSurfaceMuted.withValues(alpha: 0.5),
      ),
      ctaLabel: AppLocalizations.of(context)!.addCustomerButton,
      onCtaPressed: () => _showAddCustomerSheet(context, ref),
    );
  }

  void _showAddCustomerSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const AddKhataCustomerBottomSheet(),
    );
  }

  Widget _buildCustomerList(
    BuildContext context,
    List<KhataCustomer> customers,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      itemCount: customers.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSizes.spacing8),
      itemBuilder: (context, index) {
        final customer = customers[index];
        return _CustomerTile(customer: customer);
      },
    );
  }
}

class _CustomerTile extends ConsumerWidget {
  const _CustomerTile({required this.customer});

  final KhataCustomer customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceColor = customer.balance > 0
        ? AppColors.primary
        : customer.balance < 0
            ? AppColors.error
            : AppColors.onSurfaceMuted;

    return AppCard(
      onTap: () => context.push('/khata/${customer.id}'),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryLight,
            child: Text(
              customer.name[0].toUpperCase(),
              style: AppTextStyles.titleMedium(
                context,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  style: AppTextStyles.bodyLarge(context),
                ),
                if (customer.phone != null)
                  Text(
                    customer.phone!,
                    style: AppTextStyles.bodyMedium(
                      context,
                      color: AppColors.onSurfaceMuted,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.formatRupees(customer.balance),
            style: AppTextStyles.titleMedium(context, color: balanceColor),
          ),
        ],
      ),
    );
  }
}
