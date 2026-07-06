import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/core/monitoring/maintenance_screen.dart';

void main() {
  group('MaintenanceScreen', () {
    testWidgets('killSwitch renders title and message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MaintenanceScreen.killSwitch(
              'Scheduled maintenance in progress.'),
        ),
      );

      expect(find.text('App Unavailable'), findsOneWidget);
      expect(
        find.text('Scheduled maintenance in progress.'),
        findsOneWidget,
      );
    });

    testWidgets('killSwitch does not show update button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MaintenanceScreen.killSwitch('Down for maintenance.'),
        ),
      );

      expect(find.text('Update Now'), findsNothing);
    });

    testWidgets('forceUpdate renders title and version message',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MaintenanceScreen.forceUpdate('2.0.0'),
        ),
      );

      expect(find.text('Update Required'), findsOneWidget);
      expect(find.textContaining('2.0.0'), findsOneWidget);
    });

    testWidgets('forceUpdate shows update button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MaintenanceScreen.forceUpdate('2.0.0'),
        ),
      );

      expect(find.text('Update Now'), findsOneWidget);
    });

    testWidgets('forceUpdate message contains app name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MaintenanceScreen.forceUpdate('1.5.0'),
        ),
      );

      expect(find.textContaining('PocketPlus'), findsOneWidget);
    });
  });
}
