import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/features/budgets/domain/budget_repository.dart';

void main() {
  group('BudgetRepository interface', () {
    test('can be implemented', () {
      expect(BudgetRepository, isNotNull);
    });
  });
}
