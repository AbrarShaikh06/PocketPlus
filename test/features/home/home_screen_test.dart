import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pocket_plus/core/constants/app_colors.dart';
import 'package:pocket_plus/features/home/presentation/home_providers.dart';
import 'package:pocket_plus/features/home/presentation/home_screen.dart';
import 'package:pocket_plus/features/profiles/domain/entities/profile.dart';
import 'package:pocket_plus/features/reports/domain/entities/report_summary.dart';
import 'package:pocket_plus/shared/models/models.dart';
import '../../support/test_helpers.dart';

void main() {
  final now = DateTime.now();
  final currentMonth = DateTime(now.year, now.month, 1);
  const testProfile = Profile(
    id: 'p_test',
    userId: 'u_test',
    name: 'Test Profile',
    type: ProfileType.personal,
  );

  testWidgets('Positive profit renders green amount + correct MoM badge',
      (tester) async {
    final report = ReportSummary(
      totalIncome: 15000,
      totalExpense: 5000,
      netProfit: 10000,
      changePercent: 25.0,
      month: currentMonth,
      profileId: 'p_test',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentProfileProvider.overrideWithValue(testProfile),
          userProfilesProvider
              .overrideWith((ref) => Stream.value([testProfile])),
          categoriesProvider.overrideWith((ref) => Stream.value([])),
          recentTransactionsProvider.overrideWith((ref) => Stream.value([])),
          transactionsTodayProvider.overrideWith((ref) => Stream.value([])),
          homeMonthlyChartProvider
              .overrideWith((ref) => Stream.value([report])),
          reportSummaryProvider(currentMonth)
              .overrideWith((ref) => Stream.value(report)),
        ],
        child: testApp(const HomeScreen()),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    final rupeeText = find.text('₹');
    expect(rupeeText, findsOneWidget);

    final profitText = find.text('100.00');
    expect(profitText, findsOneWidget);

    final Text textWidget = tester.widget(profitText);
    expect(textWidget.style?.color, AppColors.primary);

    expect(find.text('+25.0% vs last month'), findsOneWidget);
  });

  testWidgets('Negative profit (loss) renders red amount', (tester) async {
    final report = ReportSummary(
      totalIncome: 5000,
      totalExpense: 12000,
      netProfit: -7000,
      changePercent: -15.0,
      month: currentMonth,
      profileId: 'p_test',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentProfileProvider.overrideWithValue(testProfile),
          userProfilesProvider
              .overrideWith((ref) => Stream.value([testProfile])),
          categoriesProvider.overrideWith((ref) => Stream.value([])),
          recentTransactionsProvider.overrideWith((ref) => Stream.value([])),
          transactionsTodayProvider.overrideWith((ref) => Stream.value([])),
          homeMonthlyChartProvider
              .overrideWith((ref) => Stream.value([report])),
          reportSummaryProvider(currentMonth)
              .overrideWith((ref) => Stream.value(report)),
        ],
        child: testApp(const HomeScreen()),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    final rupeeText = find.text('-₹');
    expect(rupeeText, findsOneWidget);

    final profitText = find.text('70.00');
    expect(profitText, findsOneWidget);

    final Text textWidget = tester.widget(profitText);
    expect(textWidget.style?.color, AppColors.error);
  });

  testWidgets('Empty state renders when no transactions exist', (tester) async {
    final report = ReportSummary(
      totalIncome: 0,
      totalExpense: 0,
      netProfit: 0,
      changePercent: 0.0,
      month: currentMonth,
      profileId: 'p_test',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentProfileProvider.overrideWithValue(testProfile),
          userProfilesProvider
              .overrideWith((ref) => Stream.value([testProfile])),
          categoriesProvider.overrideWith((ref) => Stream.value([])),
          recentTransactionsProvider.overrideWith((ref) => Stream.value([])),
          transactionsTodayProvider.overrideWith((ref) => Stream.value([])),
          homeMonthlyChartProvider.overrideWith((ref) => Stream.value([])),
          reportSummaryProvider(currentMonth)
              .overrideWith((ref) => Stream.value(report)),
        ],
        child: testApp(const HomeScreen()),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('No transactions yet'), findsOneWidget);
    expect(
      find.text('Add income or expenses to see report summary'),
      findsOneWidget,
    );
  });

  testWidgets('Skeleton shown while provider is loading', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentProfileProvider.overrideWithValue(null),
          userProfilesProvider.overrideWith((ref) => const Stream.empty()),
          categoriesProvider.overrideWith((ref) => const Stream.empty()),
          recentTransactionsProvider
              .overrideWith((ref) => const Stream.empty()),
          transactionsTodayProvider.overrideWith((ref) => const Stream.empty()),
          homeMonthlyChartProvider.overrideWith((ref) => const Stream.empty()),
          reportSummaryProvider(currentMonth)
              .overrideWith((ref) => const Stream.empty()),
        ],
        child: testApp(const HomeScreen()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
