import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/features/invoices/presentation/invoice_list_screen.dart';
import 'package:pocket_plus/features/invoices/presentation/invoice_view_model.dart';
import 'package:pocket_plus/features/profiles/profiles_providers.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';
import 'package:pocket_plus/shared/models/models.dart';

void main() {
  testWidgets('7. Free user: invoice list shows upgrade prompt',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userPlanProvider.overrideWith((ref) async => PlanType.free),
          invoiceListViewModelProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: InvoiceListScreen(),
        ),
      ),
    );

    await tester.pump(); // Start loading
    await tester
        .pump(const Duration(milliseconds: 100)); // Finish future loading

    // Verify upgrade prompt is shown
    expect(
      find.text('Invoice feature available on Basic ₹100/mo'),
      findsOneWidget,
    );
    expect(find.text('See Plans'), findsOneWidget);
    // Verify FAB + New Invoice is hidden for Free plan
    expect(find.byIcon(Icons.add), findsNothing);
  });

  testWidgets(
      'Paid user: invoice list shows empty state when no invoices exist',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userPlanProvider.overrideWith((ref) async => PlanType.basic),
          invoiceListViewModelProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: InvoiceListScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify empty state message is shown
    expect(find.text('Create your first invoice'), findsOneWidget);
    // Verify FAB is shown for basic tier
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
