import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:pocket_plus/l10n/app_localizations.dart';

import '../../../core/utils/currency_formatter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/providers/firebase_providers.dart';
import '../../categories/domain/entities/category.dart';
import '../domain/entities/transaction.dart';
import '../../home/presentation/home_providers.dart';
import '../../../shared/models/models.dart';

final transactionDetailStreamProvider =
    StreamProvider.family<Transaction?, String>((ref, id) {
  return ref
      .watch(firestoreProvider)
      .collection('transactions')
      .doc(id)
      .snapshots()
      .map((snapshot) {
    if (!snapshot.exists || snapshot.data() == null) return null;
    final data = snapshot.data()!;
    data['id'] = snapshot.id;
    return Transaction.fromJson(data);
  });
});

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({required this.transactionId, super.key});

  final String transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txnAsync = ref.watch(transactionDetailStreamProvider(transactionId));
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.transactionDetails),
        backgroundColor: AppColors.card,
        elevation: 0,
      ),
      body: txnAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text(
            AppLocalizations.of(context)!.errorWithMessage(err.toString()),
          ),
        ),
        data: (transaction) {
          if (transaction == null) {
            return Center(
              child: Text(AppLocalizations.of(context)!.transactionNotFound),
            );
          }

          final categories = categoriesAsync.value ?? [];
          Category category;
          final catId = transaction.categoryId;
          if (catId != null && catId.startsWith('sys_unaccounted')) {
            category = Category(
              id: catId,
              name: 'Unaccounted',
              icon: 'help_outline',
              colorHex: '#9E9E9E',
              type: transaction.type,
            );
          } else {
            category = categories.firstWhere(
              (c) => c.id == catId,
              orElse: () => Category(
                id: catId ?? 'general',
                name: AppLocalizations.of(context)!.general,
                icon: 'receipt_long',
                colorHex: '#0D631B',
                userId: transaction.userId,
                type: transaction.type,
                createdAt: DateTime.now(),
              ),
            );
          }

          final isIncome = transaction.type == TransactionType.income;
          final amountColor = isIncome ? AppColors.income : AppColors.expense;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSizes.spacing24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Amount Header Card
                      Card(
                        color: AppColors.card,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: AppColors.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSizes.spacing24),
                          child: Column(
                            children: [
                              Text(
                                isIncome
                                    ? AppLocalizations.of(context)!
                                        .incomeUppercase
                                    : AppLocalizations.of(context)!
                                        .expenseUppercase,
                                style: AppTextStyles.labelSmall(
                                  context,
                                  color: amountColor,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: AppSizes.spacing12),
                              Text(
                                '${isIncome ? '+' : '-'}${CurrencyFormatter.formatRupees(transaction.amount)}',
                                style: AppTextStyles.displayLarge(
                                  context,
                                  color: amountColor,
                                ).copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: AppSizes.spacing12),
                              Text(
                                transaction.merchantName ?? category.name,
                                style: AppTextStyles.bodyLarge(context)
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.spacing24),

                      // Details Section
                      Text(
                        AppLocalizations.of(context)!.details,
                        style: AppTextStyles.titleMedium(context),
                      ),
                      const SizedBox(height: AppSizes.spacing12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.outline.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title:
                                  Text(AppLocalizations.of(context)!.category),
                              trailing: Text(category.name),
                              leading: const Icon(Icons.category_outlined),
                            ),
                            const Divider(height: 1, indent: 56),
                            ListTile(
                              title: Text(AppLocalizations.of(context)!.date),
                              trailing: Text(
                                DateFormat('dd MMM yyyy, hh:mm a')
                                    .format(transaction.transactionDate),
                              ),
                              leading:
                                  const Icon(Icons.calendar_today_outlined),
                            ),
                            const Divider(height: 1, indent: 56),
                            ListTile(
                              title: Text(AppLocalizations.of(context)!.source),
                              trailing:
                                  Text(transaction.source.name.toUpperCase()),
                              leading: const Icon(Icons.device_hub_outlined),
                            ),
                            if (transaction.note != null &&
                                transaction.note!.isNotEmpty) ...[
                              const Divider(height: 1, indent: 56),
                              ListTile(
                                title: Text(AppLocalizations.of(context)!.note),
                                subtitle: Text(transaction.note!),
                                leading: const Icon(Icons.notes_outlined),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
