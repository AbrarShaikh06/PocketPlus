import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/loading_shimmer.dart';
import '../../../shared/models/models.dart';
import '../../categories/domain/entities/category.dart';
import '../domain/entities/parsed_sms.dart';
import '../../home/presentation/home_providers.dart';
import 'package:pocket_plus/core/errors/error_localizer.dart';
import 'capture_view_model.dart';

class CaptureConfirmationScreen extends ConsumerStatefulWidget {
  final ParsedSms parsedSms;

  const CaptureConfirmationScreen({
    required this.parsedSms,
    super.key,
  });

  @override
  ConsumerState<CaptureConfirmationScreen> createState() =>
      _CaptureConfirmationScreenState();
}

class _CaptureConfirmationScreenState
    extends ConsumerState<CaptureConfirmationScreen> {
  bool _isExpanded = false;
  late final TextEditingController _merchantController;

  @override
  void initState() {
    super.initState();
    _merchantController = TextEditingController(
      text: widget.parsedSms.merchantName ?? 'Unknown Merchant',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(captureViewModelProvider(widget.parsedSms).notifier)
          .init(widget.parsedSms);
      ref.read(analyticsServiceProvider).logSmsAutoCaptured(
            bank: widget.parsedSms.senderId,
            parsedSuccessfully: true,
          );
    });
  }

  @override
  void dispose() {
    _merchantController.dispose();
    super.dispose();
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
      default:
        return Icons.receipt_long;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(categoriesProvider);
    final state = ref.watch(captureViewModelProvider(widget.parsedSms));
    final isIncome = widget.parsedSms.type == TransactionType.income;

    final rawText = widget.parsedSms.rawSmsText;
    final bool needsTruncation = rawText.length > 200;
    final String displayedSmsText = needsTruncation && !_isExpanded
        ? '${rawText.substring(0, 200)}...'
        : rawText;

    final List<Category> displayedCategories = state.categories;
    final isMerchantEditable = widget.parsedSms.merchantName == null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          tooltip: AppLocalizations.of(context)!.close,
          icon: const Icon(Icons.close, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.autoCaptureBadge,
          style: AppTextStyles.labelLarge(context).copyWith(
            color: AppColors.primary.withValues(alpha: 0.6),
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing16,
            vertical: AppSizes.spacing8,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSizes.radius24),
              border:
                  Border.all(color: AppColors.outline.withValues(alpha: 0.15)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSizes.spacing12),
                  _buildSmsBanner(displayedSmsText, needsTruncation),
                  const SizedBox(height: AppSizes.spacing24),
                  _buildAmountSection(isIncome),
                  const SizedBox(height: AppSizes.spacing24),
                  _buildMerchantSection(isMerchantEditable),
                  const SizedBox(height: AppSizes.spacing24),
                  _buildCategorySection(state, displayedCategories),
                  const SizedBox(height: AppSizes.spacing32),
                  if (state.error != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppSizes.spacing16),
                      child: Text(
                        localizeError(context, state.error),
                        style: AppTextStyles.bodyMedium(
                          context,
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  _buildBottomActions(state),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmsBanner(String text, bool needsTruncation) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.spacing12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radius12),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.sms, color: Colors.white, size: 20),
          ),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: AppTextStyles.bodyMedium(context).copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (needsTruncation) ...[
                  const SizedBox(height: AppSizes.spacing4),
                  InkWell(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Text(
                      _isExpanded
                          ? AppLocalizations.of(context)!.showLess
                          : AppLocalizations.of(context)!.showMore,
                      style: AppTextStyles.labelLarge(context).copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection(bool isIncome) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.amountLabelUpper,
          style: AppTextStyles.labelSmall(context).copyWith(
            color: AppColors.secondary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: AppSizes.spacing4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '₹',
              style: AppTextStyles.titleLarge(context).copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              CurrencyFormatter.formatRupees(widget.parsedSms.amount),
              style: AppTextStyles.displayLarge(context).copyWith(
                color: isIncome ? AppColors.income : AppColors.expense,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMerchantSection(bool isMerchantEditable) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Text(
            AppLocalizations.of(context)!.paidToLabel,
            style: AppTextStyles.labelSmall(context).copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isMerchantEditable
                ? AppColors.surface
                : AppColors.outline.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSizes.radius12),
            border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing12),
          child: TextField(
            controller: _merchantController,
            readOnly: !isMerchantEditable,
            style: AppTextStyles.bodyLarge(context).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: const Icon(Icons.storefront, color: AppColors.secondary),
              hintText: AppLocalizations.of(context)!.enterMerchantName,
              hintStyle: const TextStyle(color: AppColors.onSurfaceMuted),
              enabled: isMerchantEditable,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(
    CaptureState state,
    List<Category> displayedCategories,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            AppLocalizations.of(context)!.selectCategoryUpper,
            style: AppTextStyles.labelSmall(context).copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        if (state.isLoadingCategories)
          Row(
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(right: AppSizes.spacing8),
                child: LoadingShimmer(
                  width: 100,
                  height: 40,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: displayedCategories.map((category) {
              return ChoiceChip(
                avatar: Icon(
                  _getIconData(category.icon),
                  size: 18,
                  color: state.selectedCategoryId == category.id
                      ? Colors.white
                      : AppColors.secondary,
                ),
                label: Text(category.name),
                labelStyle: AppTextStyles.labelLarge(context).copyWith(
                  color: state.selectedCategoryId == category.id
                      ? Colors.white
                      : AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
                selected: state.selectedCategoryId == category.id,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                side: BorderSide(
                  color: state.selectedCategoryId == category.id
                      ? AppColors.primary
                      : AppColors.outline.withValues(alpha: 0.3),
                ),
                shape: const StadiumBorder(),
                showCheckmark: false,
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(
                          captureViewModelProvider(widget.parsedSms).notifier,
                        )
                        .selectCategory(category.id);
                  }
                },
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildBottomActions(CaptureState state) {
    return Container(
      padding: const EdgeInsets.only(top: AppSizes.spacing16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.outline.withValues(alpha: 0.15)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            label: AppLocalizations.of(context)!.confirmEntry,
            icon: Icons.check_circle,
            isLoading: state.isSaving,
            onPressed: state.selectedCategoryId == null
                ? null
                : () async {
                    final success = await ref
                        .read(
                          captureViewModelProvider(widget.parsedSms).notifier,
                        )
                        .confirm(_merchantController.text);
                    if (success && mounted) {
                      Navigator.of(context).pop();
                    }
                  },
          ),
          const SizedBox(height: AppSizes.spacing12),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async {
                await ref
                    .read(captureViewModelProvider(widget.parsedSms).notifier)
                    .dismiss();
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                AppLocalizations.of(context)!.notABusinessTransaction,
                style: AppTextStyles.labelLarge(context).copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
