import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/features/sms_capture/data/financial_sms_detector.dart';

void main() {
  late FinancialSmsDetector detector;

  setUp(() {
    detector = FinancialSmsDetector();
  });

  // ── Helper ──────────────────────────────────────────────────────────────────

  void expectFinancial(String sms, {double minScore = 4.0}) {
    final result = detector.detect(sms);
    expect(
      result.isFinancial,
      isTrue,
      reason: 'Expected financial but got score=${result.confidence} '
          'signals=${result.matchedSignals} for: "$sms"',
    );
    expect(result.confidence, greaterThanOrEqualTo(minScore));
  }

  void expectNotFinancial(String sms) {
    final result = detector.detect(sms);
    expect(
      result.isFinancial,
      isFalse,
      reason: 'Expected NOT financial but got score=${result.confidence} '
          'signals=${result.matchedSignals} for: "$sms"',
    );
  }

  // ── Task-specified test cases ───────────────────────────────────────────────

  group('Task-specified detection scenarios', () {
    test('1. UPI payment to merchant — detected as financial', () {
      expectFinancial('Rs 500 paid to Zomato via UPI Ref XXXXX');
    });

    test('2. Salary credit — detected as financial', () {
      expectFinancial('Salary of Rs 50,000 credited.');
    });

    test('3. ICICI debit — detected as financial', () {
      expectFinancial('ICICI Bank Acct XX101 debited for Rs 1.00');
    });

    test('4. OTP SMS — NOT financial', () {
      expectNotFinancial('Your OTP is 123456');
    });

    test('5. Order shipment notification — NOT financial', () {
      expectNotFinancial('Your order from Amazon has shipped.');
    });

    test('6. Movie ticket booking confirmation — NOT financial', () {
      expectNotFinancial('Movie ticket booked successfully.');
    });

    test('7. Refund received — detected as financial', () {
      expectFinancial('Refund of Rs 500 received.');
    });
  });

  // ── Sender-independent detection (the JD-ICICIT-S bug) ─────────────────────

  group('Unknown sender detection', () {
    test(
        'JD-ICICIT-S bug: ICICI debit with unfamiliar telecom prefix is financial',
        () {
      // This is the exact SMS that triggered the production bug.
      final result = detector.detect(
        'ICICI Bank Acct XX101 debited for Rs 1.00 on 17-Jun',
        senderBoost: 0, // unknown sender → no boost
      );
      expect(result.isFinancial, isTrue);
      expect(result.confidence, greaterThanOrEqualTo(4.0));
      expect(result.matchedSignals, contains('debited for Rs'));
    });

    test(
        'New fintech sender with UPI payment is financial without sender boost',
        () {
      final result = detector.detect(
        'INR 1200.00 debited from your account via UPI. Ref: 653730769151',
        senderBoost: 0,
      );
      expect(result.isFinancial, isTrue);
    });

    test('Unknown sender with non-financial SMS is rejected', () {
      final result = detector.detect(
        'Thank you for contacting us. Our team will reply soon.',
        senderBoost: 0,
      );
      expect(result.isFinancial, isFalse);
    });
  });

  // ── Sender boost ─────────────────────────────────────────────────────────────

  group('Sender confidence boost', () {
    test('Known sender adds +2 to score', () {
      // This sparse SMS has only Rs → score 2 without boost, 4 with boost.
      // "Your A/c balance is Rs 5000" — balance(+1) + A/c(+1) + Rs(+2) = 4 already
      // Use an even sparser SMS to isolate the boost.
      final withBoost = detector.detect('Rs 500', senderBoost: 2.0);
      final withoutBoost = detector.detect('Rs 500', senderBoost: 0.0);
      expect(withBoost.confidence, equals(withoutBoost.confidence + 2));
    });

    test('Known sender boost appears in matchedSignals', () {
      final result = detector.detect('Rs 500 debited', senderBoost: 2.0);
      expect(
        result.matchedSignals.any((s) => s.startsWith('known_sender')),
        isTrue,
      );
    });

    test('Known sender with financial content has high confidence', () {
      final result = detector.detect(
        'INR 850.00 debited from A/c XX1234 on 17-May',
        senderBoost: 2.0,
      );
      expect(result.confidence, greaterThanOrEqualTo(8.0));
    });
  });

  // ── Currency indicators ───────────────────────────────────────────────────

  group('Currency indicator detection', () {
    test('₹ symbol triggers currency signal', () {
      final result = detector.detect('₹500 debited');
      expect(result.matchedSignals, contains('₹'));
    });

    test('Rs. with decimal triggers currency signal', () {
      final result = detector.detect('Rs.500 debited');
      expect(result.matchedSignals, contains('Rs'));
    });

    test('INR keyword triggers currency signal', () {
      final result = detector.detect('INR 2400 spent');
      expect(result.matchedSignals, contains('INR'));
    });

    test('AED triggers currency signal', () {
      final result = detector.detect('AED 150 debited from Emirates NBD');
      expect(result.isFinancial, isTrue);
    });

    test('KES/KSH triggers currency signal', () {
      final result = detector.detect('KES 500 received. MPESA code ABC123');
      expect(result.isFinancial, isTrue);
    });
  });

  // ── High-confidence multi-word patterns ──────────────────────────────────────

  group('High-confidence patterns (+3 each)', () {
    test('"debited for Rs" pattern adds +3', () {
      final withPattern = detector.detect('ICICI Bank debited for Rs 100');
      final withoutPattern = detector.detect('ICICI Bank debit Rs 100');
      // The high-confidence "debited for Rs" phrase only matches when the full
      // phrase is present — the partial "debit Rs" must not trigger it.
      expect(withPattern.matchedSignals, contains('debited for Rs'));
      expect(withoutPattern.matchedSignals, isNot(contains('debited for Rs')));
    });

    test('"paid to <word>" pattern adds +3', () {
      final result = detector.detect('You paid to Merchant via UPI');
      expect(result.matchedSignals, contains('paid to'));
      expect(result.isFinancial, isTrue);
    });

    test('"received from <word>" pattern adds +3', () {
      final result = detector.detect('Rs 1000 received from John');
      expect(result.matchedSignals, contains('received from'));
    });

    test('"UPI:" pattern adds +3', () {
      final result = detector.detect('INR 500 debited. UPI:653730769151');
      expect(result.matchedSignals, contains('UPI:'));
    });

    test('"A/c XXXX" pattern adds +3', () {
      final result = detector.detect('Your A/c XX1234 debited Rs 200');
      expect(result.matchedSignals, contains('A/c XXXX'));
    });

    test('"Txn ID" pattern adds +3', () {
      final result = detector.detect('Rs 300 credited. Txn ID:AB12345678');
      expect(result.matchedSignals, contains('Txn ID'));
    });
  });

  // ── Debit verbs ───────────────────────────────────────────────────────────

  group('Debit transaction verbs', () {
    for (final verb in [
      'debited',
      'debit',
      'spent',
      'paid',
      'payment',
      'purchase',
      'purchased',
      'withdrawn',
      'withdrawal',
      'withdraw',
      'transferred',
      'transfer',
      'trf',
      'autopay',
      'subscription',
      'deducted',
      'charged',
    ]) {
      test('"$verb" is recognised as a debit verb (+2)', () {
        final result = detector.detect('₹500 $verb from your account.');
        expect(result.matchedSignals, contains(verb));
      });
    }
  });

  // ── Credit verbs ──────────────────────────────────────────────────────────

  group('Credit transaction verbs', () {
    for (final verb in [
      'credited',
      'received',
      'deposited',
      'refund',
      'cashback',
      'salary',
      'interest',
      'reversal',
      'reward',
      'bonus',
    ]) {
      test('"$verb" is recognised as a credit verb (+2)', () {
        final result = detector.detect('₹500 $verb to your account.');
        expect(result.matchedSignals, contains(verb));
      });
    }
  });

  // ── Context keywords ──────────────────────────────────────────────────────

  group('Financial context keywords (+1 each)', () {
    test('"bank" keyword adds +1', () {
      final result = detector.detect('Your bank account has been updated.');
      expect(result.matchedSignals, contains('bank'));
    });

    test('"txn" keyword adds +1', () {
      final result = detector.detect('Txn of Rs 200 done.');
      expect(result.matchedSignals, contains('txn'));
    });

    test('"utr" keyword adds +1', () {
      final result = detector.detect('INR 500 received. UTR: 123456789012');
      expect(result.matchedSignals, contains('utr'));
    });

    test('"neft" keyword adds +1', () {
      final result = detector.detect('NEFT credit of INR 5000 received.');
      expect(result.isFinancial, isTrue);
    });
  });

  // ── False positive resistance ─────────────────────────────────────────────

  group('Non-financial SMS not misclassified', () {
    test('Promotional SMS without financial keywords', () {
      expectNotFinancial('Get 50% off on all orders today! Visit our app.');
    });

    test('Account update notification (no transaction)', () {
      expectNotFinancial('Your profile has been updated successfully.');
    });

    test('Delivery notification', () {
      expectNotFinancial('Your package has been delivered to your doorstep.');
    });

    test('App notification', () {
      expectNotFinancial('You have 3 new messages waiting.');
    });
  });

  // ── Score accuracy ────────────────────────────────────────────────────────

  group('Score calculations', () {
    test('"Rs 500 paid to Zomato via UPI Ref XXXXX" scores >= 7', () {
      // Rs(+2) + paid(+2) + upi(+2) + "paid to"(+3) = 9 minimum
      final result = detector.detect('Rs 500 paid to Zomato via UPI Ref XXXXX');
      expect(result.confidence, greaterThanOrEqualTo(7.0));
    });

    test('Empty string scores 0 and is not financial', () {
      final result = detector.detect('');
      expect(result.confidence, equals(0.0));
      expect(result.isFinancial, isFalse);
    });

    test('matchedSignals is unmodifiable', () {
      final result = detector.detect('Rs 500 debited');
      expect(
        () => (result.matchedSignals as List).add('hacked'),
        throwsUnsupportedError,
      );
    });
  });
}
