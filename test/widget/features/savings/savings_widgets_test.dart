import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/core/constants/app_colors.dart';
import 'package:pocket_plus/features/home/presentation/home_providers.dart';
import 'package:pocket_plus/features/profiles/domain/entities/profile.dart';
import 'package:pocket_plus/features/savings/presentation/create_dream_screen.dart';
import 'package:pocket_plus/features/savings/presentation/widgets/savings_progress_bar.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';
import 'package:pocket_plus/shared/widgets/app_button.dart';
import 'package:pocket_plus/shared/models/models.dart';

void main() {
  group('SavingsProgressBar Widget Tests', () {
    testWidgets('Renders progress bar with correct fraction size',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SavingsProgressBar(
              savedAmount: 30000,
              targetAmount: 100000,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));

      // FactionallySizedBox handles the width factor
      final finder = find.byType(FractionallySizedBox);
      expect(finder, findsOneWidget);

      final box = tester.widget<FractionallySizedBox>(finder);
      expect(box.widthFactor, 0.3);
    });

    testWidgets('Switches progress bar color to orange when progress is > 90%',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SavingsProgressBar(
              savedAmount: 95000,
              targetAmount: 100000,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));

      final containerFinder = find.descendant(
        of: find.byType(FractionallySizedBox),
        matching: find.byType(Container),
      );

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.orange);
    });

    testWidgets('Uses primary green color when progress is <= 90%',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SavingsProgressBar(
              savedAmount: 50000,
              targetAmount: 100000,
            ),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 2));

      final containerFinder = find.descendant(
        of: find.byType(FractionallySizedBox),
        matching: find.byType(Container),
      );

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.primary);
    });
  });

  group('CreateDreamScreen Form Validation Widget Tests', () {
    const testProfile = Profile(
      id: 'p_test',
      userId: 'u_test',
      name: 'Business Shop',
      type: ProfileType.shop,
    );

    testWidgets('Save button is disabled initially when form is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentProfileProvider.overrideWithValue(testProfile),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: CreateDreamScreen(),
          ),
        ),
      );

      final buttonFinder = find.byType(AppButton);
      expect(buttonFinder, findsOneWidget);

      final button = tester.widget<AppButton>(buttonFinder);
      expect(button.onPressed, isNull); // disabled
    });

    testWidgets(
        'Save button remains disabled with empty or invalid target amount',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentProfileProvider.overrideWithValue(testProfile),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: CreateDreamScreen(),
          ),
        ),
      );

      // Enter Dream Name
      await tester.enterText(find.byType(TextField).first, 'Buy Delivery Bike');
      await tester.pump();

      // Enter 0 target amount
      await tester.enterText(find.byType(TextField).at(1), '0');
      await tester.pump();

      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('Save button is enabled when form is filled with valid data',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentProfileProvider.overrideWithValue(testProfile),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: CreateDreamScreen(),
          ),
        ),
      );

      // Enter Dream Name
      await tester.enterText(find.byType(TextField).first, 'Buy Delivery Bike');
      await tester.pump();

      // Enter target amount
      await tester.enterText(find.byType(TextField).at(1), '45000');
      await tester.pump();

      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.onPressed, isNotNull); // enabled
    });
  });
}
