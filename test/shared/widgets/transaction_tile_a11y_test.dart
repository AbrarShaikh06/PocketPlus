import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/features/categories/domain/entities/category.dart';
import 'package:pocket_plus/features/transactions/domain/entities/transaction.dart';
import 'package:pocket_plus/shared/models/transaction_source.dart';
import 'package:pocket_plus/shared/models/transaction_type.dart';
import 'package:pocket_plus/shared/widgets/transaction_list_tile.dart';

Transaction _txn({
  int amount = 85000, // ₹850.00
  TransactionType type = TransactionType.expense,
}) {
  final now = DateTime(2026, 7, 5, 15, 0);
  return Transaction(
    id: 'txn-1',
    userId: 'user-1',
    profileId: 'profile-1',
    amount: amount,
    type: type,
    source: TransactionSource.manual,
    transactionDate: now,
    categoryId: 'food',
    merchantName: 'Corner Store',
    createdAt: now,
    updatedAt: now,
  );
}

const _category = Category(
  id: 'food',
  name: 'Groceries',
  icon: 'restaurant',
  colorHex: '#4CAF50',
  type: TransactionType.expense,
);

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(body: child),
    );

void main() {
  group('TransactionListTile accessibility', () {
    testWidgets('exposes a single combined semantic label', (tester) async {
      await tester.pumpWidget(
        _wrap(
          // disableAnimations makes the tile skip its entrance timer and
          // render synchronously.
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: TransactionListTile(
              transaction: _txn(),
              category: _category,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The whole tile reads as one coherent announcement rather than six
      // disjointed fragments.
      final semantics = tester.getSemantics(find.byType(TransactionListTile));
      expect(semantics.label, contains('Expense'));
      expect(semantics.label, contains('₹850.00'));
      expect(semantics.label, contains('Corner Store'));
      expect(semantics.label, contains('Groceries'));
    });

    testWidgets('income transactions are labelled as income', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: TransactionListTile(
              transaction: _txn(type: TransactionType.income),
              category: _category,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final semantics = tester.getSemantics(find.byType(TransactionListTile));
      expect(semantics.label, contains('Income'));
    });
  });
}
