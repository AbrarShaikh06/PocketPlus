# Budget Planning System — Design Doc

## Overview

A production-ready Budget Planning feature for PocketPlus that integrates seamlessly with the existing architecture. Users can create budgets, track spending automatically, view real-time progress, receive notifications, analyze spending against budgets, and work completely offline.

## Architecture

```
lib/features/budgets/
├── domain/
│   ├── entities/
│   │   ├── budget.dart                # freezed entity
│   │   └── budget_period.dart         # enum: weekly/monthly/yearly
│   ├── budget_repository.dart         # abstract interface class
│   └── budget_calculator.dart         # pure computation (no Riverpod/Firestore)
├── data/
│   ├── firestore_budget_data_source.dart
│   └── budget_repository_impl.dart
├── presentation/
│   ├── screens/
│   │   ├── budget_list_screen.dart     # main budget dashboard (4th tab)
│   │   ├── create_budget_screen.dart   # create/edit form
│   │   └── budget_detail_screen.dart   # detail view with analytics
│   ├── budget_view_model.dart          # Notifier<BudgetState> (freezed)
│   ├── widgets/                        # reusable widgets
│   │   ├── budget_card.dart
│   │   ├── budget_progress_bar.dart
│   │   ├── circular_budget_indicator.dart
│   │   ├── budget_status_chip.dart
│   │   ├── remaining_amount_card.dart
│   │   ├── budget_empty_state.dart
│   │   ├── budget_skeleton_loader.dart
│   │   ├── budget_filter_chips.dart
│   │   ├── budget_insight_card.dart
│   │   └── budget_forecast_card.dart
│   └── providers/
│       └── budget_providers.dart       # stream + computed providers
└── budgets_providers.dart              # data source + repo providers (feature root)
```

## Data Model

### Budget Entity (`domain/entities/budget.dart`)

```dart
@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    required String id,
    required String userId,
    required String profileId,
    required String name,
    required BudgetType budgetType,         // CATEGORY, OVERALL, CUSTOM
    required List<String> categoryIds,
    required int amount,                     // paise
    required int spentAmount,                // paise, computed
    required int remainingAmount,            // paise, computed
    required BudgetPeriod period,            // WEEKLY, MONTHLY, YEARLY
    required DateTime startDate,
    DateTime? endDate,
    required String colorHex,               // #RRGGBB
    required String icon,                   // Material symbol name
    @Default(80) int alertThreshold,        // percentage 0-100
    @Default(true) bool notificationsEnabled,
    String? notes,
    @Default(false) bool isPaused,
    @Default(false) bool isDeleted,
    DateTime? deletedAt,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}
```

### Budget Period (`domain/entities/budget_period.dart`)

```dart
enum BudgetPeriod { weekly, monthly, yearly }
enum BudgetType { category, overall, custom }
```

## Budget Status

| Range | Status | Color |
|---|---|---|
| 0–70% | Safe | Green |
| 70–90% | Warning | Blue/Orange |
| 90–100% | Critical | Orange |
| 100%+ | Exceeded | Red |

## Reactive Budget Calculation

`BudgetCalculator` is a pure class with a single method:

```dart
List<Budget> calculate(List<Budget> budgets, List<Transaction> transactions);
```

For each budget:
1. Filter transactions by: `isDeleted == false`, `type == expense`, within budget period range
2. If `CATEGORY`: sum transactions matching `categoryIds.first`
3. If `OVERALL`: sum all expense transactions
4. If `CUSTOM`: sum transactions matching any of `categoryIds`
5. Compute `spentAmount`, `remainingAmount`, status, forecast

A Riverpod `Provider` watches the transaction stream and recalculates automatically.

## Navigation

- **4th bottom nav tab** in ShellRoute: `/budgets`
- Create: `/budgets/new`
- Detail: `/budgets/:id`
- Route names added to `RouteNames`

## Key Integration Points

### Dashboard (Home)
- New `BudgetOverviewSection` widget showing top 3 budgets with circular progress
- Empty state CTA when no budgets exist

### Analytics
- Budget line overlay on existing `fl_chart` area charts
- `budgetVsActualProvider` computes variance

### Reports
- Budget comparison columns in report summaries
- PDF/CSV export includes budget data

### Transactions
- Any transaction create/edit/delete/restore triggers budget recalculation via reactive provider chain

### Notifications
- `LocalNotificationService.show()` called from `ref.listen` on budget status changes
- Threshold alerts at user-defined percentage, plus 100% exceeded

### Offline
- Firestore persistence handles reads
- Writes use `.set()` with SyncStatus tracking
- No separate offline queue file needed (Firestore handles this)

## Testing

- Unit: `BudgetCalculator` pure logic tests
- Widget: Budget card, progress bar, create form
- Repository: mock data source, verify Either returns
- Offline sync: verify SyncStatus flow
- Notifications: verify threshold triggers
