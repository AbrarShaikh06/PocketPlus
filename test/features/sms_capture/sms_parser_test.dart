import 'package:pocket_plus/core/analytics/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/features/sms_capture/data/bank_pattern_matcher.dart';
import 'package:pocket_plus/features/sms_capture/data/financial_sms_detector.dart';
import 'package:pocket_plus/features/sms_capture/data/firestore_sms_dedup_data_source.dart';
import 'package:pocket_plus/features/sms_capture/data/sms_parser.dart';
import 'package:pocket_plus/features/sms_capture/domain/use_cases/process_sms_use_case.dart';
import 'package:pocket_plus/features/sms_capture/data/sms_platform_channel.dart';
import 'package:pocket_plus/shared/models/transaction_type.dart';

class FakeAnalyticsService extends Fake implements AnalyticsService {
  final List<String> loggedEvents = [];

  @override
  Future<void> logSmsParseFailed() async {
    loggedEvents.add('sms_parse_failed');
  }

  @override
  Future<void> logSmsDuplicateSkipped() async {
    loggedEvents.add('sms_duplicate_skipped');
  }
}

class FakeSmsDedupRepository implements SmsDedupRepository {
  final Set<String> duplicates = {};
  final List<Map<String, dynamic>> loggedActions = [];

  @override
  Future<bool> checkDuplicate(String userId, String smsHash) async {
    return duplicates.contains(smsHash);
  }

  @override
  Future<bool> claim(String userId, String smsHash) async {
    if (duplicates.contains(smsHash)) return false;
    duplicates.add(smsHash);
    return true;
  }

  @override
  Future<void> writeDedupLog(
    String userId,
    String smsHash,
    DedupAction action,
    String? transactionId,
  ) async {
    loggedActions.add({
      'userId': userId,
      'smsHash': smsHash,
      'action': action,
      'transactionId': transactionId,
    });
  }
}

