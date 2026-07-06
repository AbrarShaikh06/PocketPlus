import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/features/analytics/presentation/models/analytics_data.dart';
import 'package:pocket_plus/features/analytics/presentation/widgets/analytics_chart_card.dart';

const _sample = [
  AnalyticsData(month: 'Jan', desktop: 186, mobile: 80, other: 45),
  AnalyticsData(month: 'Feb', desktop: 305, mobile: 200, other: 100),
  AnalyticsData(month: 'Mar', desktop: 237, mobile: 120, other: 150),
  AnalyticsData(month: 'Apr', desktop: 73, mobile: 190, other: 50),
  AnalyticsData(month: 'May', desktop: 209, mobile: 130, other: 100),
  AnalyticsData(month: 'Jun', desktop: 214, mobile: 140, other: 160),
];

Widget _host(Widget child, {Size size = const Size(420, 720)}) {
  return MaterialApp(
    home: Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Center(
        child: SizedBox(
          width: size.width,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('renders header, subtitle and footer without overflow',
      (tester) async {
    await tester.pumpWidget(
      _host(
        const AnalyticsChartCard(
          title: 'Area Chart - Stacked Expanded',
          subtitle: 'Showing total visitors for the last 6 months',
          data: _sample,
          trendPercentage: 5.2,
          dateRange: 'January - June 2024',
        ),
      ),
    );
    // Let the 800ms reveal animation settle.
    await tester.pumpAndSettle();

    expect(find.text('Area Chart - Stacked Expanded'), findsOneWidget);
    expect(
      find.text('Showing total visitors for the last 6 months'),
      findsOneWidget,
    );
    expect(find.textContaining('Trending up by 5.2%'), findsOneWidget);
    expect(find.text('January - June 2024'), findsOneWidget);
    expect(find.text('Jan'), findsOneWidget);
    expect(find.text('Jun'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows down trend when percentage is negative', (tester) async {
    await tester.pumpWidget(
      _host(
        const AnalyticsChartCard(
          title: 'Visitors',
          subtitle: 'Last 6 months',
          data: _sample,
          trendPercentage: -3.4,
          dateRange: 'Jan - Jun',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Trending down by 3.4%'), findsOneWidget);
    expect(find.byIcon(Icons.trending_down), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders in a narrow landscape-ish constraint without overflow',
      (tester) async {
    await tester.pumpWidget(
      _host(
        const AnalyticsChartCard(
          title: 'Visitors',
          subtitle: 'Last 6 months',
          data: _sample,
          trendPercentage: 5.2,
          dateRange: 'January - June 2024',
        ),
        size: const Size(320, 480),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('hides footer and grid when disabled', (tester) async {
    await tester.pumpWidget(
      _host(
        const AnalyticsChartCard(
          title: 'Visitors',
          subtitle: 'Last 6 months',
          data: _sample,
          showFooter: false,
          showGrid: false,
          animate: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Trending'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
