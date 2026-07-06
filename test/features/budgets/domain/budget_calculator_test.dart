import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/features/budgets/domain/budget_calculator.dart';
import 'package:pocket_plus/features/budgets/domain/entities/budget.dart';
import 'package:pocket_plus/features/transactions/domain/entities/transaction.dart';
import 'package:pocket_plus/shared/models/models.dart';

void main() {
  late BudgetCalculator calculator;

  setUp(() {
    calculator = BudgetCalculator();
  });

  group('computeStatus', () {
    test('returns safe below 70%', () {
      final budget = _budget(amount: 100000, spent: 50000);
      expect(calculator.computeStatus(budget), BudgetStatus.safe);
    });

    test('returns warning at 70-90%', () {
      final budget = _budget(amount: 100000, spent: 80000);
      expect(calculator.computeStatus(budget), BudgetStatus.warning);
    });

    test('returns critical at 90-100%', () {
      final budget = _budget(amount: 100000, spent: 95000);
      expect(calculator.computeStatus(budget), BudgetStatus.critical);
    });

    test('returns exceeded at 100%+', () {
      final budget = _budget(amount: 100000, spent: 100000);
      expect(calculator.computeStatus(budget), BudgetStatus.exceeded);
    });
  });

  group('computePercentage', () {
    test('returns correct percentage', () {
      final budget = _budget(amount: 100000, spent: 84200);
      expect(calculator.computePercentage(budget), 84);
    });

    test('returns 0 for zero amount budget', () {
      final budget = _budget(amount: 0, spent: 5000);
      expect(calculator.computePercentage(budget), 0);
    });
  });

  group('calculate with category budget', () {
    test('filters transactions by category', () {
      final budget = _budget(
        amount: 100000,
        spent: 0,
        budgetType: BudgetType.category,
        categoryIds: ['food'],
      );
      final txns = [
        _transaction(amount: 30000, categoryId: 'food'),
        _transaction(amount: 20000, categoryId: 'transport'),
      ];

      final result =
          calculator.calculate(budgets: [budget], transactions: txns);

      expect(result.first.spentAmount, 30000);
      expect(result.first.remainingAmount, 70000);
    });
  });

  group('calculate with overall budget', () {
    test('sums all expense transactions', () {
      final budget = _budget(
        amount: 500000,
        budgetType: BudgetType.overall,
      );
      final txns = [
        _transaction(amount: 100000, categoryId: 'food'),
        _transaction(amount: 50000, categoryId: 'transport'),
        _transaction(
            type: TransactionType.income, amount: 200000, categoryId: 'salary'),
      ];

      final result =
          calculator.calculate(budgets: [budget], transactions: txns);

      expect(result.first.spentAmount, 150000);
      expect(result.first.remainingAmount, 350000);
    });
  });

  group('calculate with custom budget', () {
    test('sums transactions matching any listed category', () {
      final budget = _budget(
        amount: 80000,
        budgetType: BudgetType.custom,
        categoryIds: ['movies', 'games', 'streaming'],
      );
      final txns = [
        _transaction(amount: 30000, categoryId: 'movies'),
        _transaction(amount: 20000, categoryId: 'games'),
        _transaction(amount: 10000, categoryId: 'food'),
      ];

      final result =
          calculator.calculate(budgets: [budget], transactions: txns);

      expect(result.first.spentAmount, 50000);
    });
  });

  group('skips deleted and paused budgets', () {
    test('skips paused budgets', () {
      final budget = _budget(isPaused: true);
      final txns = [_transaction(amount: 50000)];

      final result =
          calculator.calculate(budgets: [budget], transactions: txns);

      expect(result.first.spentAmount, 0);
    });

    test('skips deleted budgets', () {
      final budget = _budget(isDeleted: true);
      final txns = [_transaction(amount: 50000)];

      final result =
          calculator.calculate(budgets: [budget], transactions: txns);

      expect(result.first.spentAmount, 0);
    });
  });
}

Budget _budget({
  int amount = 100000,
  int spent = 0,
  BudgetType budgetType = BudgetType.category,
  List<String> categoryIds = const ['food'],
  bool isPaused = false,
  bool isDeleted = false,
}) {
  final now = DateTime.now();
  return Budget(
    id: 'test-id',
    userId: 'user-1',
    profileId: 'profile-1',
    name: 'Test',
    budgetType: budgetType,
    categoryIds: categoryIds,
    amount: amount,
    spentAmount: spent,
    remainingAmount: (amount - spent).clamp(0, amount),
    period: BudgetPeriod.monthly,
    startDate: now,
    createdAt: now,
    updatedAt: now,
    isPaused: isPaused,
    isDeleted: isDeleted,
  );
}

Transaction _transaction({
  int amount = 10000,
  TransactionType type = TransactionType.expense,
  String? categoryId = 'food',
}) {
  final now = DateTime.now();
  return Transaction(
    id: 'txn-${now.millisecondsSinceEpoch}',
    userId: 'user-1',
    profileId: 'profile-1',
    amount: amount,
    type: type,
    source: TransactionSource.manual,
    transactionDate: now,
    categoryId: categoryId,
    createdAt: now,
    updatedAt: now,
  );
}
