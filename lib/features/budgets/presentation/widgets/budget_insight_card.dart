import 'package:flutter/material.dart';

import 'package:pocket_plus/core/constants/app_colors.dart';
import 'package:pocket_plus/core/constants/app_sizes.dart';
import 'package:pocket_plus/core/constants/app_text_styles.dart';
import 'package:pocket_plus/shared/widgets/app_card.dart';

class BudgetInsightCard extends StatelessWidget {
  const BudgetInsightCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
    this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacing12),
      margin: const EdgeInsets.only(bottom: AppSizes.spacing8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.spacing8),
            ),
            child: Icon(icon, color: c, size: 18),
          ),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge(context)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: AppTextStyles.bodyMedium(context,
                        color: AppColors.onSurfaceMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
