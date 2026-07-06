# Skill: PocketPlus SMS Processing Specialist

## File Name
`.ai/skills/pocketplus-sms-specialist.md`

## Purpose
Expert in PocketPlus's SMS auto-capture pipeline. Handles SmsReceiver, BankPatternMatcher, SmsParser, deduplication, offline queuing, and profile routing. The SMS pipeline is the most critical feature in PocketPlus — bugs here lose users' financial data silently.

## When To Use
- When working on IGR-011 (SMS Listener) or any sms_capture/ feature
- When adding support for a new bank's SMS format
- When debugging missed or duplicate transactions
- When writing SMS parser test cases

## Inputs
- Bank SMS examples
- Engineering Spec section on SMS pipeline
- TAD section 2 (SMS data flow)

## Outputs
- Regex patterns for bank SMS parsing
- SmsParser test cases
- Deduplication logic
- Profile routing logic

## Dependencies
- `pocketplus-security-auditor.md` (SMS data must never be stored raw)
- `pocketplus-firebase-architect.md` (sms_dedup_log schema)

## Rules
1. Raw SMS text MUST NEVER be stored — compute SHA256(rawSmsText) and store only the hash
2. SMS parsing happens on-device — never send SMS content to any server
3. Deduplication check BEFORE showing notification to user
4. Profile routing uses bankAccountLast4 array on each profile
5. If confidence < 0.6 — do NOT pre-select any category (show all equally)
6. If confidence >= 0.6 — pre-select the ML-suggested category
7. Amount must be > 0 paise — reject zero amounts
8. Non-INR amounts must be flagged for review, not auto-logged
9. Word amounts (e.g. "five hundred rupees") not supported — log parse_failed
10. 100+ test cases required before shipping SMS parser

### Supported Bank Patterns (TAD A-2)
```dart
// HDFC Debit
RegExp(r'INR\s([\d,]+\.?\d*)\sdebited from A/c\s[Xx]+(\d{4})');
// HDFC Credit
RegExp(r'INR\s([\d,]+\.?\d*)\scredited to A/c\s[Xx]+(\d{4})');
// SBI with comma
RegExp(r'Your A/c debited by Rs\.([\d,]+\.?\d*)');
// ICICI
RegExp(r'ICICI Bank Acct\s[Xx]+(\d{4})\sdebited for Rs\s([\d,]+\.?\d*)');
// GPay / UPI
RegExp(r'You have successfully paid Rs\.\s?([\d,]+\.?\d*)\sto\s(.+)');
// Paytm
RegExp(r'Rs\.([\d,]+\.?\d*)\spaid to\s(.+)\svia Paytm');
```

### Amount Parsing (paise conversion)
```dart
int parseToPaise(String rawAmount) {
  // Remove commas: "1,500.00" → "1500.00"
  final cleaned = rawAmount.replaceAll(',', '');
  // Parse as double first, multiply by 100, round to int
  final rupees = double.parse(cleaned);
  return (rupees * 100).round();
}
```

### Deduplication Flow
```dart
// 1. Compute hash
final smsHash = sha256.convert(utf8.encode(rawSmsText)).toString();

// 2. Check Firestore (local cache first — works offline)
final existing = await _firestore
  .collection('sms_dedup_log')
  .where('userId', isEqualTo: userId)
  .where('smsHash', isEqualTo: smsHash)
  .limit(1)
  .get(GetOptions(source: Source.cache));

// 3. If exists → DUPLICATE_SKIPPED, show nothing
// 4. If not exists → continue to parse + show notification
```

### Required Test Cases (minimum subset)
```
HDFC debit basic: "INR 850.00 debited from A/c XX1234 on 17-May"
  → { amount: 85000, type: EXPENSE, accountLast4: '1234' }

HDFC credit: "INR 5000.00 credited to A/c XX1234 on 17-May"
  → { amount: 500000, type: INCOME }

SBI comma: "Your A/c debited by Rs.1,500.00"
  → { amount: 150000, type: EXPENSE }

Duplicate SMS: same hash as existing sms_dedup_log entry
  → DUPLICATE_SKIPPED

Zero amount: "INR 0.00 debited"
  → null (reject)

Non-bank SMS: "OTP is 123456 for login"
  → null (not a transaction)

Word amount: "Payment of five hundred rupees received"
  → null, log sms_parse_failed

Credit card bill: "HDFC Credit Card bill of Rs 15000 due"
  → null (bill reminder, not transaction)
```

## Example Usage
```
[User]: Add support for Axis Bank SMS format
[Agent using this skill]:
1. Get example Axis Bank SMS formats
2. Write regex pattern
3. Test against 5+ real examples
4. Add to BankPatternMatcher bank list
5. Add sender ID to known banks list (e.g. 'AXISBK', 'UTIBOP')
6. Write 10+ test cases
7. Confirm SHA256 dedup still works
8. Confirm raw SMS never stored — hash only
```

## Recommended AI Models
- **Primary**: Claude Sonnet (regex + logic)
- **Secondary**: Gemini 2.5 Flash (fast iteration on patterns)
- **For test generation**: DeepSeek V3 (good at generating test matrices)
