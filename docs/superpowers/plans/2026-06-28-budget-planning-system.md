# Budget Planning System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement a complete Budget Planning feature with 3 budget types, reactive spending tracking, notifications, offline support, and full integration with Dashboard, Analytics, and Reports.

**Architecture:** Feature-first Clean Architecture following PocketPlus patterns: freezed entities, Riverpod Notifier state management, abstract repository interfaces, Firestore data sources, and reactive computation via provider chains. Budget calculations are pure functions that re-run automatically whenever transactions change.

**Tech Stack:** Flutter, Riverpod 3.x, freezed, dartz, Firestore, GoRouter, fl_chart, FlutterLocalNotificationsPlugin

## Global Constraints

- All amounts in paise (int), never double
- All Firestore queries scoped by userId + profileId + isDeleted == false
- Repository methods return `Either<Failure, T>` for writes, `Stream<T>` for reads
- Entities use freezed with fromJson/toJson converters for Firestore Timestamps and enums
- Soft deletes only: set `isDeleted = true` and `deletedAt = Timestamp.now()`
- SyncStatus enum values: pending, synced, failed
- Follow existing barrel-export pattern at feature root
- Follow Material 3 design language (AppColors, AppTextStyles, AppSizes)

---

## File Structure

### Files to Create (25 files)

```
lib/features/budgets/
├── domain/
│   ├── entities/
│   │   └── budget.dart                        # freezed entity
│   ├── budget_repository.dart                  # abstract interface
│   └── budget_calculator.dart                  # pure computation
├── data/
│   ├── firestore_budget_data_source.dart       # Firestore CRUD
│   └── budget_repository_impl.dart             # wraps data source
├── presentation/
│   ├── screens/
│   │   ├── budget_list_screen.dart             # main tab screen
│   │   ├── create_budget_screen.dart           # create/edit form
│   │   └── budget_detail_screen.dart           # detail + analytics
│   ├── budget_view_model.dart                  # freezed state + notifier
│   ├── widgets/
│   │   ├── widgets.dart                        # barrel export
│   │   ├── budget_card.dart                    # card for list
│   │   ├── budget_progress_bar.dart            # animated linear bar
│   │   ├── circular_budget_indicator.dart      # circular progress
│   │   ├── budget_status_chip.dart             # status label
│   │   ├── remaining_amount_card.dart          # remaining display
│   │   ├── budget_empty_state.dart             # no-budgets state
│   │   ├── budget_skeleton_loader.dart         # shimmer loading
│   │   ├── budget_filter_chips.dart            # period filter chips
│   │   ├── budget_insight_card.dart            # insight display
│   │   └── budget_forecast_card.dart           # forecast display
│   └── providers/
│       └── budget_providers.dart               # all budget providers
└── budgets_providers.dart                      # data source + repo providers
```

### Files to Modify (7 files)

```
lib/core/router/route_names.dart               # add budget routes
lib/core/router/app_router.dart                 # add GoRoutes + ShellRoute tab
lib/features/home/presentation/home_screen.dart  # add budget overview section
lib/features/home/presentation/home_providers.dart # add budget overview provider
lib/features/analytics/presentation/analytics_screen.dart # budget line overlay
lib/features/reports/presentation/reports_screen.dart     # budget columns
lib/shared/widgets/widgets.dart                 # export new shared widgets (if any)
```

---

### Task 1: Budget Enums and Entity

**Files:**
- Create: `lib/features/budgets/domain/entities/budget.dart`

**Interfaces:**
- Produces: `Budget`, `BudgetType`, `BudgetPeriod`, `BudgetStatus` enums, freezed entity with JSON serialization

- [ ] **Step 1: Create domain entities directory**

```bash
New-Item -ItemType Directory -Path "A:\PocketPlus\lib\features\budgets\domain\entities" -Force
```

- [ ] **Step 2: Create budget.dart with freezed entity**

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/models/sync_status.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

DateTime _dateTimeFromTimestamp(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.parse(value);
  return DateTime.now();
}

dynamic _dateTimeToTimestamp(DateTime? dateTime) {
  if (dateTime == null) return null;
  return Timestamp.fromDate(dateTime);
}

DateTime? _nullableDateTimeFromTimestamp(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.tryParse(value);
  return null;
}

BudgetType _budgetTypeFromFirestore(String value) =>
    BudgetType.values.firstWhere((e) => e.name == value, orElse: () => BudgetType.category);
String _budgetTypeToFirestore(BudgetType type) => type.name;

BudgetPeriod _budgetPeriodFromFirestore(String value) =>
    BudgetPeriod.values.firstWhere((e) => e.name == value, orElse: () => BudgetPeriod.monthly);
String _budgetPeriodToFirestore(BudgetPeriod period) => period.name;

SyncStatus _syncStatusFromFirestore(String value) =>
    SyncStatusX.fromFirestore(value);
String _syncStatusToFirestore(SyncStatus status) => status.firestoreValue;

enum BudgetType { category, overall, custom }
enum BudgetPeriod { weekly, monthly, yearly }

enum BudgetStatus { safe, warning, critical, exceeded }

@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    required String id,
    required String userId,
    required String profileId,
    required String name,
    @JsonKey(fromJson: _budgetTypeFromFirestore, toJson: _budgetTypeToFirestore)
    required BudgetType budgetType,
    @Default([]) List<String> categoryIds,
    required int amount,
    @Default(0) int spentAmount,
    @Default(0) int remainingAmount,
    @JsonKey(fromJson: _budgetPeriodFromFirestore, toJson: _budgetPeriodToFirestore)
    required BudgetPeriod period,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime startDate,
    @JsonKey(fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime? endDate,
    @Default('#4CAF50') String colorHex,
    @Default('account_balance_wallet') String icon,
    @Default(80) int alertThreshold,
    @Default(true) bool notificationsEnabled,
    String? notes,
    @Default(false) bool isPaused,
    @Default(false) bool isDeleted,
    @JsonKey(fromJson: _nullableDateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    DateTime? deletedAt,
    @JsonKey(fromJson: _syncStatusFromFirestore, toJson: _syncStatusToFirestore)
    @Default(SyncStatus.pending) SyncStatus syncStatus,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime createdAt,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
    required DateTime updatedAt,
  }) = _Budget;

  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}

extension BudgetStatusX on BudgetStatus {
  bool get isExceeded => this == BudgetStatus.exceeded;
  bool get isCritical => this == BudgetStatus.critical;
  bool get isWarning => this == BudgetStatus.warning;
  bool get isSafe => this == BudgetStatus.safe;
}
```

- [ ] **Step 3: Run code generation**

```bash
cd A:\PocketPlus
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 4: Create unit test for Budget entity**

Create `test/features/budgets/domain/entities/budget_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketplus/features/budgets/domain/entities/budget.dart';

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
```

- [ ] **Step 5: Run test to verify**

```bash
cd A:\PocketPlus
flutter test test/features/budgets/domain/entities/budget_test.dart
```

- [ ] **Step 6: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/domain/entities/
git add test/features/budgets/domain/entities/
git add lib/features/budgets/domain/entities/budget.freezed.dart
git add lib/features/budgets/domain/entities/budget.g.dart
git commit -m "feat: add budget entity with enums and JSON serialization"
```

---

### Task 2: Budget Repository Interface

**Files:**
- Create: `lib/features/budgets/domain/budget_repository.dart`

**Interfaces:**
- Consumes: `Budget` entity (Task 1), `Failure` from `core/errors/failures.dart`, `dartz`
- Produces: `BudgetRepository` abstract interface

- [ ] **Step 1: Create repository interface**

```dart
import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import 'entities/budget.dart';

abstract interface class BudgetRepository {
  Stream<List<Budget>> watchBudgets({
    required String userId,
    required String profileId,
  });

  Future<Either<Failure, Budget>> createBudget(Budget budget);
  Future<Either<Failure, Budget>> updateBudget(Budget budget);
  Future<Either<Failure, void>> softDeleteBudget(String budgetId);
  Future<Either<Failure, Budget>> duplicateBudget(Budget budget);
  Future<Either<Failure, void>> togglePauseBudget(String budgetId, bool isPaused);
  Future<Either<Failure, List<Budget>>> getBudgetsFromCache({
    required String userId,
    required String profileId,
  });
}
```

- [ ] **Step 2: Write test**

```dart
// test/features/budgets/domain/budget_repository_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:pocketplus/core/errors/failures.dart';
import 'package:pocketplus/features/budgets/domain/budget_repository.dart';
import 'package:pocketplus/features/budgets/domain/entities/budget.dart';

void main() {
  group('BudgetRepository interface', () {
    test('can be implemented', () {
      // Compile-time check that interface is valid
      expect(BudgetRepository, isNotNull);
    });
  });
}
```

- [ ] **Step 3: Run test**

```bash
cd A:\PocketPlus
flutter test test/features/budgets/domain/budget_repository_test.dart
```

- [ ] **Step 4: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/domain/budget_repository.dart
git add test/features/budgets/domain/
git commit -m "feat: add budget repository interface"
```

---

### Task 3: Budget Calculator (Pure Computation)

**Files:**
- Create: `lib/features/budgets/domain/budget_calculator.dart`

**Interfaces:**
- Consumes: `Budget` entity, `Transaction` from `features/transactions/domain/entities/transaction.dart`, `TransactionType` from `shared/models/transaction_type.dart`
- Produces: `BudgetCalculator` with `calculate(List<Budget>, List<Transaction>)` and `computeForecast(Budget, int)` methods

- [ ] **Step 1: Create budget_calculator.dart**

