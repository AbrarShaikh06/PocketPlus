import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pocket_plus/core/errors/failures.dart';
import 'package:pocket_plus/features/categories/domain/entities/category.dart';
import 'package:pocket_plus/features/home/presentation/home_providers.dart';
import 'package:pocket_plus/features/profiles/domain/entities/profile.dart';
import 'package:pocket_plus/features/transactions/domain/entities/transaction.dart';
import 'package:pocket_plus/features/transactions/domain/transaction_repository.dart';
import 'package:pocket_plus/features/transactions/presentation/transaction_history_screen.dart';
import 'package:pocket_plus/features/transactions/transactions_providers.dart';
import 'package:pocket_plus/shared/models/models.dart';
import '../../support/test_helpers.dart';

class MockTransactionRepository implements TransactionRepository {
  final List<Transaction> _transactions = [];
  final _controller = StreamController<List<Transaction>>.broadcast();
  bool softDeleteCalled = false;
  bool restoreCalled = false;

  void setTransactions(List<Transaction> txns) {
    _transactions
      ..clear()
      ..addAll(txns);
    _emit();
  }

  void _emit() {
    _controller.add(
      _transactions.where((t) => !t.isDeleted).toList(),
    );
  }

  @override
  Stream<List<Transaction>> watchTransactions({
    required String userId,
    required String profileId,
  }) {
    return _controller.stream;
  }

