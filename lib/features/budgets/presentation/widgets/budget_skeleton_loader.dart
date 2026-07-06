import 'package:flutter/material.dart';

import 'package:pocket_plus/core/constants/app_sizes.dart';
import 'package:pocket_plus/shared/widgets/loading_shimmer.dart';

class BudgetSkeletonLoader extends StatelessWidget {
  const BudgetSkeletonLoader({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: AppSizes.spacing12),
          child: LoadingShimmer(
            height: 160,
            borderRadius: BorderRadius.all(Radius.circular(AppSizes.spacing12)),
          ),
        );
      }),
    );
  }
}