```dart
import '../../transactions/domain/entities/transaction.dart';
import '../../../shared/models/transaction_type.dart';
import 'entities/budget.dart';

class BudgetCalculator {
  List<Budget> calculate({
    required List<Budget> budgets,
    required List<Transaction> transactions,
  }) {
    return budgets.map((budget) {
      if (budget.isPaused || budget.isDeleted) return budget;

      final periodRange = getPeriodRange(budget);
      final relevantTxns = transactions.where((t) {
        if (t.isDeleted) return false;
        if (t.type != TransactionType.expense) return false;
        if (t.transactionDate.isBefore(periodRange.start)) return false;
        if (budget.endDate != null &&
            t.transactionDate.isAfter(budget.endDate!)) return false;
        if (budget.endDate == null &&
            t.transactionDate.isAfter(periodRange.end)) return false;
        return true;
      });

      final filtered = _filterByBudgetType(budget, relevantTxns);
      final spentAmount = filtered.fold(0, (sum, t) => sum + t.amount);
      final remainingAmount = (budget.amount - spentAmount).clamp(0, budget.amount);

      return budget.copyWith(
        spentAmount: spentAmount,
        remainingAmount: remainingAmount,
      );
    }).toList();
  }

  List<Transaction> _filterByBudgetType(
    Budget budget,
    Iterable<Transaction> transactions,
  ) {
    switch (budget.budgetType) {
      case BudgetType.overall:
        return transactions.toList();
      case BudgetType.category:
        final catId = budget.categoryIds.isNotEmpty ? budget.categoryIds.first : null;
        if (catId == null) return [];
        return transactions.where((t) => t.categoryId == catId).toList();
      case BudgetType.custom:
        if (budget.categoryIds.isEmpty) return [];
        return transactions
            .where((t) => t.categoryId != null && budget.categoryIds.contains(t.categoryId))
            .toList();
    }
  }

  ({DateTime start, DateTime end}) getPeriodRange(Budget budget) {
    final now = DateTime.now();
    switch (budget.period) {
      case BudgetPeriod.weekly:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        return (
          start: DateTime(weekStart.year, weekStart.month, weekStart.day),
          end: DateTime(weekStart.year, weekStart.month, weekStart.day + 7),
        );
      case BudgetPeriod.monthly:
        final monthStart = DateTime(now.year, now.month, 1);
        final monthEnd = DateTime(now.year, now.month + 1, 1);
        return (start: monthStart, end: monthEnd);
      case BudgetPeriod.yearly:
        return (
          start: DateTime(now.year, 1, 1),
          end: DateTime(now.year + 1, 1, 1),
        );
    }
  }

  int computeDaysElapsed(Budget budget) {
    final range = getPeriodRange(budget);
    final start = budget.startDate.isAfter(range.start) ? budget.startDate : range.start;
    final end = budget.endDate ?? range.end;
    final now = DateTime.now();
    if (now.isBefore(start)) return 0;
    if (now.isAfter(end)) return end.difference(start).inDays;
    return now.difference(start).inDays;
  }

  int computeTotalDays(Budget budget) {
    final range = getPeriodRange(budget);
    final start = budget.startDate.isAfter(range.start) ? budget.startDate : range.start;
    final end = budget.endDate ?? range.end;
    return end.difference(start).inDays;
  }

  int computeForecast(Budget budget) {
    final daysElapsed = computeDaysElapsed(budget);
    if (daysElapsed <= 0) return 0;
    final totalDays = computeTotalDays(budget);
    if (totalDays <= 0) return budget.spentAmount;
    final dailyAvg = budget.spentAmount / daysElapsed;
    return (dailyAvg * totalDays).round();
  }

  int computeDailyAverage(Budget budget) {
    final daysElapsed = computeDaysElapsed(budget);
    if (daysElapsed <= 0) return 0;
    return (budget.spentAmount / daysElapsed).round();
  }

  int computeWeeklyAverage(Budget budget) {
    final daysElapsed = computeDaysElapsed(budget);
    if (daysElapsed <= 0) return 0;
    final weeks = (daysElapsed / 7).clamp(1, double.infinity);
    return (budget.spentAmount / weeks).round();
  }

  int computeRemainingDailyAllowance(Budget budget) {
    final daysElapsed = computeDaysElapsed(budget);
    final totalDays = computeTotalDays(budget);
    final remainingDays = totalDays - daysElapsed;
    if (remainingDays <= 0 || budget.remainingAmount <= 0) return 0;
    return (budget.remainingAmount / remainingDays).round();
  }

  BudgetStatus computeStatus(Budget budget) {
    if (budget.amount <= 0) return BudgetStatus.safe;
    final percentage = (budget.spentAmount / budget.amount) * 100;
    if (percentage >= 100) return BudgetStatus.exceeded;
    if (percentage >= 90) return BudgetStatus.critical;
    if (percentage >= 70) return BudgetStatus.warning;
    return BudgetStatus.safe;
  }

  int computePercentage(Budget budget) {
    if (budget.amount <= 0) return 0;
    return ((budget.spentAmount / budget.amount) * 100).round().clamp(0, 999);
  }
}
```

- [ ] **Step 2: Write unit tests for BudgetCalculator**

Create `test/features/budgets/domain/budget_calculator_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pocketplus/features/budgets/domain/budget_calculator.dart';
import 'package:pocketplus/features/budgets/domain/entities/budget.dart';
import 'package:pocketplus/features/transactions/domain/entities/transaction.dart';
import 'package:pocketplus/shared/models/models.dart';

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

      final result = calculator.calculate(budgets: [budget], transactions: txns);

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
        _transaction(type: TransactionType.income, amount: 200000, categoryId: 'salary'),
      ];

      final result = calculator.calculate(budgets: [budget], transactions: txns);

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

      final result = calculator.calculate(budgets: [budget], transactions: txns);

      expect(result.first.spentAmount, 50000);
    });
  });

  group('skips deleted and paused budgets', () {
    test('skips paused budgets', () {
      final budget = _budget(isPaused: true);
      final txns = [_transaction(amount: 50000)];

      final result = calculator.calculate(budgets: [budget], transactions: txns);

      expect(result.first.spentAmount, 0);
    });

    test('skips deleted budgets', () {
      final budget = _budget(isDeleted: true);
      final txns = [_transaction(amount: 50000)];

      final result = calculator.calculate(budgets: [budget], transactions: txns);

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
```

- [ ] **Step 3: Run tests**

```bash
cd A:\PocketPlus
flutter test test/features/budgets/domain/budget_calculator_test.dart
```

- [ ] **Step 4: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/domain/budget_calculator.dart
git add test/features/budgets/domain/budget_calculator_test.dart
git commit -m "feat: add budget calculator with pure computation"
```

---

### Task 4: Budget Firestore Data Source

**Files:**
- Create: `lib/features/budgets/data/firestore_budget_data_source.dart`

**Interfaces:**
- Consumes: `Budget` entity, `FirebaseFirestore` from `cloud_firestore`
- Produces: `FirestoreBudgetDataSource` interface + `FirestoreBudgetDataSourceImpl`

- [ ] **Step 1: Create data source**

```dart
import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:uuid/uuid.dart';

import '../domain/entities/budget.dart';

abstract interface class FirestoreBudgetDataSource {
  Stream<List<Budget>> watchBudgets({required String userId, required String profileId});
  Future<Budget> createBudget(Budget budget);
  Future<Budget> updateBudget(Budget budget);
  Future<void> softDeleteBudget(String budgetId);
  Future<List<Budget>> getBudgetsFromCache({required String userId, required String profileId});
}

class FirestoreBudgetDataSourceImpl implements FirestoreBudgetDataSource {
  FirestoreBudgetDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;
  static const _uuid = Uuid();

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('budgets');

  Query<Map<String, dynamic>> _scoped(String userId, String profileId) => _col
      .where('userId', isEqualTo: userId)
      .where('profileId', isEqualTo: profileId)
      .where('isDeleted', isEqualTo: false);

  @override
  Stream<List<Budget>> watchBudgets({required String userId, required String profileId}) {
    return _scoped(userId, profileId).snapshots().map((snap) {
      final list = snap.docs.map((d) => Budget.fromJson(d.data())).toList();
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return list;
    });
  }