void main() {
  late FakeAnalyticsService fakeAnalytics;
  late FakeSmsDedupRepository fakeDedupRepository;
  late BankPatternMatcher patternMatcher;
  late FinancialSmsDetector detector;
  late SmsParser smsParser;
  late ProcessSmsUseCase useCase;

  setUp(() {
    fakeAnalytics = FakeAnalyticsService();
    fakeDedupRepository = FakeSmsDedupRepository();
    patternMatcher = BankPatternMatcher();
    detector = FinancialSmsDetector();
    smsParser = SmsParser(analytics: fakeAnalytics);
    useCase = ProcessSmsUseCase(
      detector: detector,
      patternMatcher: patternMatcher,
      parser: smsParser,
      dedupRepository: fakeDedupRepository,
      analytics: fakeAnalytics,
    );
  });

  group('SmsParser Unit Tests', () {
    test('1. HDFC debit basic parses correctly', () {
      final now = DateTime(2026, 5, 17);
      final parsed = smsParser.parse(
        'INR 850.00 debited from A/c XX1234 on 17-May',
        'HDFCBK',
        now: now,
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 85000);
      expect(parsed.type, TransactionType.expense);
      expect(parsed.transactionDate, now);
      expect(parsed.senderId, 'HDFCBK');
    });

    test('2. HDFC credit parses correctly', () {
      final now = DateTime(2026, 5, 17);
      final parsed = smsParser.parse(
        'INR 5000.00 credited to A/c XX1234 on 17-May',
        'VK-HDFCBK',
        now: now,
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 500000);
      expect(parsed.type, TransactionType.income);
    });

    test('3. SBI with comma parses correctly', () {
      final parsed = smsParser.parse(
        'Your A/c debited by Rs.1,500.00',
        'SBI',
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 150000);
      expect(parsed.type, TransactionType.expense);
    });

    test('4. ICICI format parses correctly', () {
      final parsed = smsParser.parse(
        'ICICI Bank Acct XX1234 debited for Rs 2400.00',
        'ICICIB',
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 240000);
      expect(parsed.type, TransactionType.expense);
    });

    test('5. GPay payment parses correctly', () {
      final parsed = smsParser.parse(
        'You have successfully paid Rs. 500 to Merchant',
        'GPAY',
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 50000);
      expect(parsed.type, TransactionType.expense);
      expect(parsed.merchantName, 'Merchant');
    });

    test('6. Amount in words returns null and logs parse_failed', () {
      final parsed = smsParser.parse(
        'Payment of five hundred rupees received',
        'HDFCBK',
      );
      expect(parsed, isNull);
      expect(fakeAnalytics.loggedEvents, contains('sms_parse_failed'));
    });

    test('7. Credit card bill returns null without log', () {
      final parsed = smsParser.parse(
        'HDFC Credit Card bill of Rs 15000 due',
        'HDFCBK',
      );
      expect(parsed, isNull);
      expect(fakeAnalytics.loggedEvents, isNot(contains('sms_parse_failed')));
    });

    test('9. Zero amount returns null', () {
      final parsed = smsParser.parse(
        'INR 0.00 debited',
        'HDFCBK',
      );
      expect(parsed, isNull);
      expect(fakeAnalytics.loggedEvents, isNot(contains('sms_parse_failed')));
    });

    test('10. Non-bank SMS (OTP) returns null silently', () {
      final parsed = smsParser.parse(
        'OTP is 123456 for login',
        'HDFCBK',
      );
      expect(parsed, isNull);
      expect(fakeAnalytics.loggedEvents, isNot(contains('sms_parse_failed')));
    });

    test('11. International amount (USD) returns null silently', () {
      final parsed = smsParser.parse(
        'USD 50.00 received',
        'HDFCBK',
      );
      expect(parsed, isNull);
      expect(fakeAnalytics.loggedEvents, isNot(contains('sms_parse_failed')));
    });

    test('12. Malformed amount returns null and logs sms_parse_failed', () {
      final parsed = smsParser.parse(
        'INR abc.def debited',
        'HDFCBK',
      );
      expect(parsed, isNull);
      expect(fakeAnalytics.loggedEvents, contains('sms_parse_failed'));
    });

    test('Edge Case: Comma-separated thousands parses correctly', () {
      final parsed = smsParser.parse(
        'Your A/c debited by Rs.1,50,000.00',
        'SBI',
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 15000000);
    });

    test('Edge Case: Amount at start of SMS parses correctly', () {
      final parsed = smsParser.parse(
        'INR 250 debited for dinner',
        'HDFCBK',
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 25000);
    });

    test('Edge Case: Multiple amounts in one SMS takes first match', () {
      final parsed = smsParser.parse(
        'Your A/c debited by Rs. 200, balance is Rs. 1000',
        'SBI',
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 20000);
    });

    test('Edge Case: Kotak format without decimal parses correctly', () {
      final parsed = smsParser.parse(
        'INR 3000 debited',
        'KOTAKB',
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 300000);
    });

    test('Edge Case: Sender ID case insensitivity works', () {
      final isKnown = patternMatcher.isKnownBankSender('hdfcbk');
      expect(isKnown, isTrue);
    });

    test('Edge Case: SHA256 hash consistency works', () {
      final parsed1 = smsParser.parse('INR 100 debited', 'HDFCBK');
      final parsed2 = smsParser.parse('INR 100 debited', 'HDFCBK');
      expect(parsed1!.smsHash, parsed2!.smsHash);
    });

    // ── Parser improvements ──────────────────────────────────────────────────

    test('Pattern 5: "500 INR" (amount before currency) parses correctly', () {
      final parsed = smsParser.parse(
        'Payment of 500 INR credited to your account.',
        'ICICIB',
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 50000);
      expect(parsed.type, TransactionType.income);
    });

    test('Pattern 5: "2400 AED" (amount before AED) parses correctly', () {
      final parsed = smsParser.parse(
        '2400 AED debited from Emirates NBD account.',
        'ENBD',
      );
      expect(parsed, isNotNull);
      expect(parsed!.amount, 240000);
      expect(parsed.type, TransactionType.expense);
    });

    test('accountLast4 extracted from "A/c XX1234"', () {
      final parsed = smsParser.parse(
        'INR 850.00 debited from A/c XX1234 on 17-May',
        'HDFCBK',
      );
      expect(parsed, isNotNull);
      expect(parsed!.accountLast4, '1234');
    });

    test('accountLast4 extracted from "Acct XX4567"', () {
      final parsed = smsParser.parse(
        'ICICI Bank Acct XX4567 debited for Rs 100',
        'ICICIB',
      );
      expect(parsed, isNotNull);
      expect(parsed!.accountLast4, '4567');
    });

    test('accountLast4 extracted from masked "XXXX1234" pattern', () {
      final parsed = smsParser.parse(
        'Your card XXXX1234 was debited Rs 500.',
        'HDFCBK',
      );
      expect(parsed, isNotNull);
      expect(parsed!.accountLast4, '1234');
    });

    test('accountLast4 is null when no account pattern present', () {
      final parsed = smsParser.parse(
        'INR 500 debited via UPI.',
        'HDFCBK',
      );
      expect(parsed, isNotNull);
      expect(parsed!.accountLast4, isNull);
    });

    test('Merchant extracted from "merchant ZOMATO" keyword', () {
      final parsed = smsParser.parse(
        'Rs 350 debited. merchant ZOMATO via UPI.',
        'HDFCBK',
      );
      expect(parsed, isNotNull);
      expect(parsed!.merchantName?.toUpperCase(), contains('ZOMATO'));
    });
  });

  group('ProcessSmsUseCase Integration/Deduplication Tests', () {
    test('8. Duplicate SMS returns null and logs duplicate analytics',
        () async {
      const raw = RawSms(
        text: 'INR 100.00 debited from A/c XX1234',
        senderId: 'HDFCBK',
      );

      final parsed = smsParser.parse(raw.text, raw.senderId);
      expect(parsed, isNotNull);

      // Pre-claim the hash so the use case's atomic claim() fails as a
      // duplicate. The claim itself is the dedup-log write in this design —
      // there is no separate writeDedupLog() call on the duplicate path.
      fakeDedupRepository.duplicates.add(parsed!.smsHash);

      final result = await useCase.execute(raw, 'user_123');

      expect(result, isNull);
      expect(fakeAnalytics.loggedEvents, contains('sms_duplicate_skipped'));
    });

    test('Known sender passes through non-duplicate transaction', () async {
      const raw = RawSms(
        text: 'INR 100.00 debited from A/c XX1234',
        senderId: 'HDFCBK',
      );

      final result = await useCase.execute(raw, 'user_123');

      expect(result, isNotNull);
      expect(result!.amount, 10000);
      expect(fakeDedupRepository.loggedActions, isEmpty);
    });

    // ── New architecture: sender is NOT a gatekeeper ─────────────────────────

    test('Financial SMS from unknown sender is accepted (architecture fix)',
        () async {
      // Previously this would have returned null because UNKNOWN_SENDER
      // was not in BankPatternMatcher. With the new architecture the content
      // score (INR+2, debited+2, a/c+1 = 5) is sufficient to proceed.
      const raw = RawSms(
        text: 'INR 100.00 debited from A/c XX1234',
        senderId: 'UNKNOWN_SENDER',
      );

      final result = await useCase.execute(raw, 'user_123');

      expect(result, isNotNull);
      expect(result!.amount, 10000);
    });

    test(
        'JD-ICICIT-S regression: unknown telecom prefix no longer loses transaction',
        () async {
      // Production bug: "JD-ICICIT-S" was rejected because it was not in the
      // hardcoded list, even though the SMS content was clearly a bank debit.
      const raw = RawSms(
        text: 'ICICI Bank Acct XX101 debited for Rs 1.00 on 17-Jun',
        senderId: 'JD-ICICIT-S',
      );

      final result = await useCase.execute(raw, 'user_123');

      expect(
        result,
        isNotNull,
        reason: 'JD-ICICIT-S should be accepted via content heuristic',
      );
      expect(result!.amount, 100);
      expect(result.type, TransactionType.expense);
    });

    test('Non-financial SMS from unknown sender is rejected', () async {
      const raw = RawSms(
        text: 'Your OTP is 123456. Do not share with anyone.',
        senderId: 'COMPLETELY_UNKNOWN',
      );

      final result = await useCase.execute(raw, 'user_123');

      expect(result, isNull);
    });

    test('Non-financial SMS from known sender is still rejected by parser',
        () async {
      // Sender is known → heuristic passes, but parser finds no amount/verb.
      const raw = RawSms(
        text: 'Your HDFC account security settings have been updated.',
        senderId: 'HDFCBK',
      );

      final result = await useCase.execute(raw, 'user_123');

      // The heuristic + sender boost passes (bank+1, account+1, known+2 = 4),
      // but the parser finds no parseable amount+verb → correctly returns null.
      expect(result, isNull);
    });

    test('New bank sender auto-detected without app update', () async {
      // Simulates a brand-new fintech sender not in any hardcoded list.
      const raw = RawSms(
        text: 'INR 5000.00 credited to your account via NEFT. Ref: 789012345',
        senderId: 'VM-NEWFINTECH',
      );

      final result = await useCase.execute(raw, 'user_123');

      expect(
        result,
        isNotNull,
        reason:
            'New bank senders should work automatically via content heuristic',
      );
      expect(result!.amount, 500000);
      expect(result.type, TransactionType.income);
    });
  });

  group('SmsParser transaction date/time extraction', () {
    // Reference "now" is a different calendar day from the SMS dates below,
    // so a date-only SMS must resolve to midnight on the SMS's own date —
    // not to the scan time.
    final scanNow = DateTime(2026, 6, 23, 14, 0, 0);

    test('month-name date, no time → that date at midnight', () {
      final parsed = smsParser.parse(
        'ICICI Bank Acct XX101 debited for Rs 5.00 on 18-Jun-26; '
            'SHREE LINGAM ST credited. UPI:616961434773.',
        'JD-ICICIT-S',
        now: scanNow,
      );
      expect(parsed, isNotNull);
      expect(parsed!.transactionDate, DateTime(2026, 6, 18));
    });

    test('numeric day-first date + 24h time with seconds', () {
      final parsed = smsParser.parse(
        'Rs 1200.00 debited from A/c XX1234 on 18-06-2026 14:32:05',
        'HDFCBK',
        now: scanNow,
      );
      expect(parsed, isNotNull);
      expect(parsed!.transactionDate, DateTime(2026, 6, 18, 14, 32, 5));
    });

    test('month-name date + 12h am/pm time', () {
      final parsed = smsParser.parse(
        'Rs 1200.00 debited on 18-Jun-2026 at 02:30 PM',
        'HDFCBK',
        now: scanNow,
      );
      expect(parsed, isNotNull);
      expect(parsed!.transactionDate, DateTime(2026, 6, 18, 14, 30));
    });

    test('ISO date + time', () {
      final parsed = smsParser.parse(
        'Rs 999.00 debited on 2026-03-09 09:15',
        'AXISBK',
        now: scanNow,
      );
      expect(parsed, isNotNull);
      expect(parsed!.transactionDate, DateTime(2026, 3, 9, 9, 15));
    });

    test('date-only SMS captured same day keeps the real-time clock', () {
      // SMS dated today, no embedded time → keep the accurate current time
      // rather than collapsing to midnight.
      final parsed = smsParser.parse(
        'Rs 500.00 debited from A/c XX1234 on 23-Jun-2026',
        'HDFCBK',
        now: scanNow,
      );
      expect(parsed, isNotNull);
      expect(parsed!.transactionDate, scanNow);
    });

    test('no date in SMS → falls back to supplied now', () {
      final parsed = smsParser.parse(
        'Your A/c debited by Rs.1,500.00',
        'SBI',
        now: scanNow,
      );
      expect(parsed, isNotNull);
      expect(parsed!.transactionDate, scanNow);
    });

    test('two-digit year is expanded to 2000+', () {
      final parsed = smsParser.parse(
        'Rs 250.00 debited on 05-Jan-25 at 10:05:30',
        'HDFCBK',
        now: scanNow,
      );
      expect(parsed, isNotNull);
      expect(parsed!.transactionDate, DateTime(2025, 1, 5, 10, 5, 30));
    });
  });
}