  @override
  Future<Either<Failure, void>> softDeleteTransaction(
    String transactionId,
  ) async {
    softDeleteCalled = true;
    final idx = _transactions.indexWhere((t) => t.id == transactionId);
    if (idx != -1) {
      _transactions[idx] = _transactions[idx].copyWith(
        isDeleted: true,
        deletedAt: DateTime.now(),
      );
    }
    _emit();
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> restoreTransaction(
    String transactionId,
  ) async {
    restoreCalled = true;
    final idx = _transactions.indexWhere((t) => t.id == transactionId);
    if (idx != -1) {
      _transactions[idx] = _transactions[idx].copyWith(
        isDeleted: false,
        deletedAt: null,
      );
    }
    _emit();
    return const Right(null);
  }

  @override
  Future<Either<Failure, Transaction>> createTransaction(
    Transaction transaction,
  ) async {
    return Right(transaction);
  }

  @override
  Future<Either<Failure, Transaction>> updateTransaction(
    Transaction transaction,
  ) async {
    return Right(transaction);
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsFromCache({
    required String userId,
    required String profileId,
  }) async {
    return const Right([]);
  }
}

Widget createTestApp({
  required MockTransactionRepository mockRepo,
  List<Category> categories = const [],
}) {
  const testProfile = Profile(
    id: 'p_test',
    userId: 'u_test',
    name: 'Test Profile',
    type: ProfileType.personal,
  );

  return ProviderScope(
    overrides: [
      currentProfileProvider.overrideWithValue(testProfile),
      userProfilesProvider.overrideWith((ref) => Stream.value([testProfile])),
      transactionRepositoryProvider.overrideWithValue(mockRepo),
      categoriesProvider.overrideWith((ref) => Stream.value(categories)),
    ],
    child: testApp(const TransactionHistoryScreen()),
  );
}

Transaction createTestTransaction({
  required String id,
  int amount = 10000,
  TransactionType type = TransactionType.expense,
  String? merchantName = 'Test Merchant',
  String? note,
  DateTime? transactionDate,
}) {
  final now = DateTime.now();
  return Transaction(
    id: id,
    userId: 'u_test',
    profileId: 'p_test',
    amount: amount,
    type: type,
    source: TransactionSource.manual,
    merchantName: merchantName,
    note: note,
    categoryId: 'cat_food',
    transactionDate: transactionDate ?? now,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  late MockTransactionRepository mockRepo;

  setUp(() {
    mockRepo = MockTransactionRepository();
  });

  group('TransactionHistoryScreen', () {
    testWidgets(
      '1. Search debounce: rapid typing produces only one filter call after 300ms',
      (tester) async {
        // Tall surface so all 5 tiles are laid out — the default 800x600
        // viewport only fits 4, and the lazy SliverList (correctly) skips
        // building the off-screen 5th, which this search test needs rendered.
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(createTestApp(mockRepo: mockRepo));

        final txns = List.generate(
          5,
          (i) => createTestTransaction(
            id: 'txn_$i',
            merchantName: i == 0 ? 'Unique Merchant' : 'Regular $i',
          ),
        );
        mockRepo.setTransactions(txns);
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Unique Merchant'), findsOneWidget);

        // Type rapidly within debounce period
        await tester.enterText(find.byType(TextField), 'U');
        await tester.pump(const Duration(milliseconds: 50));
        await tester.enterText(find.byType(TextField), 'Un');
        await tester.pump(const Duration(milliseconds: 50));
        await tester.enterText(find.byType(TextField), 'Uni');

        // Before debounce fires, all should still be visible
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text('Unique Merchant'), findsOneWidget);
        expect(find.text('Regular 1'), findsOneWidget);

        // Advance past the 300ms debounce
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pump(const Duration(milliseconds: 400));

        // After debounce, only matching items remain
        expect(find.text('Unique Merchant'), findsOneWidget);
        expect(find.text('Regular 1'), findsNothing);
      },
    );

    testWidgets(
      '2. Filter chips: selecting Expense hides income transactions',
      (tester) async {
        await tester.pumpWidget(createTestApp(mockRepo: mockRepo));

        final txns = [
          createTestTransaction(
            id: 'txn_1',
            amount: 5000,
            type: TransactionType.income,
            merchantName: 'Income 1',
          ),
          createTestTransaction(
            id: 'txn_2',
            amount: 3000,
            type: TransactionType.expense,
            merchantName: 'Expense 1',
          ),
          createTestTransaction(
            id: 'txn_3',
            amount: 2000,
            type: TransactionType.income,
            merchantName: 'Income 2',
          ),
        ];
        mockRepo.setTransactions(txns);
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Income 1'), findsOneWidget);
        expect(find.text('Expense 1'), findsOneWidget);
        expect(find.text('Income 2'), findsOneWidget);

        // Tap the "Expense" chip
        await tester.tap(find.text('Expense'));
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Income 1'), findsNothing);
        expect(find.text('Expense 1'), findsOneWidget);
        expect(find.text('Income 2'), findsNothing);
      },
    );

    testWidgets(
      '3. Swipe delete: tile removed + SnackBar shown',
      (tester) async {
        await tester.pumpWidget(createTestApp(mockRepo: mockRepo));

        final txn = createTestTransaction(
          id: 'txn_1',
          merchantName: 'Swipe Me',
        );
        mockRepo.setTransactions([txn]);
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Swipe Me'), findsOneWidget);

        await tester.drag(
          find.byType(Dismissible).first,
          const Offset(-500, 0),
        );
        // Frames: kick off the dismiss, complete the swipe-off + onDismissed,
        // then flush the repository stream re-emit and rebuild.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Swipe Me'), findsNothing);
        expect(find.text('Transaction deleted'), findsOneWidget);
        expect(mockRepo.softDeleteCalled, isTrue);
      },
    );

    testWidgets(
      '4. Undo: tile restored, SnackBar dismissed',
      (tester) async {
        await tester.pumpWidget(createTestApp(mockRepo: mockRepo));

        final txn = createTestTransaction(
          id: 'txn_1',
          merchantName: 'Undo Me',
        );
        mockRepo.setTransactions([txn]);
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Undo Me'), findsOneWidget);

        await tester.drag(
          find.byType(Dismissible).first,
          const Offset(-500, 0),
        );
        // Frames: kick off the dismiss, complete the swipe-off + onDismissed,
        // then flush the repository stream re-emit and rebuild.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Undo Me'), findsNothing);
        expect(find.text('Transaction deleted'), findsOneWidget);

        await tester.tap(find.text('UNDO'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Undo Me'), findsOneWidget);
        expect(mockRepo.restoreCalled, isTrue);
        expect(find.text('Transaction deleted'), findsNothing);
      },
    );

    testWidgets(
      '5. Pagination: scroll to bottom triggers load of next page',
      (tester) async {
        await tester.pumpWidget(createTestApp(mockRepo: mockRepo));

        final now = DateTime.now();
        final txns = List.generate(
          55,
          (i) => createTestTransaction(
            id: 'txn_$i',
            merchantName: 'Txn $i',
            transactionDate: now.subtract(Duration(hours: i)),
          ),
        );
        mockRepo.setTransactions(txns);
        await tester.pump(const Duration(milliseconds: 400));

        // First item visible initially
        expect(find.text('Txn 0'), findsOneWidget);

        // Scroll down until we find Txn 49
        bool found49 = false;
        for (int i = 0; i < 20; i++) {
          if (find.text('Txn 49').evaluate().isNotEmpty) {
            found49 = true;
            break;
          }
          await tester.drag(
            find.byType(CustomScrollView).first,
            const Offset(0, -300),
          );
          await tester.pump(const Duration(milliseconds: 400));
        }
        expect(found49, isTrue);

        // Scroll down further until we find Txn 50 (which will be loaded after scroll triggers loadMore)
        bool found50 = false;
        for (int i = 0; i < 10; i++) {
          if (find.text('Txn 50').evaluate().isNotEmpty) {
            found50 = true;
            break;
          }
          await tester.drag(
            find.byType(CustomScrollView).first,
            const Offset(0, -300),
          );
          await tester.pump(const Duration(milliseconds: 400));
        }
        expect(found50, isTrue);
      },
    );

    testWidgets(
      '6. Empty state: shown when filters match zero transactions',
      (tester) async {
        await tester.pumpWidget(createTestApp(mockRepo: mockRepo));

        mockRepo.setTransactions([
          createTestTransaction(
            id: 'txn_1',
            type: TransactionType.expense,
            merchantName: 'Expense Only',
          ),
        ]);
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('Expense Only'), findsOneWidget);

        // Select Income filter — zero matches
        await tester.tap(find.text('Income'));
        await tester.pump(const Duration(milliseconds: 400));

        expect(find.text('No transactions found'), findsOneWidget);
      },
    );
  });
}
