import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/currency_formatter.dart';
import '../../features/categories/domain/entities/category.dart';
import '../../features/transactions/domain/entities/transaction.dart';
import '../../shared/models/models.dart';

Color _parseColor(String? hex) {
  if (hex == null) return AppColors.primary;
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
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

Color _sourceColor(TransactionSource source) {
  switch (source) {
    case TransactionSource.manual:
      return AppColors.onSurfaceMuted;
    case TransactionSource.sms:
      return AppColors.blue;
    case TransactionSource.voice:
      return AppColors.orange;
    case TransactionSource.ocr:
      return AppColors.purple;
    case TransactionSource.recurring:
      return AppColors.teal;
    case TransactionSource.invoice:
      return AppColors.indigo;
    case TransactionSource.mpesa:
      return AppColors.green;
  }
}

class TransactionListTile extends StatefulWidget {
  const TransactionListTile({
    super.key,
    required this.transaction,
    required this.category,
    this.onTap,
    this.onLongPress,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.index = 0,
  });

  final Transaction transaction;
  final Category category;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isSelectionMode;
  final bool isSelected;
  final int index;

  @override
  State<TransactionListTile> createState() => _TransactionListTileState();
}

class _TransactionListTileState extends State<TransactionListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _appearController;
  late Animation<double> _appearOpacity;
  late Animation<Offset> _appearSlide;
  bool _entranceScheduled = false;

  @override
  void initState() {
    super.initState();
    _appearController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _appearOpacity = _appearController.drive(
      Tween<double>(begin: 0.0, end: 1.0).chain(
        CurveTween(curve: Curves.easeOut),
      ),
    );
    _appearSlide = _appearController.drive(
      Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).chain(
        CurveTween(curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_entranceScheduled) return;
    _entranceScheduled = true;

    // When the platform/test requests reduced motion, snap to the fully
    // visible state without scheduling a delayed timer — leaking timers makes
    // widget tests fail with "!timersPending".
    if (MediaQuery.disableAnimationsOf(context)) {
      _appearController.value = 1.0;
      return;
    }

    // Cap the stagger so items built after a scroll (high absolute index)
    // appear promptly instead of inheriting a multi-second delay.
    final staggerSteps = widget.index.clamp(0, 8);
    Future.delayed(Duration(milliseconds: 50 * staggerSteps), () {
      if (mounted) _appearController.forward();
    });
  }

  @override
  void dispose() {
    _appearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catColor = _parseColor(widget.category.colorHex);
    final isIncome = widget.transaction.type == TransactionType.income;
    final amountColor = isIncome ? AppColors.income : AppColors.expense;
    final dateStr =
        DateFormat('dd MMM yyyy').format(widget.transaction.transactionDate);
    final timeStr =
        DateFormat('h:mm a').format(widget.transaction.transactionDate);
    final title = widget.transaction.merchantName ??
        widget.transaction.note ??
        widget.category.name;

    final tile = InkWell(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      borderRadius: BorderRadius.circular(AppSizes.radius16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(AppSizes.spacing16),
        decoration: BoxDecoration(
          color: widget.isSelected && widget.isSelectionMode
              ? AppColors.primaryLight
              : AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.radius16),
          border: Border.all(color: AppColors.outline.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-0.2, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              },
              child: widget.isSelectionMode
                  ? SizedBox(
                      key: const ValueKey('checkbox'),
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Icon(
                          widget.isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: widget.isSelected
                              ? AppColors.primary
                              : AppColors.onSurfaceMuted,
                          size: 24,
                        ),
                      ),
                    )
                  : CircleAvatar(
                      key: const ValueKey('avatar'),
                      backgroundColor: catColor.withValues(alpha: 0.15),
                      child: Icon(
                        _getIconData(widget.category.icon),
                        color: catColor,
                        size: 20,
                      ),
                    ),
            ),
            const SizedBox(width: AppSizes.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge(context),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSizes.spacing4),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          widget.category.name,
                          style: AppTextStyles.labelSmall(context),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSizes.spacing8),
                      _SourceBadge(source: widget.transaction.source),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.spacing16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${isIncome ? '+' : '-'}'
                      '${CurrencyFormatter.format(widget.transaction.amount.abs())}',
                      style: AppTextStyles.titleMedium(
                        context,
                        color: amountColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.spacing4),
                Text(
                  dateStr,
                  style: AppTextStyles.labelSmall(context),
                ),
                Text(
                  timeStr,
                  style: AppTextStyles.labelSmall(
                    context,
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // Collapse the visually fragmented rows (title, category, source, amount,
    // date, time) into one coherent screen-reader announcement instead of six
    // disjointed reads.
    final amountStr = CurrencyFormatter.format(widget.transaction.amount.abs());
    final typeLabel = isIncome ? 'Income' : 'Expense';
    final selectionPrefix = widget.isSelectionMode
        ? (widget.isSelected ? 'Selected. ' : 'Not selected. ')
        : '';
    final semanticLabel = '$selectionPrefix$typeLabel, $amountStr, $title, '
        'category ${widget.category.name}, $dateStr at $timeStr';

    final semanticTile = Semantics(
      container: true,
      button: widget.onTap != null,
      selected: widget.isSelectionMode ? widget.isSelected : null,
      label: semanticLabel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      excludeSemantics: true,
      child: tile,
    );

    final disable = MediaQuery.disableAnimationsOf(context);
    if (disable) return semanticTile;

    return SlideTransition(
      position: _appearSlide,
      child: FadeTransition(
        opacity: _appearOpacity,
        child: semanticTile,
      ),
    );
  }
}

class _SourceBadge extends StatelessWidget {
  const _SourceBadge({required this.source});

  final TransactionSource source;

  @override
  Widget build(BuildContext context) {
    final color = _sourceColor(source);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.radius4),
      ),
      child: Text(
        source.name.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
