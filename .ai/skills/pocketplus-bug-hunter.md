# Skill: PocketPlus Bug Hunter

## File Name
`.ai/skills/pocketplus-bug-hunter.md`

## Purpose
Diagnoses and fixes bugs in PocketPlus. Specialises in the most common PocketPlus failure modes: Riverpod state bugs, Firestore sync issues, GoRouter navigation errors, money calculation errors, and SMS parser failures.

## When To Use
- When `flutter analyze` reports errors
- When a screen shows wrong data
- When Firestore writes fail silently
- When navigation breaks
- When a transaction amount is wrong

## Inputs
- Error message or stack trace
- Affected file(s)
- Steps to reproduce

## Outputs
- Root cause analysis
- Fixed code
- Regression test to prevent recurrence

## Dependencies
- `pocketplus-flutter-conventions.md`

## Rules
1. Never fix a symptom — find the root cause
2. After every fix, run `flutter analyze` to confirm zero errors
3. Add a test case that would catch this bug in future
4. If bug involves money amounts — verify paise/rupee conversion
5. If bug involves Firestore — check if security rules are the cause first
6. If bug involves navigation — check GoRouter state and redirect logic
7. If bug is a data loss risk — treat as P0, fix immediately

### Common PocketPlus Bug Patterns

#### Bug: Amount shows wrong value
```
Root cause: Mixing paise (int) and rupees (double) somewhere
Diagnostic: Search for 'double' near amount fields
Fix: amount / 100 for display, amount * 100 for storage
Check: CurrencyFormatter.format(paise) — never format raw double
```

#### Bug: Riverpod provider not updating UI
```
Root cause: Using ref.read() instead of ref.watch() in build()
Diagnostic: Check if provider access is inside build() or in a callback
Fix: ref.watch() in build() for reactive, ref.read() in callbacks only
```

#### Bug: GoRouter navigation not working
```
Root cause: Using Navigator.push instead of context.go/context.push
Diagnostic: Search for Navigator.push in codebase
Fix: Replace with context.go() for replace, context.push() for stack
```

#### Bug: Firestore writes fail silently
```
Root cause: Either<Failure,T> result not being checked
Diagnostic: Look for .fold() missing or result discarded
Fix: Always fold() or use getOrElse()
Common: result.fold((failure) => showError, (data) => useData)
```

#### Bug: Duplicate SMS transactions
```
Root cause: Dedup check not running or sms_dedup_log write failed
Diagnostic: Check sms_dedup_log collection in Firestore emulator
Fix: Verify SHA256 hash computed before showing notification
```

#### Bug: Screen shows stale data after update
```
Root cause: Provider not invalidated after mutation
Fix: ref.invalidate(transactionListProvider) after create/update/delete
```

#### Bug: App crashes on transaction amount display
```
Root cause: Passing null to CurrencyFormatter or dividing by zero
Fix: Add null check, default to 0 paise if null
```

#### Bug: OTP screen not navigating after success
```
Root cause: GoRouter redirect firing before auth state updates
Fix: Add small delay or listen to authStateChangesProvider stream
```

### Diagnostic Commands
```bash
# Check for analyze errors
flutter analyze

# Run all tests
flutter test

# Check specific file
flutter analyze lib/features/auth/presentation/login_screen.dart

# Run with verbose logging
flutter run --verbose
```

## Example Usage
```
[User]: The transaction amount shows ₹0.00 for all transactions
[Agent using this skill]:
Root cause analysis:
1. Check TransactionListTile — is it reading amount or amount/100?
2. Check TransactionRepository — is it storing paise correctly?
3. Check Firestore directly — what value is in the amount field?

Most likely: amount field stored as rupees (double) instead of paise (int)
Fix: In TransactionRepositoryImpl, ensure: 'amount': transaction.amount (already int paise)
In TransactionListTile, ensure: CurrencyFormatter.format(transaction.amount) not transaction.amount/100.0

Regression test: TransactionListTile should display '₹850.00' when amount=85000
```

## Recommended AI Models
- **Primary**: Claude Sonnet (best at debugging reasoning)
- **Secondary**: Gemini 2.5 Pro
- **For stack traces**: Any model — provide full stack trace for best results
