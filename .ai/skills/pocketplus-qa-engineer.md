# Skill: PocketPlus QA Engineer

## File Name
`.ai/skills/pocketplus-qa-engineer.md`

## Purpose
Writes and runs tests for PocketPlus following the testing strategy in Engineering Spec B-4. Ensures every feature has unit tests, widget tests, and integration tests before merge. Blocks any PR with < 90% coverage on critical components.

## When To Use
- After any feature is built
- Before any PR is merged
- When running `flutter test`
- When setting up Firebase emulator tests

## Inputs
- Feature code to test
- Engineering Spec B-4 (testing strategy)
- Acceptance criteria from ticket

## Outputs
- Unit tests (test/)
- Widget tests (test/)
- Integration test specs
- Coverage report analysis

## Dependencies
- `pocketplus-flutter-conventions.md`

## Rules

### Coverage Requirements (from Engineering Spec B4.2)
```
SMS Parser (SmsParser):        100% required
CurrencyFormatter:             100% required
Net profit calculation:        100% required
Transaction validation:        100% required
Invoice total calculation:     100% required
Khata balance calculation:     100% required
Recurring expense scheduler:   90%+ required
ML confidence threshold:       90%+ required
```

### Test File Structure
```
test/
  unit/
    core/
      utils/currency_formatter_test.dart
      utils/date_formatter_test.dart
    features/
      sms_capture/sms_parser_test.dart      # 100+ test cases
      transactions/transaction_validator_test.dart
  widget/
    shared/widgets/design_system_test.dart   # already exists
    features/auth/login_screen_test.dart
    features/auth/otp_screen_test.dart
  integration/
    auth_flow_test.dart
    ca_connect_flow_test.dart
```

### Unit Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/core/utils/currency_formatter.dart';

void main() {
  group('CurrencyFormatter', () {
    test('formats paise to rupees correctly', () {
      expect(CurrencyFormatter.format(85000), '₹850.00');
      expect(CurrencyFormatter.format(100), '₹1.00');
      expect(CurrencyFormatter.format(0), '₹0.00');
      expect(CurrencyFormatter.format(10000000), '₹1,00,000.00'); // Indian format
    });

    test('handles negative amounts for expenses', () {
      expect(CurrencyFormatter.formatSigned(-85000), '-₹850.00');
      expect(CurrencyFormatter.formatSigned(85000), '+₹850.00');
    });
  });
}
```

### Widget Test Template
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_plus/features/auth/presentation/login_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('Send OTP button disabled with empty phone', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: LoginScreen())),
      );
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull); // disabled
    });

    testWidgets('Send OTP button enabled with valid phone', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: LoginScreen())),
      );
      await tester.enterText(find.byType(TextField), '9876543210');
      await tester.pump();
      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.onPressed, isNotNull); // enabled
    });

    testWidgets('shows error for invalid phone format', (tester) async {
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp(home: LoginScreen())),
      );
      await tester.enterText(find.byType(TextField), '1234567890'); // starts with 1 — invalid
      await tester.pump();
      // Button should remain disabled — starts with 1, not 6-9
      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.onPressed, isNull);
    });
  });
}
```

### SMS Parser Test Matrix
Every bank, every edge case, every error case:
```dart
final testCases = [
  SmsTestCase(
    input: 'INR 850.00 debited from A/c XX1234 on 17-May',
    expected: ParsedSms(amount: 85000, type: TransactionType.EXPENSE, accountLast4: '1234'),
  ),
  SmsTestCase(
    input: 'OTP is 123456',
    expected: null, // not a bank SMS
  ),
  // ... 100+ cases
];
```

### Integration Test Checklist
```
[ ] Create user → create profile → add transaction → verify in Firestore emulator
[ ] CA invite flow: invite → accept → read transactions → revoke → verify blocked
[ ] Firestore security rules: CA cannot write, profile isolation enforced
[ ] Offline write → reconnect → verify sync
[ ] Recurring expense Cloud Function trigger
[ ] OTP rate limiting: 4th request in 10 min returns RATE_LIMITED
```

## Recommended AI Models
- **Primary**: Claude Sonnet (best test reasoning)
- **Secondary**: DeepSeek V3 (fast test generation)
- **For SMS test matrix**: Gemini 2.5 Flash (generate large test datasets quickly)
