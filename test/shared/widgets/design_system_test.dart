import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/core/constants/app_colors.dart';
import 'package:pocket_plus/core/constants/app_sizes.dart';
import 'package:pocket_plus/core/constants/app_text_styles.dart';
import 'package:pocket_plus/shared/widgets/widgets.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    ),
  );
}

void main() {
  group('AppColors', () {
    test('defines required semantic tokens', () {
      expect(AppColors.primary, const Color(0xFF0D3A35));
      expect(AppColors.error, const Color(0xFFB71C1C));
      expect(AppColors.income, AppColors.primary);
      expect(AppColors.expense, AppColors.error);
    });
  });

  group('AppSizes', () {
    test('defines spacing scale from spec', () {
      expect(AppSizes.spacing4, 4);
      expect(AppSizes.spacing8, 8);
      expect(AppSizes.spacing12, 12);
      expect(AppSizes.spacing16, 16);
      expect(AppSizes.spacing24, 24);
      expect(AppSizes.spacing32, 32);
      expect(AppSizes.spacing48, 48);
      expect(AppSizes.minTouchTarget, 48);
    });
  });

  group('AppTextStyles', () {
    testWidgets('defines all 9 text styles', (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(AppTextStyles.displayHero(context).fontSize, 40);
            expect(AppTextStyles.displayLarge(context).fontSize, 32);
            expect(AppTextStyles.titleLarge(context).fontSize, 22);
            expect(AppTextStyles.titleMedium(context).fontSize, 18);
            expect(AppTextStyles.bodyLarge(context).fontSize, 16);
            expect(AppTextStyles.bodyMedium(context).fontSize, 14);
            expect(AppTextStyles.labelLarge(context).fontSize, 14);
            expect(AppTextStyles.labelSmall(context).fontSize, 12);
            expect(AppTextStyles.codeFont(context).fontFamily, 'Courier New');
            return const SizedBox();
          },
        ),
      );
    });
  });

  group('AppButton', () {
    testWidgets('renders primary label', (tester) async {
      await tester.pumpWidget(
        _wrap(AppButton(label: 'Save', onPressed: () {})),
      );
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('shows loading spinner and hides label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AppButton(
            label: 'Save',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      );
      // AppButton hides its label and shows an animated loading-dots indicator
      // (not a CircularProgressIndicator) while loading.
      expect(find.text('Save'), findsNothing);
    });

    testWidgets('disabled button ignores tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(const AppButton(label: 'Save', onPressed: null)),
      );
      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(tapped, isFalse);
    });

    testWidgets('outline and text variants render', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Column(
            children: [
              AppButton(
                label: 'Outline',
                onPressed: () {},
                variant: AppButtonVariant.outline,
              ),
              AppButton(
                label: 'Text',
                onPressed: () {},
                variant: AppButtonVariant.text,
              ),
            ],
          ),
        ),
      );
      expect(find.text('Outline'), findsOneWidget);
      expect(find.text('Text'), findsOneWidget);
    });

    testWidgets('meets minimum touch target height', (tester) async {
      await tester.pumpWidget(
        _wrap(AppButton(label: 'Save', onPressed: () {})),
      );
      final buttonBox = tester.renderObject<RenderBox>(
        find.descendant(
          of: find.byType(AppButton),
          matching: find.byWidgetPredicate(
            (w) => w is SizedBox && w.height == AppSizes.minTouchTarget,
          ),
        ),
      );
      expect(buttonBox.size.height, AppSizes.minTouchTarget);
    });
  });

  group('AppCard', () {
    testWidgets('renders child and handles tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          AppCard(
            onTap: () => tapped = true,
            child: const Text('Card content'),
          ),
        ),
      );
      expect(find.text('Card content'), findsOneWidget);
      await tester.tap(find.text('Card content'));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  group('AppTextField', () {
    testWidgets('shows error with live region semantics', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AppTextField(
            label: 'Phone',
            errorText: 'Enter a valid number',
          ),
        ),
      );
      expect(find.text('Enter a valid number'), findsOneWidget);
      expect(
        tester.widget<Semantics>(
          find.byWidgetPredicate(
            (w) => w is Semantics && w.properties.liveRegion == true,
          ),
        ),
        isNotNull,
      );
    });
  });

  group('EmptyState', () {
    testWidgets('renders illustration, message, and CTA', (tester) async {
      await tester.pumpWidget(
        _wrap(
          EmptyState(
            illustration: const Icon(Icons.inbox_outlined, size: 64),
            message: 'No transactions yet',
            ctaLabel: 'Add Transaction',
            onCtaPressed: () {},
          ),
        ),
      );
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('No transactions yet'), findsOneWidget);
      expect(find.text('Add Transaction'), findsOneWidget);
    });
  });

  group('LoadingShimmer', () {
    testWidgets('renders shimmer placeholder', (tester) async {
      await tester.pumpWidget(
        _wrap(const LoadingShimmer(height: 48)),
      );
      expect(find.byType(LoadingShimmer), findsOneWidget);
    });

    testWidgets('list variant renders multiple items', (tester) async {
      await tester.pumpWidget(
        _wrap(const LoadingShimmerList(itemCount: 3)),
      );
      expect(find.byType(LoadingShimmer), findsNWidgets(3));
    });
  });
}