  @override
  Future<Budget> createBudget(Budget budget) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final toCreate = budget.copyWith(
      id: id,
      createdAt: now,
      updatedAt: now,
    );
    await _col.doc(id).set(toCreate.toJson());
    return toCreate;
  }

  @override
  Future<Budget> updateBudget(Budget budget) async {
    final now = DateTime.now();
    final toUpdate = budget.copyWith(updatedAt: now);
    await _col.doc(budget.id).set(toUpdate.toJson());
    return toUpdate;
  }

  @override
  Future<void> softDeleteBudget(String budgetId) async {
    await _col.doc(budgetId).update({
      'isDeleted': true,
      'deletedAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    });
  }

  @override
  Future<List<Budget>> getBudgetsFromCache({required String userId, required String profileId}) async {
    final snap = await _scoped(userId, profileId)
        .get(const GetOptions(source: Source.cache));
    return snap.docs.map((d) => Budget.fromJson(d.data())).toList();
  }
}
```

- [ ] **Step 2: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/data/firestore_budget_data_source.dart
git commit -m "feat: add budget firestore data source"
```

---

### Task 5: Budget Repository Implementation

**Files:**
- Create: `lib/features/budgets/data/budget_repository_impl.dart`

**Interfaces:**
- Consumes: `BudgetRepository` interface, `FirestoreBudgetDataSource`, `ErrorMapper`
- Produces: `BudgetRepositoryImpl`

- [ ] **Step 1: Create repository impl**

```dart
import 'package:dartz/dartz.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../domain/budget_repository.dart';
import '../domain/entities/budget.dart';
import 'firestore_budget_data_source.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._dataSource);

  final FirestoreBudgetDataSource _dataSource;

  @override
  Stream<List<Budget>> watchBudgets({required String userId, required String profileId}) {
    return _dataSource.watchBudgets(userId: userId, profileId: profileId);
  }

  @override
  Future<Either<Failure, Budget>> createBudget(Budget budget) async {
    try {
      return Right(await _dataSource.createBudget(budget));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Budget>> updateBudget(Budget budget) async {
    try {
      return Right(await _dataSource.updateBudget(budget));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> softDeleteBudget(String budgetId) async {
    try {
      await _dataSource.softDeleteBudget(budgetId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Budget>> duplicateBudget(Budget budget) async {
    try {
      final duplicate = budget.copyWith(
        id: '',
        name: '${budget.name} (Copy)',
        spentAmount: 0,
        remainingAmount: 0,
      );
      return Right(await _dataSource.createBudget(duplicate));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> togglePauseBudget(String budgetId, bool isPaused) async {
    try {
      await _dataSource.updateBudget(
        Budget(
          id: budgetId,
          userId: '',
          profileId: '',
          name: '',
          budgetType: BudgetType.category,
          categoryIds: [],
          amount: 0,
          period: BudgetPeriod.monthly,
          startDate: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isPaused: isPaused,
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<Budget>>> getBudgetsFromCache({required String userId, required String profileId}) async {
    try {
      return Right(await _dataSource.getBudgetsFromCache(userId: userId, profileId: profileId));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }
}
```

- [ ] **Step 2: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/data/budget_repository_impl.dart
git commit -m "feat: add budget repository implementation"
```

---

### Task 6: Budget Providers (Data Source + Repository + Stream Providers)

**Files:**
- Create: `lib/features/budgets/budgets_providers.dart` (data source + repo providers at feature root)
- Create: `lib/features/budgets/presentation/providers/budget_providers.dart` (computed/stream providers)

- [ ] **Step 1: Create root-level providers**

```dart
// lib/features/budgets/budgets_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/firebase_providers.dart';
import '../home/presentation/home_providers.dart';
import 'data/budget_repository_impl.dart';
import 'data/firestore_budget_data_source.dart';
import 'domain/budget_calculator.dart';
import 'domain/budget_repository.dart';
import 'domain/entities/budget.dart';

final firestoreBudgetDataSourceProvider = Provider<FirestoreBudgetDataSource>((ref) {
  return FirestoreBudgetDataSourceImpl(ref.watch(firestoreProvider));
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(ref.watch(firestoreBudgetDataSourceProvider));
});

final budgetCalculatorProvider = Provider<BudgetCalculator>((ref) {
  return BudgetCalculator();
});
```

- [ ] **Step 2: Create presentation-level providers**

```dart
// lib/features/budgets/presentation/providers/budget_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

import '../../../../shared/providers/firebase_providers.dart';
import '../../../home/presentation/home_providers.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/transactions_providers.dart';
import '../../budgets_providers.dart';
import '../../domain/budget_calculator.dart';
import '../../domain/budget_repository.dart';
import '../../domain/entities/budget.dart';

final budgetsStreamProvider = StreamProvider.autoDispose<List<Budget>>((ref) {
  final currentProfile = ref.watch(currentProfileProvider);
  final userId = ref.watch(currentBookUserIdProvider);
  if (userId == null || currentProfile == null) {
    return const Stream.empty();
  }
  return ref.watch(budgetRepositoryProvider).watchBudgets(
    userId: userId,
    profileId: currentProfile.id,
  );
});

final calculatedBudgetsProvider = Provider.autoDispose<List<Budget>>((ref) {
  final budgets = ref.watch(budgetsStreamProvider).valueOr([]);
  final transactions = ref.watch(allTransactionsStreamProvider).valueOr([]);
  final calculator = ref.watch(budgetCalculatorProvider);
  return calculator.calculate(budgets: budgets, transactions: transactions);
});

final activeBudgetsProvider = Provider.autoDispose<List<Budget>>((ref) {
  final budgets = ref.watch(calculatedBudgetsProvider);
  return budgets.where((b) => !b.isPaused && !b.isDeleted).toList();
});

final pausedBudgetsProvider = Provider.autoDispose<List<Budget>>((ref) {
  final budgets = ref.watch(budgetsStreamProvider).valueOr([]);
  return budgets.where((b) => b.isPaused).toList();
});

final topBudgetsProvider = Provider.autoDispose<List<Budget>>((ref) {
  final budgets = ref.watch(calculatedBudgetsProvider);
  return budgets.take(3).toList();
});

final budgetByIdProvider = Provider.autoDispose.family<Budget?, String>((ref, id) {
  final budgets = ref.watch(calculatedBudgetsProvider);
  return budgets.where((b) => b.id == id).firstOrNull;
});

final budgetVsActualProvider = Provider.autoDispose.family<({int budgetAmount, int spentAmount, double percentage})?, String>(
  (ref, budgetId) {
    final budget = ref.watch(budgetByIdProvider(budgetId));
    if (budget == null) return null;
    return (
      budgetAmount: budget.amount,
      spentAmount: budget.spentAmount,
      percentage: ref.watch(budgetCalculatorProvider).computePercentage(budget).toDouble(),
    );
  },
);
```

- [ ] **Step 3: Ensure collection dependency works**

Check that `allTransactionsStreamProvider` exists. If not, we need to add it to `lib/features/transactions/transactions_providers.dart`:

```dart
final allTransactionsStreamProvider = StreamProvider.autoDispose<List<Transaction>>((ref) {
  final currentProfile = ref.watch(currentProfileProvider);
  final userId = ref.watch(currentBookUserIdProvider);
  if (userId == null || currentProfile == null) {
    return const Stream.empty();
  }
  return ref.watch(transactionRepositoryProvider).watchTransactions(
    userId: userId,
    profileId: currentProfile.id,
  );
});
```

- [ ] **Step 4: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/budgets_providers.dart
git add lib/features/budgets/presentation/providers/budget_providers.dart
git add lib/features/transactions/transactions_providers.dart
git commit -m "feat: add budget providers with reactive calculation"
```

---

### Task 7: Reusable Budget Widgets

**Files:**
- Create: All 10 widget files under `lib/features/budgets/presentation/widgets/`

- [ ] **Step 1: Create barrel export**

```dart
// lib/features/budgets/presentation/widgets/widgets.dart
export 'budget_card.dart';
export 'budget_progress_bar.dart';
export 'circular_budget_indicator.dart';
export 'budget_status_chip.dart';
export 'remaining_amount_card.dart';
export 'budget_empty_state.dart';
export 'budget_skeleton_loader.dart';
export 'budget_filter_chips.dart';
export 'budget_insight_card.dart';
export 'budget_forecast_card.dart';
```

- [ ] **Step 2: Create budget_progress_bar.dart**

```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../domain/entities/budget.dart';

class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({
    required this.budget,
    super.key,
    this.height = 12,
    this.showPercentage = true,
  });

  final Budget budget;
  final double height;
  final bool showPercentage;

  @override
  Widget build(BuildContext context) {
    final calculator = BudgetCalculator();
    final percentage = calculator.computePercentage(budget);
    final status = calculator.computeStatus(budget);
    final color = _colorForStatus(status);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spacing4),
            child: Text(
              '$percentage%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: percentage / 100.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value.clamp(0.0, 1.0),
                backgroundColor: AppColors.outline.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: height,
                borderRadius: BorderRadius.circular(height / 2),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _colorForStatus(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe: return AppColors.income;
      case BudgetStatus.warning: return AppColors.orange;
      case BudgetStatus.critical: return AppColors.warning;
      case BudgetStatus.exceeded: return AppColors.error;
    }
  }
}
```

- [ ] **Step 3: Create budget_status_chip.dart**

```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../domain/budget_calculator.dart';
import '../../../domain/entities/budget.dart';

class BudgetStatusChip extends StatelessWidget {
  const BudgetStatusChip({required this.budget, super.key});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final calculator = BudgetCalculator();
    final status = calculator.computeStatus(budget);
    final percentage = calculator.computePercentage(budget);
    final (label, color, icon) = switch (status) {
      BudgetStatus.safe => ('Safe', AppColors.income, Icons.check_circle),
      BudgetStatus.warning => ('Warning', AppColors.orange, Icons.warning_amber_rounded),
      BudgetStatus.critical => ('Critical', AppColors.warning, Icons.error_outline),
      BudgetStatus.exceeded => ('Exceeded', AppColors.error, Icons.gpp_bad),
    };

    final displayLabel = status == BudgetStatus.exceeded
        ? 'Exceeded by ${(percentage - 100)}%'
        : '$label · $percentage%';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.spacing8,
        vertical: AppSizes.spacing4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSizes.spacing20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            displayLabel,
            style: AppTextStyles.labelSmall(context, color: color),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Create budget_card.dart**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../domain/budget_calculator.dart';
import '../../../domain/entities/budget.dart';
import 'budget_progress_bar.dart';
import 'budget_status_chip.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({required this.budget, super.key});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final calculator = BudgetCalculator();
    final status = calculator.computeStatus(budget);
    final percentage = calculator.computePercentage(budget);
    final daysElapsed = calculator.computeDaysElapsed(budget);

    return AppCard(
      onTap: () => context.push(RouteNames.budgetDetail(budget.id)),
      padding: const EdgeInsets.all(AppSizes.spacing16),
      margin: const EdgeInsets.only(bottom: AppSizes.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _parseColor(budget.colorHex).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSizes.spacing10),
                ),
                child: Icon(
                  _iconData(budget.icon),
                  color: _parseColor(budget.colorHex),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      budget.name,
                      style: AppTextStyles.titleSmall(context),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      budget.budgetType == BudgetType.overall
                          ? 'Overall Spending'
                          : budget.budgetType == BudgetType.custom
                              ? '${budget.categoryIds.length} Categories'
                              : budget.categoryIds.isNotEmpty
                                  ? 'Category Budget'
                                  : 'Budget',
                      style: AppTextStyles.bodySmall(context, color: AppColors.onSurfaceMuted),
                    ),
                  ],
                ),
              ),
              BudgetStatusChip(budget: budget),
            ],
          ),
          const SizedBox(height: AppSizes.spacing16),
          BudgetProgressBar(budget: budget),
          const SizedBox(height: AppSizes.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _amountColumn(
                context,
                'Spent',
                CurrencyFormatter.format(budget.spentAmount),
                _colorForStatus(status),
              ),
              _amountColumn(
                context,
                'Remaining',
                CurrencyFormatter.format(budget.remainingAmount),
                budget.remainingAmount > 0 ? AppColors.income : AppColors.error,
              ),
              _amountColumn(
                context,
                'Budget',
                CurrencyFormatter.format(budget.amount),
                AppColors.onSurface,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.spacing8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: AppColors.onSurfaceMuted),
              const SizedBox(width: 4),
              Text(
                '${_periodLabel(budget.period)} · $daysElapsed days elapsed',
                style: AppTextStyles.bodySmall(context, color: AppColors.onSurfaceMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _amountColumn(BuildContext context, String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelSmall(context, color: AppColors.onSurfaceMuted)),
        const SizedBox(height: 2),
        Text(
          amount,
          style: AppTextStyles.bodyMedium(context, color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Color _colorForStatus(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe: return AppColors.income;
      case BudgetStatus.warning: return AppColors.orange;
      case BudgetStatus.critical: return AppColors.warning;
      case BudgetStatus.exceeded: return AppColors.error;
    }
  }

  Color _parseColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  IconData _iconData(String iconName) {
    switch (iconName) {
      case 'account_balance_wallet': return Icons.account_balance_wallet;
      case 'restaurant': return Icons.restaurant;
      case 'directions_car': return Icons.directions_car;
      case 'home': return Icons.home;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'flight': return Icons.flight;
      case 'local_gas_station': return Icons.local_gas_station;
      case 'medical_services': return Icons.medical_services;
      case 'school': return Icons.school;
      case 'work': return Icons.work;
      case 'sports_esports': return Icons.sports_esports;
      case 'subscriptions': return Icons.subscriptions;
      case 'movie': return Icons.movie;
      case 'checkroom': return Icons.checkroom;
      case 'pets': return Icons.pets;
      case 'fitness_center': return Icons.fitness_center;
      case 'card_giftcard': return Icons.card_giftcard;
      case 'phone_android': return Icons.phone_android;
      case 'water_drop': return Icons.water_drop;
      case 'bolt': return Icons.bolt;
      default: return Icons.account_balance_wallet;
    }
  }

  String _periodLabel(BudgetPeriod period) {
    switch (period) {
      case BudgetPeriod.weekly: return 'Weekly';
      case BudgetPeriod.monthly: return 'Monthly';
      case BudgetPeriod.yearly: return 'Yearly';
    }
  }
}
```

- [ ] **Step 5: Create circular_budget_indicator.dart**

```dart
import 'dart:math';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../domain/budget_calculator.dart';
import '../../../domain/entities/budget.dart';

class CircularBudgetIndicator extends StatelessWidget {
  const CircularBudgetIndicator({
    required this.budget,
    super.key,
    this.size = 100,
    this.strokeWidth = 8,
  });

  final Budget budget;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final calculator = BudgetCalculator();
    final percentage = calculator.computePercentage(budget);
    final status = calculator.computeStatus(budget);
    final color = _colorForStatus(status);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CircularProgressPainter(
          percentage: percentage / 100.0,
          color: color,
          backgroundColor: AppColors.outline.withValues(alpha: 0.2),
          strokeWidth: strokeWidth,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                CurrencyFormatter.format(budget.spentAmount, symbol: ''),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _colorForStatus(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe: return AppColors.income;
      case BudgetStatus.warning: return AppColors.orange;
      case BudgetStatus.critical: return AppColors.warning;
      case BudgetStatus.exceeded: return AppColors.error;
    }
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.percentage,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  final double percentage;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final sweepAngle = (percentage * 2 * pi).clamp(0, 2 * pi);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter old) =>
      old.percentage != percentage || old.color != color;
}
```

- [ ] **Step 6: Create remaining_amount_card.dart**

```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../domain/budget_calculator.dart';
import '../../../domain/entities/budget.dart';

class RemainingAmountCard extends StatelessWidget {
  const RemainingAmountCard({required this.budget, super.key});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final calculator = BudgetCalculator();
    final dailyAvg = calculator.computeDailyAverage(budget);
    final dailyAllowance = calculator.computeRemainingDailyAllowance(budget);
    final status = calculator.computeStatus(budget);

    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Remaining', style: AppTextStyles.titleSmall(context)),
          const SizedBox(height: AppSizes.spacing8),
          Text(
            CurrencyFormatter.format(budget.remainingAmount),
            style: AppTextStyles.headlineMedium(context, color: budget.remainingAmount > 0 ? AppColors.income : AppColors.error),
          ),
          const SizedBox(height: AppSizes.spacing12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoChip(context, 'Daily Avg', CurrencyFormatter.format(dailyAvg)),
              _infoChip(context, 'Daily Allowance', CurrencyFormatter.format(dailyAllowance)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.labelSmall(context, color: AppColors.onSurfaceMuted)),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.bodyMedium(context, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
```

- [ ] **Step 7: Create budget_empty_state.dart**

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/widgets/app_button.dart';

class BudgetEmptyState extends StatelessWidget {
  const BudgetEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppSizes.spacing24),
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                size: 60,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: AppSizes.spacing24),
            Text(
              'No budgets yet',
              style: AppTextStyles.titleMedium(context),
            ),
            const SizedBox(height: AppSizes.spacing8),
            Text(
              'Create your first budget to start tracking your spending and saving more.',
              style: AppTextStyles.bodyMedium(context, color: AppColors.onSurfaceMuted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.spacing24),
            AppButton(
              label: 'Create Your First Budget',
              onPressed: () => context.push(RouteNames.budgetsNew),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 8: Create budget_skeleton_loader.dart**

```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/loading_shimmer.dart';

class BudgetSkeletonLoader extends StatelessWidget {
  const BudgetSkeletonLoader({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: AppSizes.spacing12),
          child: LoadingShimmer(
            height: 160,
            borderRadius: BorderRadius.all(Radius.circular(AppSizes.spacing12)),
          ),
        );
      }),
    );
  }
}
```

- [ ] **Step 9: Create budget_filter_chips.dart**

```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/budget.dart';

class BudgetFilterChips extends StatelessWidget {
  const BudgetFilterChips({
    required this.selectedPeriod,
    required this.onSelected,
    super.key,
  });

  final BudgetPeriod? selectedPeriod;
  final void Function(BudgetPeriod?) onSelected;

  static const _periods = <BudgetPeriod?>[null, BudgetPeriod.weekly, BudgetPeriod.monthly, BudgetPeriod.yearly];

  String _label(BudgetPeriod? period) {
    switch (period) {
      case null: return 'All';
      case BudgetPeriod.weekly: return 'Weekly';
      case BudgetPeriod.monthly: return 'Monthly';
      case BudgetPeriod.yearly: return 'Yearly';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
      child: Row(
        children: _periods.map((period) {
          final isSelected = selectedPeriod == period;
          return Padding(
            padding: const EdgeInsets.only(right: AppSizes.spacing8),
            child: FilterChip(
              label: Text(
                _label(period),
                style: AppTextStyles.labelMedium(
                  context,
                  color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onSelected(period),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.card,
              checkmarkColor: AppColors.onPrimary,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.outline,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
```

- [ ] **Step 10: Create budget_forecast_card.dart**

```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../domain/budget_calculator.dart';
import '../../../domain/entities/budget.dart';

class BudgetForecastCard extends StatelessWidget {
  const BudgetForecastCard({required this.budget, super.key});

  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final calculator = BudgetCalculator();
    final forecast = calculator.computeForecast(budget);
    final exceeds = forecast > budget.amount;
    final variance = (forecast - budget.amount).abs();

    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                exceeds ? Icons.trending_up : Icons.trending_down,
                color: exceeds ? AppColors.error : AppColors.income,
                size: 20,
              ),
              const SizedBox(width: AppSizes.spacing8),
              Text('Forecast', style: AppTextStyles.titleSmall(context)),
            ],
          ),
          const SizedBox(height: AppSizes.spacing8),
          Text(
            'Projected spend: ${CurrencyFormatter.format(forecast)}',
            style: AppTextStyles.bodyLarge(context, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSizes.spacing4),
          Text(
            exceeds
                ? 'Likely to exceed by ${CurrencyFormatter.format(variance)}'
                : 'On track to save ${CurrencyFormatter.format(variance)}',
            style: AppTextStyles.bodyMedium(
              context,
              color: exceeds ? AppColors.error : AppColors.income,
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 11: Create budget_insight_card.dart**

```dart
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';

class BudgetInsightCard extends StatelessWidget {
  const BudgetInsightCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
    this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacing12),
      margin: const EdgeInsets.only(bottom: AppSizes.spacing8),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: c.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppSizes.spacing8),
            ),
            child: Icon(icon, color: c, size: 18),
          ),
          const SizedBox(width: AppSizes.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelMedium(context, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall(context, color: AppColors.onSurfaceMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 12: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/presentation/widgets/
git commit -m "feat: add reusable budget widgets"
```

---

### Task 8: Budget ViewModel

**Files:**
- Create: `lib/features/budgets/presentation/budget_view_model.dart`

- [ ] **Step 1: Create freezed state and notifier**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/failures.dart';
import '../../../core/router/route_names.dart';
import '../budgets_providers.dart';
import '../domain/budget_repository.dart';
import '../domain/entities/budget.dart';

part 'budget_view_model.freezed.dart';

@freezed
abstract class BudgetListState with _$BudgetListState {
  const factory BudgetListState({
    @Default([]) List<Budget> budgets,
    @Default(false) bool isLoading,
    String? error,
  }) = _BudgetListState;
}

@freezed
abstract class CreateBudgetState with _$CreateBudgetState {
  const factory CreateBudgetState({
    required String name,
    required BudgetType budgetType,
    required List<String> selectedCategoryIds,
    required String amountString,
    required BudgetPeriod period,
    required DateTime startDate,
    DateTime? endDate,
    @Default('#4CAF50') String colorHex,
    @Default('account_balance_wallet') String icon,
    @Default(80.0) double alertThreshold,
    @Default(true) bool notificationsEnabled,
    String? notes,
    @Default(false) bool isSaving,
    @Default(false) bool isEditing,
    String? saveError,
    String? nameError,
    String? amountError,
    String? categoryError,
  }) = _CreateBudgetState;
}

class BudgetListViewModel extends Notifier<BudgetListState> {
  @override
  BudgetListState build() {
    return const BudgetListState();
  }

  void updateBudgets(List<Budget> budgets) {
    state = state.copyWith(budgets: budgets, isLoading: false);
  }

  void setError(String error) {
    state = state.copyWith(error: error, isLoading: false);
  }

  void navigateToCreate(BuildContext context) {
    context.push(RouteNames.budgetsNew);
  }

  void navigateToDetail(BuildContext context, String budgetId) {
    context.push(RouteNames.budgetDetail(budgetId));
  }
}

final budgetListViewModelProvider =
    NotifierProvider<BudgetListViewModel, BudgetListState>(
  BudgetListViewModel.new,
);

class CreateBudgetViewModel extends Notifier<CreateBudgetState> {
  @override
  CreateBudgetState build() {
    return CreateBudgetState(
      name: '',
      budgetType: BudgetType.category,
      selectedCategoryIds: [],
      amountString: '',
      period: BudgetPeriod.monthly,
      startDate: DateTime.now(),
    );
  }

  void editFrom(Budget budget) {
    state = CreateBudgetState(
      name: budget.name,
      budgetType: budget.budgetType,
      selectedCategoryIds: budget.categoryIds,
      amountString: (budget.amount / 100).toStringAsFixed(0),
      period: budget.period,
      startDate: budget.startDate,
      endDate: budget.endDate,
      colorHex: budget.colorHex,
      icon: budget.icon,
      alertThreshold: budget.alertThreshold.toDouble(),
      notificationsEnabled: budget.notificationsEnabled,
      notes: budget.notes,
      isEditing: true,
    );
  }

  void setName(String value) => state = state.copyWith(name: value, nameError: null);
  void setBudgetType(BudgetType value) => state = state.copyWith(budgetType: value, categoryError: null);
  void setAmount(String value) => state = state.copyWith(amountString: value, amountError: null);
  void setPeriod(BudgetPeriod value) => state = state.copyWith(period: value);
  void setStartDate(DateTime value) => state = state.copyWith(startDate: value);
  void setEndDate(DateTime? value) => state = state.copyWith(endDate: value);
  void setColorHex(String value) => state = state.copyWith(colorHex: value);
  void setIcon(String value) => state = state.copyWith(icon: value);
  void setAlertThreshold(double value) => state = state.copyWith(alertThreshold: value);
  void setNotificationsEnabled(bool value) => state = state.copyWith(notificationsEnabled: value);
  void setNotes(String value) => state = state.copyWith(notes: value);

  void toggleCategoryId(String id) {
    final ids = List<String>.from(state.selectedCategoryIds);
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    state = state.copyWith(selectedCategoryIds: ids, categoryError: null);
  }

  bool _validate() {
    String? nameError;
    String? amountError;
    String? categoryError;

    if (state.name.trim().isEmpty) {
      nameError = 'Budget name is required';
    }
    final amount = int.tryParse(state.amountString.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      amountError = 'Enter a valid amount greater than 0';
    }
    if (state.budgetType == BudgetType.category && state.selectedCategoryIds.isEmpty) {
      categoryError = 'Select a category';
    }

    state = state.copyWith(
      nameError: nameError,
      amountError: amountError,
      categoryError: categoryError,
    );
    return nameError == null && amountError == null && categoryError == null;
  }

  Future<bool> save() async {
    if (!_validate()) return false;

    state = state.copyWith(isSaving: true, saveError: null);

    final amount = (int.tryParse(state.amountString.replaceAll(',', '')) ?? 0) * 100;

    final budgetRepository = ref.read(budgetRepositoryProvider);

    final budget = Budget(
      id: '',
      userId: '',
      profileId: '',
      name: state.name.trim(),
      budgetType: state.budgetType,
      categoryIds: state.selectedCategoryIds,
      amount: amount,
      period: state.period,
      startDate: state.startDate,
      endDate: state.endDate,
      colorHex: state.colorHex,
      icon: state.icon,
      alertThreshold: state.alertThreshold.round(),
      notificationsEnabled: state.notificationsEnabled,
      notes: state.notes?.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = state.isEditing
        ? await budgetRepository.updateBudget(budget)
        : await budgetRepository.createBudget(budget);

    return result.fold(
      (failure) {
        state = state.copyWith(isSaving: false, saveError: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isSaving: false);
        return true;
      },
    );
  }
}

final createBudgetViewModelProvider =
    NotifierProvider.autoDispose<CreateBudgetViewModel, CreateBudgetState>(
  CreateBudgetViewModel.new,
);

// Budget detail actions
enum BudgetAction { edit, delete, pause, resume, duplicate }

class BudgetDetailActionNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> delete(String budgetId) async {
    state = const AsyncValue.loading();
    final result = await ref.read(budgetRepositoryProvider).softDeleteBudget(budgetId);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }

  Future<void> togglePause(String budgetId, bool isPaused) async {
    state = const AsyncValue.loading();
    final result = await ref.read(budgetRepositoryProvider).togglePauseBudget(budgetId, isPaused);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) => const AsyncValue.data(null),
    );
  }

  Future<void> duplicate(Budget budget, BuildContext context) async {
    state = const AsyncValue.loading();
    final result = await ref.read(budgetRepositoryProvider).duplicateBudget(budget);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (_) {
        context.pop();
        return const AsyncValue.data(null);
      },
    );
  }
}

final budgetDetailActionProvider =
    AutoDisposeNotifierProvider<BudgetDetailActionNotifier, AsyncValue<void>>(
  BudgetDetailActionNotifier.new,
);
```

- [ ] **Step 2: Run build_runner**

```bash
cd A:\PocketPlus
dart run build_runner build --delete-conflicting-outputs
```

- [ ] **Step 3: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/presentation/budget_view_model.dart
git add lib/features/budgets/presentation/budget_view_model.freezed.dart
git commit -m "feat: add budget viewmodel with create/list/detail states"
```

---

### Task 9: Create Budget Screen (Form)

**Files:**
- Create: `lib/features/budgets/presentation/screens/create_budget_screen.dart`

- [ ] **Step 1: Create the create/edit screen**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/pocketplus_loader.dart';
import '../../../categories/categories_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../domain/entities/budget.dart';
import '../budget_view_model.dart';

class CreateBudgetScreen extends ConsumerStatefulWidget {
  const CreateBudgetScreen({super.key, this.editBudgetId});

  final String? editBudgetId;

  @override
  ConsumerState<CreateBudgetScreen> createState() => _CreateBudgetScreenState();
}

class _CreateBudgetScreenState extends ConsumerState<CreateBudgetScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.editBudgetId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final budget = ref.read(budgetByIdProvider(widget.editBudgetId!));
        if (budget != null) {
          ref.read(createBudgetViewModelProvider.notifier).editFrom(budget);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createBudgetViewModelProvider);
    final notifier = ref.read(createBudgetViewModelProvider.notifier);
    final categories = ref.watch(categoriesProvider).valueOr([]);
    final isLoading = ref.watch(categoriesProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(state.isEditing ? 'Edit Budget' : 'Create Budget'),
      ),
      body: isLoading
          ? const Center(child: PocketPlusLoader())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader(context, 'Basic Information'),
                  const SizedBox(height: AppSizes.spacing12),
                  AppTextField(
                    label: 'Budget Name',
                    hint: 'e.g. Monthly Groceries',
                    errorText: state.nameError,
                    onChanged: notifier.setName,
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: state.name,
                        selection: TextSelection.collapsed(offset: state.name.length),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing16),
                  _budgetTypeSelector(context, state, notifier),
                  const SizedBox(height: AppSizes.spacing16),
                  if (state.budgetType != BudgetType.overall) ...[
                    _categorySelector(context, state, notifier, categories),
                    const SizedBox(height: AppSizes.spacing16),
                  ],
                  _sectionHeader(context, 'Budget Details'),
                  const SizedBox(height: AppSizes.spacing12),
                  AppTextField(
                    label: 'Amount (₹)',
                    hint: 'e.g. 10000',
                    keyboardType: TextInputType.number,
                    errorText: state.amountError,
                    onChanged: notifier.setAmount,
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: state.amountString,
                        selection: TextSelection.collapsed(offset: state.amountString.length),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.spacing16),
                  _periodSelector(context, state, notifier),
                  const SizedBox(height: AppSizes.spacing16),
                  _dateRangePicker(context, state, notifier),
                  const SizedBox(height: AppSizes.spacing24),
                  _sectionHeader(context, 'Appearance'),
                  const SizedBox(height: AppSizes.spacing12),
                  _colorPicker(context, state, notifier),
                  const SizedBox(height: AppSizes.spacing16),
                  _iconPicker(context, state, notifier),
                  const SizedBox(height: AppSizes.spacing24),
                  _sectionHeader(context, 'Alerts'),
                  const SizedBox(height: AppSizes.spacing12),
                  _thresholdSlider(context, state, notifier),
                  const SizedBox(height: AppSizes.spacing16),
                  _notificationsToggle(context, state, notifier),
                  const SizedBox(height: AppSizes.spacing16),
                  AppTextField(
                    label: 'Notes (optional)',
                    hint: 'Add any notes...',
                    onChanged: notifier.setNotes,
                    maxLength: 200,
                    controller: TextEditingController.fromValue(
                      TextEditingValue(
                        text: state.notes ?? '',
                        selection: TextSelection.collapsed(offset: (state.notes ?? '').length),
                      ),
                    ),
                  ),
                  if (state.saveError != null) ...[
                    const SizedBox(height: AppSizes.spacing12),
                    Text(
                      state.saveError!,
                      style: AppTextStyles.bodyMedium(context, color: AppColors.error),
                    ),
                  ],
                  const SizedBox(height: AppSizes.spacing32),
                  AppButton(
                    label: state.isEditing ? 'Update Budget' : 'Create Budget',
                    onPressed: () async {
                      final success = await notifier.save();
                      if (success && mounted) context.pop();
                    },
                    isLoading: state.isSaving,
                  ),
                  const SizedBox(height: AppSizes.spacing32),
                ],
              ),
            ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.titleSmall(context, fontWeight: FontWeight.w600),
    );
  }

  Widget _budgetTypeSelector(BuildContext context, CreateBudgetState state, CreateBudgetViewModel notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Budget Type', style: AppTextStyles.labelLarge(context)),
        const SizedBox(height: AppSizes.spacing8),
        Wrap(
          spacing: AppSizes.spacing8,
          children: BudgetType.values.map((type) {
            final isSelected = state.budgetType == type;
            final label = switch (type) {
              BudgetType.category => 'Category',
              BudgetType.overall => 'Overall',
              BudgetType.custom => 'Custom',
            };
            final icon = switch (type) {
              BudgetType.category => Icons.category,
              BudgetType.overall => Icons.account_balance_wallet,
              BudgetType.custom => Icons.dashboard_customize,
            };
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: isSelected ? AppColors.onPrimary : AppColors.onSurface),
                  const SizedBox(width: 4),
                  Text(label),
                ],
              ),
              selected: isSelected,
              onSelected: (val) => notifier.setBudgetType(type),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.card,
              labelStyle: AppTextStyles.labelMedium(
                context,
                color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
              ),
              side: BorderSide(color: isSelected ? AppColors.primary : AppColors.outline),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _categorySelector(BuildContext context, CreateBudgetState state, CreateBudgetViewModel notifier, List<Category> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          state.budgetType == BudgetType.category ? 'Category' : 'Categories',
          style: AppTextStyles.labelLarge(context),
        ),
        if (state.categoryError != null)
          Text(
            state.categoryError!,
            style: AppTextStyles.bodySmall(context, color: AppColors.error),
          ),
        const SizedBox(height: AppSizes.spacing8),
        Wrap(
          spacing: AppSizes.spacing8,
          runSpacing: AppSizes.spacing8,
          children: categories.map((cat) {
            final isSelected = state.selectedCategoryIds.contains(cat.id);
            return FilterChip(
              label: Text(cat.name),
              selected: isSelected,
              onSelected: (_) => notifier.toggleCategoryId(cat.id),
              selectedColor: AppColors.primaryLight,
              checkmarkColor: AppColors.primary,
              side: BorderSide(color: isSelected ? AppColors.primary : AppColors.outline),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _periodSelector(BuildContext context, CreateBudgetState state, CreateBudgetViewModel notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Period', style: AppTextStyles.labelLarge(context)),
        const SizedBox(height: AppSizes.spacing8),
        SegmentedButton<BudgetPeriod>(
          segments: [
            ButtonSegment(value: BudgetPeriod.weekly, label: const Text('Weekly')),
            ButtonSegment(value: BudgetPeriod.monthly, label: const Text('Monthly')),
            ButtonSegment(value: BudgetPeriod.yearly, label: const Text('Yearly')),
          ],
          selected: {state.period},
          onSelectionChanged: (set) => notifier.setPeriod(set.first),
        ),
      ],
    );
  }

  Widget _dateRangePicker(BuildContext context, CreateBudgetState state, CreateBudgetViewModel notifier) {
    return Row(
      children: [
        Expanded(
          child: _dateButton(context, 'Start Date', state.startDate, () async {
            final date = await showDatePicker(
              context: context,
              initialDate: state.startDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
            );
            if (date != null) notifier.setStartDate(date);
          }),
        ),
        const SizedBox(width: AppSizes.spacing12),
        Expanded(
          child: _dateButton(context, 'End Date (optional)', state.endDate, () async {
            final date = await showDatePicker(
              context: context,
              initialDate: state.endDate ?? state.startDate.add(const Duration(days: 30)),
              firstDate: state.startDate,
              lastDate: DateTime(2035),
            );
            if (date != null) notifier.setEndDate(date);
          }),
        ),
      ],
    );
  }

  Widget _dateButton(BuildContext context, String label, DateTime? date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.spacing8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.card,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.spacing8),
            borderSide: const BorderSide(color: AppColors.outline),
          ),
        ),
        child: Text(
          date != null
              ? '${date.day}/${date.month}/${date.year}'
              : 'Not set',
          style: AppTextStyles.bodyMedium(context),
        ),
      ),
    );
  }

  Widget _colorPicker(BuildContext context, CreateBudgetState state, CreateBudgetViewModel notifier) {
    const colors = [
      '#4CAF50', '#2196F3', '#FF9800', '#F44336',
      '#9C27B0', '#00BCD4', '#FF5722', '#607D8B',
      '#E91E63', '#3F51B5', '#009688', '#795548',
    ];

    return Wrap(
      spacing: AppSizes.spacing8,
      runSpacing: AppSizes.spacing8,
      children: colors.map((hex) {
        final isSelected = state.colorHex == hex;
        final color = Color(int.parse('FF${hex.replaceFirst('#', '')}', radix: 16));
        return GestureDetector(
          onTap: () => notifier.setColorHex(hex),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.onSurface, width: 3)
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _iconPicker(BuildContext context, CreateBudgetState state, CreateBudgetViewModel notifier) {
    const icons = [
      'account_balance_wallet', 'restaurant', 'directions_car', 'home',
      'shopping_cart', 'flight', 'local_gas_station', 'medical_services',
      'school', 'work', 'sports_esports', 'subscriptions',
      'movie', 'checkroom', 'pets', 'fitness_center',
    ];

    return Wrap(
      spacing: AppSizes.spacing8,
      runSpacing: AppSizes.spacing8,
      children: icons.map((iconName) {
        final isSelected = state.icon == iconName;
        return GestureDetector(
          onTap: () => notifier.setIcon(iconName),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryLight
                  : AppColors.card,
              borderRadius: BorderRadius.circular(AppSizes.spacing8),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.outline,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              _iconData(iconName),
              color: isSelected ? AppColors.primary : AppColors.onSurface,
              size: 22,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _thresholdSlider(BuildContext context, CreateBudgetState state, CreateBudgetViewModel notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alert at ${state.alertThreshold.round()}%', style: AppTextStyles.labelLarge(context)),
        Slider(
          value: state.alertThreshold,
          min: 50,
          max: 100,
          divisions: 10,
          label: '${state.alertThreshold.round()}%',
          onChanged: notifier.setAlertThreshold,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _notificationsToggle(BuildContext context, CreateBudgetState state, CreateBudgetViewModel notifier) {
    return SwitchListTile(
      title: const Text('Enable Notifications'),
      subtitle: const Text('Get notified when approaching budget limits'),
      value: state.notificationsEnabled,
      onChanged: notifier.setNotificationsEnabled,
      activeColor: AppColors.primary,
    );
  }

  IconData _iconData(String iconName) {
    switch (iconName) {
      case 'account_balance_wallet': return Icons.account_balance_wallet;
      case 'restaurant': return Icons.restaurant;
      case 'directions_car': return Icons.directions_car;
      case 'home': return Icons.home;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'flight': return Icons.flight;
      case 'local_gas_station': return Icons.local_gas_station;
      case 'medical_services': return Icons.medical_services;
      case 'school': return Icons.school;
      case 'work': return Icons.work;
      case 'sports_esports': return Icons.sports_esports;
      case 'subscriptions': return Icons.subscriptions;
      case 'movie': return Icons.movie;
      case 'checkroom': return Icons.checkroom;
      case 'pets': return Icons.pets;
      case 'fitness_center': return Icons.fitness_center;
      default: return Icons.account_balance_wallet;
    }
  }
}
```

- [ ] **Step 2: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/presentation/screens/create_budget_screen.dart
git commit -m "feat: add create/edit budget screen with full form"
```

---

### Task 10: Budget List Screen (Main Tab)

**Files:**
- Create: `lib/features/budgets/presentation/screens/budget_list_screen.dart`

- [ ] **Step 1: Create budget list screen**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/route_names.dart';
import '../../domain/entities/budget.dart';
import '../providers/budget_providers.dart';
import '../widgets/budget_card.dart';
import '../widgets/budget_empty_state.dart';
import '../widgets/budget_filter_chips.dart';
import '../widgets/budget_skeleton_loader.dart';

class BudgetListScreen extends ConsumerStatefulWidget {
  const BudgetListScreen({super.key});

  @override
  ConsumerState<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends ConsumerState<BudgetListScreen> {
  BudgetPeriod? _selectedPeriod;

  @override
  Widget build(BuildContext context) {
    final asyncBudgets = ref.watch(calculatedBudgetsProvider);
    final paused = ref.watch(pausedBudgetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push(RouteNames.budgetsNew),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(budgetsStreamProvider);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSizes.spacing8),
            BudgetFilterChips(
              selectedPeriod: _selectedPeriod,
              onSelected: (period) => setState(() => _selectedPeriod = period),
            ),
            const SizedBox(height: AppSizes.spacing8),
            Expanded(
              child: _buildContent(context, asyncBudgets, paused),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Budget> budgets, List<Budget> paused) {
    if (budgets.isEmpty && paused.isEmpty) {
      return const BudgetEmptyState();
    }

    var filtered = budgets;
    if (_selectedPeriod != null) {
      filtered = budgets.where((b) => b.period == _selectedPeriod).toList();
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacing16),
      children: [
        if (filtered.isEmpty && budgets.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSizes.spacing32),
            child: Center(
              child: Text(
                'No budgets match this filter',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceMuted,
                ),
              ),
            ),
          ),
        ...filtered.map((budget) => BudgetCard(budget: budget)),
        if (paused.isNotEmpty) ...[
          const SizedBox(height: AppSizes.spacing16),
          Text(
            'Paused',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.onSurfaceMuted,
            ),
          ),
          const SizedBox(height: AppSizes.spacing8),
          ...paused.map((budget) => BudgetCard(budget: budget)),
        ],
        const SizedBox(height: AppSizes.spacing80), // FAB padding
      ],
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/presentation/screens/budget_list_screen.dart
git commit -m "feat: add budget list screen with filtering"
```

---

### Task 11: Budget Detail Screen

**Files:**
- Create: `lib/features/budgets/presentation/screens/budget_detail_screen.dart`

- [ ] **Step 1: Create budget detail screen**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../categories/categories_providers.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../transactions/transactions_providers.dart';
import '../../../transactions/presentation/widgets/transaction_list_tile.dart';
import '../../domain/budget_calculator.dart';
import '../../domain/entities/budget.dart';
import '../budget_view_model.dart';
import '../providers/budget_providers.dart';
import '../widgets/budget_card.dart';
import '../widgets/budget_forecast_card.dart';
import '../widgets/budget_insight_card.dart';
import '../widgets/budget_progress_bar.dart';
import '../widgets/budget_status_chip.dart';
import '../widgets/circular_budget_indicator.dart';
import '../widgets/remaining_amount_card.dart';

class BudgetDetailScreen extends ConsumerWidget {
  const BudgetDetailScreen({required this.budgetId, super.key});

  final String budgetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(budgetByIdProvider(budgetId));
    if (budget == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Budget not found')),
      );
    }

    final calculator = BudgetCalculator();
    final forecast = calculator.computeForecast(budget);
    final dailyAvg = calculator.computeDailyAverage(budget);
    final weeklyAvg = calculator.computeWeeklyAverage(budget);
    final daysElapsed = calculator.computeDaysElapsed(budget);
    final totalDays = calculator.computeTotalDays(budget);
    final transactions = ref.watch(allTransactionsStreamProvider).valueOr([]);

    // Filter transactions contributing to this budget
    final contributingTxns = _filterContributingTransactions(budget, transactions, calculator);

    // Find largest expense and most frequent merchant
    final largestExpense = contributingTxns.isNotEmpty
        ? contributingTxns.reduce((a, b) => a.amount > b.amount ? a : b)
        : null;
    final merchantGroups = <String, int>{};
    for (final t in contributingTxns) {
      if (t.merchantName != null) {
        merchantGroups[t.merchantName!] = (merchantGroups[t.merchantName!] ?? 0) + 1;
      }
    }
    final mostFrequentMerchant = merchantGroups.entries.isEmpty
        ? null
        : merchantGroups.entries.reduce((a, b) => a.value > b.value ? a : b);

    final categories = ref.watch(categoriesProvider).valueOr([]);
    final categoryMap = {for (final c in categories) c.id: c};

    return Scaffold(
      appBar: AppBar(
        title: Text(budget.name),
        actions: [
          PopupMenuButton<BudgetAction>(
            onSelected: (action) => _handleAction(context, ref, action, budget),
            itemBuilder: (context) => [
              if (!budget.isPaused)
                const PopupMenuItem(value: BudgetAction.pause, child: Text('Pause')),
              if (budget.isPaused)
                const PopupMenuItem(value: BudgetAction.resume, child: Text('Resume')),
              const PopupMenuItem(value: BudgetAction.edit, child: Text('Edit')),
              const PopupMenuItem(value: BudgetAction.duplicate, child: Text('Duplicate')),
              const PopupMenuItem(value: BudgetAction.delete, child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircularBudgetIndicator(budget: budget, size: 80),
                const SizedBox(width: AppSizes.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BudgetStatusChip(budget: budget),
                      const SizedBox(height: AppSizes.spacing8),
                      Text(
                        '${CurrencyFormatter.format(budget.spentAmount)} of ${CurrencyFormatter.format(budget.amount)}',
                        style: AppTextStyles.bodyLarge(context, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${daysElapsed} of $totalDays days elapsed',
                        style: AppTextStyles.bodySmall(context, color: AppColors.onSurfaceMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.spacing16),
            BudgetProgressBar(budget: budget, height: 16),
            const SizedBox(height: AppSizes.spacing24),
            // Stats cards
            Row(
              children: [
                Expanded(child: _statCard(context, 'Daily Avg', CurrencyFormatter.format(dailyAvg))),
                const SizedBox(width: AppSizes.spacing8),
                Expanded(child: _statCard(context, 'Weekly Avg', CurrencyFormatter.format(weeklyAvg))),
                const SizedBox(width: AppSizes.spacing8),
                Expanded(child: _statCard(context, 'Forecast', CurrencyFormatter.format(forecast))),
              ],
            ),
            const SizedBox(height: AppSizes.spacing16),
            BudgetForecastCard(budget: budget),
            const SizedBox(height: AppSizes.spacing24),
            // Insights
            Text('Insights', style: AppTextStyles.titleMedium(context)),
            const SizedBox(height: AppSizes.spacing12),
            ..._generateInsights(context, budget, calculator, contributingTxns, categories),
            const SizedBox(height: AppSizes.spacing24),
            // Category breakdown
            if (budget.budgetType == BudgetType.custom || budget.budgetType == BudgetType.category)
              _categoryBreakdown(context, budget, contributingTxns, categoryMap),
            const SizedBox(height: AppSizes.spacing24),
            // Largest expense
            if (largestExpense != null) ...[
              Text('Largest Expense', style: AppTextStyles.titleMedium(context)),
              const SizedBox(height: AppSizes.spacing8),
              _expenseTile(context, largestExpense, categoryMap[largestExpense.categoryId]),
              const SizedBox(height: AppSizes.spacing24),
            ],
            // Most frequent merchant
            if (mostFrequentMerchant != null) ...[
              BudgetInsightCard(
                icon: Icons.store,
                title: 'Most Frequent',
                subtitle: '${mostFrequentMerchant.key} · ${mostFrequentMerchant.value} transactions',
                color: AppColors.blue,
              ),
              const SizedBox(height: AppSizes.spacing24),
            ],
            // Transactions
            Text('Transactions (${contributingTxns.length})', style: AppTextStyles.titleMedium(context)),
            const SizedBox(height: AppSizes.spacing8),
            if (contributingTxns.isEmpty)
              const EmptyState(message: 'No transactions yet for this budget')
            else
              ...contributingTxns.take(20).map((txn) => Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.spacing8),
                child: TransactionListTile(
                  transaction: txn,
                  category: categoryMap[txn.categoryId] ?? Category(
                    id: 'unknown',
                    name: 'Unknown',
                    icon: 'receipt_long',
                    type: txn.type,
                  ),
                  onTap: () => context.push(RouteNames.transactionDetail(txn.id)),
                ),
              )),
          ],
        ),
      ),
    );
  }

  Widget _statCard(BuildContext context, String label, String value) {
    return AppCard(
      padding: const EdgeInsets.all(AppSizes.spacing12),
      child: Column(
        children: [
          Text(value, style: AppTextStyles.titleSmall(context, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.labelSmall(context, color: AppColors.onSurfaceMuted)),
        ],
      ),
    );
  }

  Widget _expenseTile(BuildContext context, Transaction txn, Category? category) {
    return InkWell(
      onTap: () => context.push(RouteNames.transactionDetail(txn.id)),
      child: AppCard(
        padding: const EdgeInsets.all(AppSizes.spacing12),
        child: Row(
          children: [
            if (category != null)
              CircleAvatar(
                backgroundColor: _parseColor(category.colorHex).withValues(alpha: 0.15),
                child: Icon(_iconData(category.icon), size: 20, color: _parseColor(category.colorHex)),
              ),
            const SizedBox(width: AppSizes.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(txn.merchantName ?? category?.name ?? 'Unknown', style: AppTextStyles.bodyMedium(context)),
                  Text('${txn.transactionDate.day}/${txn.transactionDate.month}/${txn.transactionDate.year}',
                      style: AppTextStyles.bodySmall(context, color: AppColors.onSurfaceMuted)),
                ],
              ),
            ),
            Text(
              CurrencyFormatter.format(txn.amount),
              style: AppTextStyles.bodyMedium(context, color: AppColors.expense, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryBreakdown(BuildContext context, Budget budget, List<Transaction> txns, Map<String, Category> categoryMap) {
    final perCategory = <String, int>{};
    for (final t in txns) {
      final catId = t.categoryId ?? 'uncategorized';
      perCategory[catId] = (perCategory[catId] ?? 0) + t.amount;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category Breakdown', style: AppTextStyles.titleMedium(context)),
        const SizedBox(height: AppSizes.spacing8),
        ...perCategory.entries.map((e) {
          final cat = categoryMap[e.key];
          final percentage = budget.amount > 0 ? (e.value / budget.amount * 100).round() : 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spacing8),
            child: Row(
              children: [
                Expanded(
                  child: Text(cat?.name ?? e.key, style: AppTextStyles.bodyMedium(context)),
                ),
                Text('${CurrencyFormatter.format(e.value)} ($percentage%)',
                    style: AppTextStyles.bodySmall(context, color: AppColors.onSurfaceMuted)),
              ],
            ),
          );
        }),
      ],
    );
  }

  List<BudgetInsightCard> _generateInsights(BuildContext context, Budget budget, BudgetCalculator calculator, List<Transaction> txns, List<Category> categories) {
    final insights = <BudgetInsightCard>[];
    if (txns.isEmpty) return insights;

    // Most expensive day of week
    final dayTotals = <int, int>{};
    for (final t in txns) {
      final day = t.transactionDate.weekday;
      dayTotals[day] = (dayTotals[day] ?? 0) + t.amount;
    }
    if (dayTotals.isNotEmpty) {
      final mostExpensiveDay = dayTotals.entries.reduce((a, b) => a.value > b.value ? a : b);
      final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      insights.add(BudgetInsightCard(
        icon: Icons.calendar_view_week,
        title: 'Most Expensive Day',
        subtitle: '${dayNames[mostExpensiveDay.key - 1]} · ${CurrencyFormatter.format(mostExpensiveDay.value)}',
        color: AppColors.orange,
      ));
    }

    // Daily average
    final daysElapsed = calculator.computeDaysElapsed(budget);
    if (daysElapsed > 0) {
      insights.add(BudgetInsightCard(
        icon: Icons.trending_up,
        title: 'Average Daily Spending',
        subtitle: CurrencyFormatter.format(calculator.computeDailyAverage(budget)),
        color: AppColors.blue,
      ));
    }

    return insights;
  }

  List<Transaction> _filterContributingTransactions(Budget budget, List<Transaction> allTxns, BudgetCalculator calculator) {
    final range = calculator.getPeriodRange(budget);
    return allTxns.where((t) {
      if (t.isDeleted) return false;
      if (t.type == TransactionType.income) return false;
      if (t.transactionDate.isBefore(range.start)) return false;
      if (budget.endDate != null && t.transactionDate.isAfter(budget.endDate!)) return false;
      if (budget.endDate == null && t.transactionDate.isAfter(range.end)) return false;
      switch (budget.budgetType) {
        case BudgetType.overall:
          return true;
        case BudgetType.category:
          return budget.categoryIds.isNotEmpty && t.categoryId == budget.categoryIds.first;
        case BudgetType.custom:
          return t.categoryId != null && budget.categoryIds.contains(t.categoryId);
      }
    }).toList()
      ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
  }

  void _handleAction(BuildContext context, WidgetRef ref, BudgetAction action, Budget budget) {
    switch (action) {
      case BudgetAction.edit:
        context.push(RouteNames.budgetsEdit(budget.id));
      case BudgetAction.delete:
        _confirmDelete(context, ref, budget.id);
      case BudgetAction.pause:
        ref.read(budgetDetailActionProvider.notifier).togglePause(budget.id, true);
      case BudgetAction.resume:
        ref.read(budgetDetailActionProvider.notifier).togglePause(budget.id, false);
      case BudgetAction.duplicate:
        ref.read(budgetDetailActionProvider.notifier).duplicate(budget, context);
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String budgetId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Budget'),
        content: const Text('Are you sure? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(budgetDetailActionProvider.notifier).delete(budgetId);
              context.pop();
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String? hex) {
    if (hex == null) return AppColors.primary;
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  IconData _iconData(String iconName) {
    switch (iconName) {
      case 'local_gas_station': return Icons.local_gas_station;
      case 'restaurant': return Icons.restaurant;
      case 'directions_car': return Icons.directions_car;
      case 'home': return Icons.home;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'flight': return Icons.flight;
      case 'medical_services': return Icons.medical_services;
      case 'school': return Icons.school;
      case 'work': return Icons.work;
      case 'sports_esports': return Icons.sports_esports;
      case 'subscriptions': return Icons.subscriptions;
      default: return Icons.account_balance_wallet;
    }
  }
}
```

- [ ] **Step 2: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/presentation/screens/budget_detail_screen.dart
git commit -m "feat: add budget detail screen"
```

---

### Task 12: Route Integration

**Files:**
- Modify: `lib/core/router/route_names.dart`
- Modify: `lib/core/router/app_router.dart`

- [ ] **Step 1: Add budget routes to RouteNames**

Add to `lib/core/router/route_names.dart`:

```dart
static const String budgets = '/budgets';
static const String budgetsNew = '/budgets/new';
static String budgetDetail(String id) => '/budgets/$id';
static String budgetsEdit(String id) => '/budgets/edit/$id';
```

- [ ] **Step 2: Add budget routes to AppRouter**

Add import at top:
```dart
import '../../features/budgets/presentation/screens/budget_list_screen.dart';
import '../../features/budgets/presentation/screens/create_budget_screen.dart';
import '../../features/budgets/presentation/screens/budget_detail_screen.dart';
```

Add `BudgetListScreen` as 4th ShellRoute tab (in the `ShellRoute` children list):

```dart
GoRoute(
  path: RouteNames.budgets,
  pageBuilder: (context, state) => _buildPage(
    child: const BudgetListScreen(),
    state: state,
  ),
),
```

Add full-screen routes outside the ShellRoute:

```dart
GoRoute(
  path: RouteNames.budgetsNew,
  pageBuilder: (context, state) => _buildPage(
    child: const CreateBudgetScreen(),
    state: state,
  ),
),
GoRoute(
  path: '/budgets/:id',
  pageBuilder: (context, state) => _buildPage(
    child: BudgetDetailScreen(budgetId: state.pathParameters['id']!),
    state: state,
  ),
),
GoRoute(
  path: '/budgets/edit/:id',
  pageBuilder: (context, state) => _buildPage(
    child: CreateBudgetScreen(editBudgetId: state.pathParameters['id']!),
    state: state,
  ),
),
```

Update ShellRoute bottom navigation to add 4th tab:

```dart
BottomNavigationBarItem(
  icon: const Icon(Icons.account_balance_wallet_outlined),
  activeIcon: const Icon(Icons.account_balance_wallet),
  label: 'Budgets',
),
```

Update the shell's `_selectedIndex` logic to handle `/budgets` path.

- [ ] **Step 3: Commit**

```bash
cd A:\PocketPlus
git add lib/core/router/
git commit -m "feat: add budget routes and 4th nav tab"
```

---

### Task 13: Dashboard Integration

**Files:**
- Modify: `lib/features/home/presentation/home_screen.dart`
- Modify: `lib/features/home/presentation/home_providers.dart`

- [ ] **Step 1: Add budget overview provider to home_providers.dart**

```dart
final budgetOverviewProvider = Provider.autoDispose<({List<Budget> topBudgets, int totalRemaining, bool hasBudgets})>((ref) {
  final budgets = ref.watch(topBudgetsProvider);
  final totalRemaining = budgets.fold(0, (sum, b) => sum + b.remainingAmount);
  return (topBudgets: budgets, totalRemaining: totalRemaining, hasBudgets: budgets.isNotEmpty);
});
```

- [ ] **Step 2: Add budget overview section to home screen**

Insert after the dashboard content in `home_screen.dart`:

```dart
// Budget Overview Section
final budgetOverview = ref.watch(budgetOverviewProvider);
if (budgetOverview.hasBudgets) {
  Padding(
    padding: const EdgeInsets.all(AppSizes.spacing16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Budget Overview', style: AppTextStyles.titleMedium(context)),
            TextButton(
              onPressed: () => context.go(RouteNames.budgets),
              child: const Text('See All'),
            ),
          ],
        ),
        ...budgetOverview.topBudgets.map((budget) => BudgetCard(budget: budget)),
      ],
    ),
  );
} else {
  // Empty state with CTA
  Padding(
    padding: const EdgeInsets.all(AppSizes.spacing16),
    child: AppCard(
      onTap: () => context.push(RouteNames.budgetsNew),
      child: Row(
        children: [
          CircularBudgetIndicator(budget: null), // only icon
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create Your First Budget', style: AppTextStyles.titleSmall(context)),
                Text('Track spending and save more', style: AppTextStyles.bodySmall(context, color: AppColors.onSurfaceMuted)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.onSurfaceMuted),
        ],
      ),
    ),
  );
}
```

- [ ] **Step 3: Commit**

```bash
cd A:\PocketPlus
git add lib/features/home/
git commit -m "feat: integrate budget overview into home dashboard"
```

---

### Task 14: Analytics Integration

**Files:**
- Modify: `lib/features/analytics/presentation/analytics_screen.dart`

- [ ] **Step 1: Add budget overlay to analytics chart**

Import budget providers:
```dart
import '../../budgets/presentation/providers/budget_providers.dart';
```

Add a budget line overlay toggle in `analytics_screen.dart`:

1. Add a boolean state variable `_showBudgetOverlay = false`
2. Add a toggle button in the header (next to existing controls):
```dart
IconButton(
  icon: Icon(_showBudgetOverlay ? Icons.trending_up : Icons.trending_up_outlined),
  onPressed: () => setState(() => _showBudgetOverlay = !_showBudgetOverlay),
  tooltip: 'Toggle budget overlay',
)
```
3. Before the chart `LineChartData` is built, read budgets:
```dart
final activeBudgets = ref.watch(activeBudgetsProvider);
final calculator = BudgetCalculator();
final monthlyBudgets = activeBudgets.where((b) => b.period == BudgetPeriod.monthly).toList();
```
4. Add a dashed `LineChartBarData` for each budget (only when `_showBudgetOverlay` is true):
```dart
if (_showBudgetOverlay) ...[
  ...monthlyBudgets.map((budget) => LineChartBarData(
    spots: [
      FlSpot(0, budget.amount.toDouble()),
      FlSpot(11, budget.amount.toDouble()),
    ],
    isCurved: false,
    color: _parseColor(budget.colorHex).withValues(alpha: 0.5),
    barWidth: 1.5,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    dashArray: [6, 4],
  )),
]
```
5. Add a legend showing which budgets are overlaid:
```dart
if (_showBudgetOverlay && monthlyBudgets.isNotEmpty) {
  Wrap(
    spacing: 8,
    children: monthlyBudgets.map((b) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(
          color: _parseColor(b.colorHex), shape: BoxShape.circle,
        )),
        const SizedBox(width: 4),
        Text(b.name, style: AppTextStyles.labelSmall(context)),
      ],
    )).toList(),
  ),
}
```

- [ ] **Step 2: Commit**

```bash
cd A:\PocketPlus
git add lib/features/analytics/
git commit -m "feat: add budget overlay to analytics charts"
```

---

### Task 15: Reports Integration

**Files:**
- Modify: `lib/features/reports/presentation/reports_screen.dart`
- Modify: `lib/features/reports/reports_providers.dart`

- [ ] **Step 1: Add budget columns to reports**

Add a budget overview card at the top of the reports screen:

```dart
final budgets = ref.watch(activeBudgetsProvider);
final calculator = BudgetCalculator();

if (budgets.isNotEmpty) {
  Padding(
    padding: const EdgeInsets.all(AppSizes.spacing16),
    child: AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Budget Overview', style: AppTextStyles.titleMedium(context)),
          const SizedBox(height: AppSizes.spacing12),
          ...budgets.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.spacing8),
            child: Row(
              children: [
                Icon(Icons.circle, size: 12, color: _parseColor(b.colorHex)),
                const SizedBox(width: 8),
                Expanded(child: Text(b.name, style: AppTextStyles.bodyMedium(context))),
                Text(
                  '${CurrencyFormatter.format(b.spentAmount)} / ${CurrencyFormatter.format(b.amount)}',
                  style: AppTextStyles.bodySmall(context),
                ),
              ],
            ),
          )),
        ],
      ),
    ),
  );
}
```

- [ ] **Step 2: Commit**

```bash
cd A:\PocketPlus
git add lib/features/reports/
git commit -m "feat: integrate budget data into reports"
```

---

### Task 16: Notifications

**Files:**
- Create: `lib/features/budgets/presentation/services/budget_notification_service.dart`

- [ ] **Step 1: Create budget notification service**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/notifications/local_notification_service.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/budget_calculator.dart';
import '../../domain/entities/budget.dart';
import '../providers/budget_providers.dart';

class BudgetNotificationService {
  final Set<String> _thresholdNotified = {};
  final Set<String> _exceededNotified = {};

  void checkAndNotify({
    required List<Budget> budgets,
  }) {
    final calculator = BudgetCalculator();

    for (final budget in budgets) {
      if (!budget.notificationsEnabled || budget.isPaused || budget.amount <= 0) continue;

      final percentage = calculator.computePercentage(budget);
      final status = calculator.computeStatus(budget);

      // Threshold notification (e.g., 80%)
      if (percentage >= budget.alertThreshold && !_thresholdNotified.contains(budget.id)) {
        _thresholdNotified.add(budget.id);
        LocalNotificationService.show(
          'Budget Alert',
          'You\'ve used $percentage% of your ${budget.name} budget.',
          'budget_${budget.id}',
        );
      }

      // Exceeded notification
      if (status == BudgetStatus.exceeded && !_exceededNotified.contains(budget.id)) {
        _exceededNotified.add(budget.id);
        final exceededAmount = budget.spentAmount - budget.amount;
        LocalNotificationService.show(
          'Budget Exceeded',
          'You\'ve exceeded your ${budget.name} budget by ${CurrencyFormatter.format(exceededAmount)}.',
          'budget_${budget.id}',
        );
      }

      // Reset notifications if budget changes (spentAmount decreased or budget recreated)
      if (_thresholdNotified.contains(budget.id) && percentage < budget.alertThreshold) {
        _thresholdNotified.remove(budget.id);
      }
      if (_exceededNotified.contains(budget.id) && status != BudgetStatus.exceeded) {
        _exceededNotified.remove(budget.id);
      }
    }
  }

  void reset() {
    _thresholdNotified.clear();
    _exceededNotified.clear();
  }
}

final budgetNotificationServiceProvider = Provider<BudgetNotificationService>((ref) {
  return BudgetNotificationService();
});
```

- [ ] **Step 2: Wire notification listener in budget_providers.dart**

Add a `ref.listen` inside the `calculatedBudgetsProvider` to trigger notifications whenever budgets are recalculated:

```dart
// Inside calculatedBudgetsProvider, before returning:
ref.listenSelf((previous, next) {
  ref.read(budgetNotificationServiceProvider).checkAndNotify(budgets: next);
});
```

- [ ] **Step 3: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/presentation/services/
git commit -m "feat: add budget notification service"
```

---

### Task 17: Budget Insights Engine

**Files:**
- Create: `lib/features/budgets/domain/budget_insights_engine.dart`

- [ ] **Step 1: Create insights engine**

```dart
import 'package:flutter/material.dart';

import '../../../../core/utils/currency_formatter.dart';
import '../../../transactions/domain/entities/transaction.dart';
import '../../../shared/models/transaction_type.dart';
import 'entities/budget.dart';

class BudgetInsight {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? color;

  const BudgetInsight({required this.title, required this.subtitle, required this.icon, this.color});
}

class BudgetInsightsEngine {
  List<BudgetInsight> generate({
    required Budget budget,
    required List<Transaction> transactions,
    required List<Transaction> previousPeriodTransactions,
  }) {
    final insights = <BudgetInsight>[];
    if (transactions.isEmpty) return insights;

    // Compare with previous period
    final currentTotal = transactions.fold(0, (sum, t) => sum + t.amount);
    final previousTotal = previousPeriodTransactions.fold(0, (sum, t) => sum + t.amount);

    if (previousTotal > 0) {
      final change = ((currentTotal - previousTotal) / previousTotal * 100).round();
      if (change > 0) {
        insights.add(BudgetInsight(
          title: 'Spending increased $change%',
          subtitle: 'Compared to last ${budget.period.name}',
          icon: Icons.trending_up,
          color: Colors.red,
        ));
      } else if (change < 0) {
        insights.add(BudgetInsight(
          title: 'Spending decreased ${change.abs()}%',
          subtitle: 'Compared to last ${budget.period.name}',
          icon: Icons.trending_down,
          color: Colors.green,
        ));
      }
    }

    // Most expensive day
    final dayTotals = <int, int>{};
    for (final t in transactions) {
      dayTotals[t.transactionDate.weekday] = (dayTotals[t.transactionDate.weekday] ?? 0) + t.amount;
    }
    if (dayTotals.isNotEmpty) {
      final maxDay = dayTotals.entries.reduce((a, b) => a.value > b.value ? a : b);
      const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      insights.add(BudgetInsight(
        title: 'Most expensive: ${dayNames[maxDay.key - 1]}',
        subtitle: '${CurrencyFormatter.format(maxDay.value)} spent on this day',
        icon: Icons.calendar_view_week,
        color: Colors.orange,
      ));
    }

    // Highest single expense
    if (transactions.isNotEmpty) {
      final maxTxn = transactions.reduce((a, b) => a.amount > b.amount ? a : b);
      insights.add(BudgetInsight(
        title: 'Highest expense: ${maxTxn.merchantName ?? "Unknown"}',
        subtitle: CurrencyFormatter.format(maxTxn.amount),
        icon: Icons.arrow_upward,
        color: Colors.red,
      ));
    }

    return insights;
  }
}
```

- [ ] **Step 2: Commit**

```bash
cd A:\PocketPlus
git add lib/features/budgets/domain/budget_insights_engine.dart
git commit -m "feat: add budget insights engine"
```

---

### Task 18: Run flutter analyze and fix issues

- [ ] **Step 1: Run flutter analyze**

```bash
cd A:\PocketPlus
flutter analyze
```

- [ ] **Step 2: Fix all errors and warnings**

Address any type errors, unused imports, missing parameters, etc.

- [ ] **Step 3: Run flutter test**

```bash
cd A:\PocketPlus
flutter test
```

- [ ] **Step 4: Commit final fixes**

```bash
cd A:\PocketPlus
git add -A
git commit -m "fix: address analyze and test issues"
```

---

## Execution Order

| Task | Dependencies | Est. Files |
|------|-------------|------------|
| 1. Budget Entity + Enums | None | 4 |
| 2. Budget Repository Interface | Task 1 | 2 |
| 3. Budget Calculator | Task 1 | 2 |
| 4. Budget Data Source | Task 1 | 1 |
| 5. Budget Repository Impl | Tasks 2, 4 | 1 |
| 6. Budget Providers | Tasks 3, 5 | 3 |
| 7. Reusable Widgets | Task 1 | 11 |
| 8. Budget ViewModel | Tasks 5, 6 | 2 |
| 9. Create Budget Screen | Tasks 7, 8 | 1 |
| 10. Budget List Screen | Tasks 7, 8 | 1 |
| 11. Budget Detail Screen | Tasks 7, 8 | 1 |
| 12. Route Integration | Tasks 9, 10, 11 | 2 |
| 13. Dashboard Integration | Tasks 6, 7 | 2 |
| 14. Analytics Integration | Tasks 6, 7 | 1 |
| 15. Reports Integration | Tasks 6, 7 | 2 |
| 16. Notifications | Tasks 1, 6 | 1 |
| 17. Insights Engine | Task 1 | 1 |
| 18. Analyze + Fix | All | - |
