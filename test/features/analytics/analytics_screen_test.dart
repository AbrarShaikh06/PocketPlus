import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pocket_plus/features/analytics/presentation/analytics_providers.dart';
import 'package:pocket_plus/features/analytics/presentation/analytics_screen.dart';
import 'package:pocket_plus/features/profiles/profiles_providers.dart';
import 'package:pocket_plus/features/reports/domain/entities/report_summary.dart';
import 'package:pocket_plus/shared/models/models.dart';

import '../../support/test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final now = DateTime.now();
  final currentMonth = DateTime(now.year, now.month, 1);
  final prevMonth = DateTime(now.year, now.month - 1, 1);

  final mockSummaries = [
    ReportSummary(
      totalIncome: 1200000, // ₹12,000
      totalExpense: 400000, // ₹4,000
      netProfit: 800000, // ₹8,000
      changePercent: 0.0,
      month: prevMonth,
      profileId: 'p_personal',
    ),
    ReportSummary(
      totalIncome: 1500000, // ₹15,000
      totalExpense: 500000, // ₹5,000
      netProfit: 1000000, // ₹10,000
      changePercent: 25.0,
      month: currentMonth,
      profileId: 'p_personal',
    ),
  ];

  Widget createAnalyticsScreen({
    required PlanType plan,
    required AsyncValue<List<ReportSummary>> chartData,
  }) {
    return ProviderScope(
      overrides: [
        activePlanProvider.overrideWithValue(plan),
        analyticsChartProvider.overrideWithValue(chartData),
      ],
      child: testApp(const AnalyticsScreen()),
    );
  }

  group('AnalyticsScreen Widget Tests', () {
    testWidgets('1. Loading state renders skeleton loading', (tester) async {
      await tester.pumpWidget(
        createAnalyticsScreen(
          plan: PlanType.free,
          chartData: const AsyncValue.loading(),
        ),
      );

      // Verify shimmer skeletons exist
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Analytics'), findsOneWidget);
    });

    testWidgets('2. Empty state renders when no data exists', (tester) async {
      await tester.pumpWidget(
        createAnalyticsScreen(
          plan: PlanType.free,
          chartData: const AsyncValue.data([]),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(
        find.text('Add transactions to see report insights'),
        findsOneWidget,
      );
      expect(find.text('Add Transaction'), findsOneWidget);
    });

    testWidgets('3. Renders stats and chart', (tester) async {
      await tester.pumpWidget(
        createAnalyticsScreen(
          plan: PlanType.free,
          chartData: AsyncValue.data(mockSummaries),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      // Verify stats are calculated correctly
      // Best Net Profit Month: Current Month (₹10,000)
      expect(find.text('BEST MONTH'), findsOneWidget);
      expect(find.text('₹10,000.00'), findsOneWidget);

      // Worst Net Profit Month: Prev Month (₹8,000)
      expect(find.text('WORST MONTH'), findsOneWidget);
      expect(find.text('₹8,000.00'), findsOneWidget);

      // Average Net Profit: (8000 + 10000) / 2 = 9000 (₹9,000)
      expect(find.text('AVG MONTHLY'), findsOneWidget);
      expect(find.text('₹9,000.00'), findsOneWidget);

      // MoM Growth: (10000 - 8000) / 8000 = 25% (+25.0%)
      expect(find.text('MoM GROWTH'), findsOneWidget);
      expect(find.text('+25.0%'), findsOneWidget);

      // ML Insights was removed — the button must never render.
      expect(find.text('View AI Insights'), findsNothing);

      // Verify LineChart exists
      expect(find.byType(LineChart), findsOneWidget);
    });

    testWidgets('5. Tab switcher changes metrics correctly', (tester) async {
      await tester.pumpWidget(
        createAnalyticsScreen(
          plan: PlanType.free,
          chartData: AsyncValue.data(mockSummaries),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      // Default is Net Profit. Let's switch to Income tab (index 1)
      final incomeTab = find.text('Income');
      expect(incomeTab, findsOneWidget);

      await tester.tap(incomeTab);
      await tester.pump(const Duration(milliseconds: 400));

      // Best Income Month: Current Month (₹15,000)
      expect(find.text('BEST MONTH'), findsOneWidget);
      expect(find.text('₹15,000.00'), findsOneWidget);

      // Worst Income Month: Prev Month (₹12,000)
      expect(find.text('WORST MONTH'), findsOneWidget);
      expect(find.text('₹12,000.00'), findsOneWidget);

      // Average Income: (12000 + 15000) / 2 = 13500 (₹13,500)
      expect(find.text('AVG MONTHLY'), findsOneWidget);
      expect(find.text('₹13,500.00'), findsOneWidget);

      // MoM Growth for Income: (15000 - 12000) / 12000 = 25.0%
      expect(find.text('+25.0%'), findsOneWidget);
    });
  });
}
