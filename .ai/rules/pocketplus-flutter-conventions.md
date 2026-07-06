# Skill: PocketPlus Flutter Conventions

## File Name
`.ai/skills/pocketplus-flutter-conventions.md`

## Purpose
Enforces PocketPlus-specific Flutter coding conventions, naming patterns, widget rules, and Dart style. Every agent generating Flutter code for PocketPlus must load this skill first.

## When To Use
- Before writing ANY Flutter/Dart code for PocketPlus
- During code review
- When onboarding a new AI agent to the project

## Inputs
- Any Dart file to be created or reviewed

## Outputs
- Convention-compliant Dart code
- List of violations found (if reviewing)

## Dependencies
None — load this before all other skills.

## Rules

### Naming
- Screens: `{FeatureName}Screen` → `LoginScreen`, `AddTransactionScreen`
- ViewModels: `{FeatureName}ViewModel` → `AuthViewModel`
- Repositories: `{Name}Repository` (interface), `{Name}RepositoryImpl` (impl)
- Data sources: `{Name}DataSource` (interface), `Firebase{Name}DataSource` (impl)
- Providers: `{featureName}Provider` → `transactionRepositoryProvider`
- Entities: singular noun → `Transaction`, `Profile`, `Invoice`
- Enums: PascalCase type, SCREAMING_SNAKE values → `TransactionType.INCOME`

### Money
```dart
// CORRECT — always paise (int)
final int amountPaise = 85000; // = ₹850.00
final String display = CurrencyFormatter.format(amountPaise); // '₹850.00'

// WRONG — never double for money
final double amount = 850.0; // ❌ NEVER
```

### State Management
```dart
// CORRECT — Riverpod Notifier (v2.5+)
class TransactionViewModel extends Notifier<TransactionState> {
  @override
  TransactionState build() => const TransactionState();
}
final transactionViewModelProvider =
    NotifierProvider<TransactionViewModel, TransactionState>(TransactionViewModel.new);

// WRONG — old StateNotifier
class TransactionViewModel extends StateNotifier<TransactionState> { } // ❌
```

### Error Handling
```dart
// CORRECT — Either pattern
Future<Either<Failure, Transaction>> createTransaction(Transaction t) async {
  try {
    final doc = await _firestore.collection('transactions').add(t.toJson());
    return Right(t.copyWith(id: doc.id));
  } on FirebaseException catch (e) {
    return Left(ServerFailure(message: e.message ?? 'Failed'));
  }
}

// WRONG — throwing from repository
Future<Transaction> createTransaction(Transaction t) async {
  // throws exception to UI ❌
}
```

### Navigation
```dart
// CORRECT
context.go(RouteNames.home);
context.push(RouteNames.otp, extra: phone);
context.pop();

// WRONG
Navigator.push(context, MaterialPageRoute(...)); // ❌
Navigator.pushNamed(context, '/home'); // ❌
```

### Widget Patterns
```dart
// CORRECT — ConsumerWidget for read-only state
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);
  }
}

// CORRECT — ConsumerStatefulWidget when local state needed
class AddTransactionScreen extends ConsumerStatefulWidget { }

// WRONG — StatefulWidget with manual provider access
class HomeScreen extends StatefulWidget { } // ❌ (unless no providers needed)
```

### Firestore Paths
```dart
// CORRECT — always include userId for isolation
_firestore
  .collection('transactions')
  .where('userId', isEqualTo: userId)
  .where('profileId', isEqualTo: profileId) // always filter by profile too
  .where('deletedAt', isNull: true); // never show soft-deleted

// WRONG — missing profile isolation
_firestore.collection('transactions').where('userId', isEqualTo: userId); // ❌ missing profileId
```

### Imports Order
```dart
// 1. Dart SDK
import 'dart:async';
// 2. Flutter
import 'package:flutter/material.dart';
// 3. Pub packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 4. Internal — core
import '../../../core/constants/app_colors.dart';
// 5. Internal — shared
import '../../../shared/widgets/widgets.dart';
// 6. Internal — same feature
import 'auth_view_model.dart';
```

### AppColors Usage
```dart
AppColors.primary      // #0D631B — brand green, income
AppColors.error        // #B71C1C — expense, errors
AppColors.surface      // page background
AppColors.card         // card background
AppColors.onSurface    // primary text
AppColors.onSurfaceMuted // secondary text
AppColors.outline      // borders
```

### Touch Targets
All interactive elements must be minimum 48×48dp:
```dart
// Use MinTouchTarget wrapper from shared/widgets/ if needed
MinTouchTarget(child: IconButton(...))
```

## Recommended AI Models
- **All models** — this skill is a reference, not a generator
- Load alongside every code-generating skill
