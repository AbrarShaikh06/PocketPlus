import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_plus/core/notifications/local_notification_service.dart';
import 'package:pocket_plus/core/utils/currency_formatter.dart';

import '../../domain/budget_calculator.dart';
import '../../domain/entities/budget.dart';

class BudgetNotificationService {
  final Set<String> _thresholdNotified = {};
  final Set<String> _exceededNotified = {};

  void checkAndNotify({required List<Budget> budgets}) {
    final calculator = BudgetCalculator();
    for (final budget in budgets) {
      if (!budget.notificationsEnabled ||
          budget.isPaused ||
          budget.amount <= 0) {
        continue;
      }
      final percentage = calculator.computePercentage(budget);
      final status = calculator.computeStatus(budget);

      if (percentage >= budget.alertThreshold &&
          !_thresholdNotified.contains(budget.id)) {
        _thresholdNotified.add(budget.id);
        LocalNotificationService.show(
          'Budget Alert',
          "You've used $percentage% of your ${budget.name} budget.",
          'budget_${budget.id}',
        );
      }

      if (status == BudgetStatus.exceeded &&
          !_exceededNotified.contains(budget.id)) {
        _exceededNotified.add(budget.id);
        final exceededAmount = budget.spentAmount - budget.amount;
        LocalNotificationService.show(
          'Budget Exceeded',
          "You've exceeded your ${budget.name} budget by ${CurrencyFormatter.format(exceededAmount)}.",
          'budget_${budget.id}',
        );
      }

      if (_thresholdNotified.contains(budget.id) &&
          percentage < budget.alertThreshold) {
        _thresholdNotified.remove(budget.id);
      }
      if (_exceededNotified.contains(budget.id) &&
          status != BudgetStatus.exceeded) {
        _exceededNotified.remove(budget.id);
      }
    }
  }

  void reset() {
    _thresholdNotified.clear();
    _exceededNotified.clear();
  }
}

final budgetNotificationServiceProvider =
    Provider<BudgetNotificationService>((ref) {
  return BudgetNotificationService();
});
