# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Run the app (Android device/emulator required)
flutter run

# Lint — must be zero errors before any commit
flutter analyze

# Format
dart format .

# Run all tests
flutter test

# Run a single test file
flutter test test/core/utils/currency_formatter_test.dart

# Build release APK (single environment, no flavors)
flutter build apk --release \
  --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY

# Code generation (freezed entities, riverpod providers) — run after editing annotated files
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation during development
dart run build_runner watch --delete-conflicting-outputs

# Firebase Firestore security rules tests
cd firebase && npm run test:emulator
```

## Architecture

PocketPlus is a **Phase 1 Firebase-native Flutter app** for small Indian business bookkeeping. Phase 2 (future) migrates to Django + PostgreSQL; the repository pattern is designed to make this swap isolated to the data layer only.

### Feature-first Clean Architecture

```
lib/
├── main.dart                    # ProviderScope root
├── core/                        # Shared infrastructure — no feature logic
│   ├── bootstrap/               # Firebase init (call FirebaseBootstrap.initialize() before runApp)
│   ├── constants/               # AppColors, AppTextStyles, AppStrings, AppSizes
│   ├── errors/                  # Failure subclasses: NetworkFailure, AuthFailure, etc.
│   ├── network/                 # ConnectivityChecker
│   ├── router/                  # GoRouter config + route guards
│   └── utils/                   # CurrencyFormatter, DateFormatter, Logger
├── shared/
│   ├── models/                  # Cross-feature enums: TransactionType, PlanType, SyncStatus
│   ├── providers/               # authProvider, userProvider, profileProvider
│   └── widgets/                 # AppButton, AppCard, AppTextField, EmptyState, MinTouchTarget
└── features/{feature}/
    ├── data/                    # DataSource impl + RepositoryImpl
    ├── domain/                  # Repository interface + entities (freezed)
    └── presentation/            # Screen + ViewModel (Riverpod Notifier)
```

**Cross-feature rule**: Features must never import from each other. All cross-cutting concerns go through `core/` or `shared/`.

### Current Implementation Status

Only `auth` is fully implemented. All other feature directories (`dashboard`, `transactions`, `sms_capture`, `analytics`, `reports`, `ca_connect`, `khata`, `invoices`, `ml_insights`, `settings`, `feedback`, `onboarding`) contain only `.gitkeep` placeholders. The router uses `_PlaceholderScreen` for 15 of 18 routes. `FirebaseBootstrap.initialize()` is implemented but not yet called in `main.dart`.

## Non-Negotiable Engineering Rules

### Money — always paise (int)
```dart
// CORRECT
final int amount = 85000; // ₹850.00
CurrencyFormatter.format(amount);  // '₹850.00'

// WRONG — never use double for money
final double amount = 850.0; // ❌
```

### Error handling — Either pattern
Repositories always return `Either<Failure, T>` from `dartz`. Never throw across layer boundaries. ViewModels call `result.fold(onFailure, onSuccess)`.

### State management — Riverpod Notifier (v3.x)
Use `Notifier` / `AsyncNotifier` with `NotifierProvider`. Never use `StateNotifier`, `Provider` package, `Bloc`, or `setState` for shared state.

### Navigation — GoRouter only
```dart
context.go(RouteNames.home);      // CORRECT
Navigator.push(context, ...);     // ❌ WRONG
```

### Widgets — ConsumerWidget
Use `ConsumerWidget` (read-only) or `ConsumerStatefulWidget` (local state needed) for any widget that reads providers. Never use a raw `StatefulWidget` to access providers.

### Firestore queries — always scope by userId + profileId
```dart
_firestore.collection('transactions')
  .where('userId', isEqualTo: userId)
  .where('profileId', isEqualTo: profileId)
  .where('deletedAt', isNull: true); // never show soft-deleted
```

### Soft deletes — never hard delete financial data
Set `deletedAt = now()` and `isDeleted = true`. Transaction records retained 7 years (GST compliance). Audit logs are never deleted at all.

### SMS — raw text never persisted
Only store `smsHash = SHA256(rawSmsText)`. The raw SMS is processed in Dart on-device and discarded. Never transmit raw SMS to any server.

### Firestore offline persistence
Enabled at startup via `FirebaseBootstrap`. Never show "No internet" errors for Firestore reads — serve from local cache. Writes are queued locally and sync automatically.

## Naming Conventions

| Type | Pattern | Example |
|---|---|---|
| Screen | `{Feature}Screen` | `AddTransactionScreen` |
| ViewModel | `{Feature}ViewModel` | `AuthViewModel` |
| Repository interface | `{Name}Repository` | `TransactionRepository` |
| Repository impl | `{Name}RepositoryImpl` | `TransactionRepositoryImpl` |
| Data source interface | `{Name}DataSource` | `AuthDataSource` |
| Firebase data source | `Firebase{Name}DataSource` | `FirebaseAuthDataSource` |
| Provider | `{featureName}Provider` | `transactionRepositoryProvider` |
| Dart files | `snake_case` | `transaction_repository_impl.dart` |
| Firestore fields | `camelCase` | `transactionDate`, `merchantName` |
| Enum values | `SCREAMING_SNAKE` | `TransactionType.INCOME` |

## Key Data Flows

**SMS Auto-Capture**: Android BroadcastReceiver → `BankPatternMatcher` (checks sender) → `SmsParser` (regex extracts amount/type/merchant) → SHA256 dedup check against `sms_dedup_log` → `ProfileRouter` (routes to correct profile by bankAccountLast4) → Gemini categorisation → system notification → `CaptureConfirmationScreen` → `TransactionRepository` (Firestore batch write).

**Invoice → Transaction (atomic)**: Firestore batch write: update `invoices/{id}` to `PAID` + create new `transactions/{newId}` with `source: INVOICE`. If the batch fails, nothing is written. Never split this into two separate writes.

**PDF Export gate**: FREE users must watch a full AdMob rewarded video. BASIC users get 5 free exports/month then same gate. PRO exports unconditionally. If the ad fails to load within 5 seconds, export anyway and log `rewarded_ad_failed`.

## Critical Business Logic

- **Gemini confidence threshold**: If `geminiConfidence < 0.60`, never auto-confirm the category — always ask the user.
- **CA access**: CAs are strictly read-only, enforced at the Firestore security rules level, not just the UI.
- **Profile isolation**: Every Firestore query must include `profileId`. Queries missing `profileId` are a security bug.
- **Invoice number generation**: Always server-generated atomically (Firestore counter transaction). The client never generates invoice numbers.
- **OTP rate limit**: 3 OTPs per phone per 10 minutes.
- **Biometric lock**: Triggers after 5 minutes background. Cannot be disabled without PIN.

## Environments

Single environment: **one Firebase project, one application (`in.pocketplus.app`), no Flutter flavors.** The Firebase project is selected solely by the checked-in `lib/firebase_options.dart` and `android/app/google-services.json` (regenerate both with `flutterfire configure` when changing projects). The only build-time secret is `GEMINI_API_KEY` via `--dart-define`. AdMob IDs live in `AndroidManifest.xml`; use `kDebugMode` for any test-vs-production switching. Local Firestore tests use the emulator (project `demo-pocketplus`).

## Testing Requirements

- `flutter analyze` must return zero errors before any commit.
- `flutter test` must pass 100% before merge.
- SMS parser requires 100+ test cases covering all bank patterns and edge cases.
- Financial calculations (net profit, invoice totals, khata balance) require 100% unit test coverage.
- Firestore integration tests must use Firebase Local Emulator Suite — never production Firebase.
