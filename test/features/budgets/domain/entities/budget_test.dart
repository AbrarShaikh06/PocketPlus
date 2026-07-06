import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/features/budgets/domain/entities/budget.dart';
import 'package:pocket_plus/shared/models/sync_status.dart';

void main() {
  group('Budget entity', () {
    test('creates with defaults', () {
      final now = DateTime.now();
      final budget = Budget(
        id: 'test-id',
        userId: 'user-1',
        profileId: 'profile-1',
        name: 'Test Budget',
        budgetType: BudgetType.category,
        categoryIds: ['cat-1'],
        amount: 1000000,
        period: BudgetPeriod.monthly,
        startDate: now,
        createdAt: now,
        updatedAt: now,
      );

      expect(budget.name, 'Test Budget');
      expect(budget.spentAmount, 0);
      expect(budget.remainingAmount, 0);
      expect(budget.isPaused, false);
      expect(budget.isDeleted, false);
      expect(budget.syncStatus, SyncStatus.pending);
    });

    test('toJson and fromJson roundtrip', () {
      final now = DateTime.now();
      final budget = Budget(
        id: 'test-id',
        userId: 'user-1',
        profileId: 'profile-1',
        name: 'Test Budget',
        budgetType: BudgetType.overall,
        categoryIds: [],
        amount: 5000000,
        period: BudgetPeriod.weekly,
        startDate: now,
        createdAt: now,
        updatedAt: now,
      );

      final json = budget.toJson();
      final decoded = Budget.fromJson(json);

      expect(decoded.id, budget.id);
      expect(decoded.name, budget.name);
      expect(decoded.budgetType, budget.budgetType);
      expect(decoded.period, budget.period);
      expect(decoded.amount, budget.amount);
    });

    test('BudgetStatusX extensions work', () {
      expect(BudgetStatus.exceeded.isExceeded, true);
      expect(BudgetStatus.critical.isCritical, true);
      expect(BudgetStatus.warning.isWarning, true);
      expect(BudgetStatus.safe.isSafe, true);
    });
  });
}
