import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pocket_plus/features/shell/presentation/main_shell.dart';

void main() {
  Widget buildTestWidget({required GoRouter router}) {
    return ProviderScope(
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  group('MainShell Widget Tests', () {
    late GoRouter router;

    setUp(() {
      router = GoRouter(
        initialLocation: '/home',
        routes: [
          ShellRoute(
            builder: (context, state, child) => MainShell(child: child),
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const Text('Home Screen'),
              ),
              GoRoute(
                path: '/analytics',
                builder: (context, state) => const Text('Analytics Screen'),
              ),
              GoRoute(
                path: '/reports',
                builder: (context, state) => const Text('Reports Screen'),
              ),
            ],
          ),
        ],
      );
    });

    testWidgets('Renders the three bottom navigation tabs', (tester) async {
      await tester.pumpWidget(buildTestWidget(router: router));
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Analytics'), findsOneWidget);
      expect(find.text('Reports'), findsOneWidget);
      // CA Connect was removed — no Connect tab anymore.
      expect(find.text('Connect'), findsNothing);

      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('Tapping on a tab navigates to the respective screen',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(router: router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Analytics'));
      await tester.pumpAndSettle();
      expect(find.text('Analytics Screen'), findsOneWidget);
      expect(find.text('Home Screen'), findsNothing);

      await tester.tap(find.text('Reports'));
      await tester.pumpAndSettle();
      expect(find.text('Reports Screen'), findsOneWidget);
    });
  });
}
