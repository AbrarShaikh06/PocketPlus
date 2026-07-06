# Tasks 16 & 17 — Report

## Task 16: Budget Notification Service

**Created:** `lib/features/budgets/presentation/services/budget_notification_service.dart`

- `BudgetNotificationService` class with `checkAndNotify()` and `reset()` methods
- `budgetNotificationServiceProvider` (Riverpod `Provider`)
- Tracks `_thresholdNotified` and `_exceededNotified` sets to avoid duplicate notifications
- Fires threshold alerts (e.g. 80% spent) and exceeded alerts via `LocalNotificationService`
- Automatically resets flag when budget spending drops below threshold

**Wired in** `lib/features/budgets/presentation/providers/budget_providers.dart`:
- Added import of `budget_notification_service.dart`
- Inline call `ref.read(budgetNotificationServiceProvider).checkAndNotify(budgets: result)` inside `calculatedBudgetsProvider` after computation

**Note:** Used inline notification check instead of `ref.listenSelf` (not available in Riverpod 3.3.2-dev.2).

## Task 17: Budget Insights Engine

**Created:** `lib/features/budgets/domain/budget_insights_engine.dart`

- `BudgetInsight` data class with `title`, `subtitle`, `icon`, `color`
- `BudgetInsightsEngine.generate()` produces insights:
  - Spending change vs previous period (increase/decrease %)
  - Most expensive day of the week
  - Highest single expense with merchant name
- Fixed `List<Budgetsight>` → `List<BudgetInsight>` typo
- Fixed import path: `../../transactions/domain/entities/transaction.dart` (was incorrectly `../../../transactions/...`)
- Removed unused `transaction_type.dart` import

## Analyze Results

```
flutter analyze — 0 errors, 0 warnings, 15 info (all pre-existing)
```

No new issues introduced by either task.
