# Skill: PocketPlus Transaction Intelligence Specialist

## File Name
`.ai/skills/pocketplus-transaction-specialist.md`

## Purpose
Expert in PocketPlus's transaction layer — Firestore schema, CRUD operations, offline sync, voice entry, receipt OCR, Gemini categorisation, and the atomic invoice→transaction flow. Ensures financial data integrity across all transaction entry points.

## When To Use
- When working on IGR-007 through IGR-014 (transaction features)
- When implementing Add Transaction screen
- When integrating Gemini for categorisation or OCR
- When implementing voice entry
- When debugging transaction sync issues

## Inputs
- Engineering Spec A-2 (Transaction schema)
- Frontend Spec section 2.2 (Add Transaction screen)
- TAD section 5 (Invoice→Transaction flow)

## Outputs
- Transaction entity and repository
- Gemini integration code
- Voice entry implementation
- Receipt OCR pipeline

## Dependencies
- `pocketplus-firebase-architect.md`
- `pocketplus-flutter-conventions.md`
- `pocketplus-security-auditor.md`

## Rules

### Transaction Schema (paise only)
```dart
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,           // UUID v4
    required String userId,
    required String profileId,
    required int amount,          // PAISE — never double
    required TransactionType type, // INCOME | EXPENSE
    required String categoryId,
    required TransactionSource source, // MANUAL | SMS | VOICE | INVOICE | RECURRING
    required DateTime transactionDate,
    String? merchantName,         // max 300 chars
    String? note,                 // max 500 chars
    String? invoiceId,            // only if source=INVOICE
    String? recurringId,          // only if source=RECURRING
    String? smsHash,              // only if source=SMS
    required SyncStatus syncStatus, // PENDING | SYNCED | FAILED
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,          // SOFT DELETE ONLY — never hard delete
  }) = _Transaction;
}
```

### Validation Rules (Frontend Spec section 3)
```dart
class TransactionValidator {
  static String? validateAmount(int? paise) {
    if (paise == null || paise <= 0) return 'Amount must be greater than ₹0';
    if (paise > 100000000) return 'Amount cannot exceed ₹10,00,000'; // 10L
    return null;
  }

  static String? validateDate(DateTime? date) {
    if (date == null) return 'Date is required';
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    if (date.isAfter(tomorrow)) return 'Date cannot be in the future';
    if (date.isBefore(DateTime(2000))) return 'Date too far in the past';
    return null;
  }

  static String? validateNote(String? note) {
    if (note == null || note.isEmpty) return null; // optional
    if (note.length > 500) return 'Note too long (max 500 characters)';
    return null;
  }
}
```

### Gemini Categorisation Integration
```dart
// Only send merchant name — NEVER send full SMS or amount
Future<GeminiCategoryResult> categorise(String merchantName) async {
  final prompt = '''
    Categorise this merchant for an Indian small business expense tracker.
    Merchant: $merchantName
    Categories: ${categories.map((c) => c.name).join(', ')}
    Respond in JSON only: {"categoryId": "uuid", "confidence": 0.0-1.0}
  ''';

  // Parse as JSON only — never trust raw text
  // If confidence < 0.6 → do not auto-select
  // If confidence >= 0.6 → pre-select in UI
}
```

### Voice Entry Pipeline
```dart
// Uses speech_to_text package
// Parse: "eight hundred fifty rupees for groceries"
// → amount: 85000 paise, category hint: 'groceries'
// → pass to Gemini for category match
// → pre-fill AddTransactionScreen
```

### Receipt OCR Pipeline
```dart
// 1. image_picker → camera
// 2. Send to Gemini Vision API
// 3. Extract: amount, merchant, date from receipt image
// 4. Pre-fill AddTransactionScreen with extracted values
// 5. User confirms — never auto-save OCR results
```

### Atomic Invoice → Transaction (TAD section 5)
```dart
// ALWAYS use Firestore batch — never two separate writes
Future<Either<Failure, void>> markInvoicePaid(String invoiceId) async {
  final batch = _firestore.batch();

  // Write 1: Update invoice status
  batch.update(invoiceRef, {
    'status': 'PAID',
    'paidAt': FieldValue.serverTimestamp(),
  });

  // Write 2: Create income transaction
  batch.set(newTransactionRef, transaction.toJson());

  // Commit atomically — either both succeed or both fail
  await batch.commit();
}
```

### Soft Delete Pattern
```dart
// NEVER hard delete — GST requires 7-year retention
Future<Either<Failure, void>> softDelete(String transactionId) async {
  await _firestore.collection('transactions').doc(transactionId).update({
    'deletedAt': FieldValue.serverTimestamp(),
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

// Always filter deleted in queries
.where('deletedAt', isNull: true)
```

## Recommended AI Models
- **Primary**: Gemini 2.5 Pro (knows Gemini API natively)
- **Secondary**: Claude Sonnet (complex business logic)
- **For OCR prompts**: Gemini 2.5 Flash (multimodal, fast)
