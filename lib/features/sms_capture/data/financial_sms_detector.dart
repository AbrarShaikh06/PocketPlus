import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinancialDetectionResult {
  final bool isFinancial;
  final double confidence;
  final List<String> matchedSignals;

  const FinancialDetectionResult({
    required this.isFinancial,
    required this.confidence,
    required this.matchedSignals,
  });
}

/// Content-based heuristic engine that scores any SMS for likelihood of being
/// a financial transaction. Sender ID is NEVER a gatekeeper — it is an optional
/// confidence boost supplied by the caller via [senderBoost].
///
/// Signal weights:
///   +3  high-confidence multi-word patterns (e.g. "debited for Rs", "A/c XXXX")
///   +2  currency indicators (₹, Rs, INR, AED, …) and transaction verbs
///   +1  financial context keywords (bank, balance, txn, utr, …)
///
/// An SMS with total score ≥ [_threshold] (4.0) is classified as financial.
/// The parser still acts as the definitive filter — only SMSes with a parseable
/// amount + verb produce a [ParsedSms].
class FinancialSmsDetector {
  static const double _threshold = 4.0;

  // ── Currency indicators ────────────────────────────────────────────── +2 each

  // Use regex for precision on short tokens; unambiguous ones use simple contains.
  static final _currencyPatterns = <String, RegExp>{
    '₹': RegExp(r'₹'),
    'Rs': RegExp(r'\brs\.?\s*[\d,]', caseSensitive: false),
    'INR': RegExp(r'\binr\b', caseSensitive: false),
    'USD': RegExp(r'\busd\b', caseSensitive: false),
    r'$': RegExp(r'\$\s*[\d,]'),
    'AED': RegExp(r'\baed\b', caseSensitive: false),
    'KES': RegExp(r'\b(?:kes|ksh)\b', caseSensitive: false),
    'EUR': RegExp(r'\beur\b', caseSensitive: false),
    'GBP': RegExp(r'\bgbp\b', caseSensitive: false),
  };

  // ── Transaction verbs ──────────────────────────────────────────────── +2 each
  // Multi-word entries are checked before their single-word components to
  // preserve independent signal counts (each phrase is a distinct signal).
  static const _transactionVerbs = <String>[
    // debit-side (longer phrases first)
    'cash withdrawal',
    'card purchase',
    'debited', 'debit',
    'withdrawn', 'withdrawal', 'withdraw',
    'transferred', 'transfer',
    'payment',
    'purchased', 'purchase',
    'spent', 'paid',
    'autopay', 'subscription',
    'deducted', 'charged',
    'trf',
    // credit-side (longer phrases first)
    'money received',
    'salary credited',
    'transfer received',
    'cash back',
    'credited', 'credit',
    'deposited', 'deposit',
    'cashback',
    'received',
    'refund',
    'reversal',
    'salary',
    'interest',
    'reward', 'bonus',
  ];

  // Short verbs that need word-boundary regex to avoid false substring matches.
  static final _boundaryVerbs = <String, RegExp>{
    'upi': RegExp(r'\bupi\b', caseSensitive: false),
    'emi': RegExp(r'\bemi\b', caseSensitive: false),
    'sent': RegExp(r'\bsent\b', caseSensitive: false),
  };

  // ── Financial context keywords ──────────────────────────────────────── +1 each
  static const _contextKeywords = <String>[
    'available bal',
    'card ending',
    'debit card',
    'credit card',
    'upi id',
    'ref no',
    'txn id',
    'account',
    'acct',
    'a/c',
    'bank',
    'balance',
    'transaction',
    'txn',
    'reference',
    'utr',
    'imps',
    'neft',
    'rtgs',
    'vpa',
    'merchant',
  ];

  // ── High-confidence multi-word patterns ────────────────────────────── +3 each
  static final _highConfidencePatterns = <String, RegExp>{
    'debited for Rs': RegExp(
      r'debited\s+(?:for|by|with|from)\s+(?:rs|inr|₹)',
      caseSensitive: false,
    ),
    'credited with Rs': RegExp(
      r'credited\s+(?:with|to|by)\s+(?:rs|inr|₹)',
      caseSensitive: false,
    ),
    'paid to': RegExp(r'\bpaid\s+to\s+\w', caseSensitive: false),
    'received from': RegExp(r'\breceived\s+from\s+\w', caseSensitive: false),
    'UPI:': RegExp(r'\bupi\s*:', caseSensitive: false),
    'Ref No': RegExp(
      r'\bref\s*(?:no|#|:|\.)?\s*[a-z0-9]{4,}',
      caseSensitive: false,
    ),
    'Txn ID': RegExp(
      // Allow optional "ID" keyword then optional separator before the code.
      // Handles: "Txn ID:AB1234", "Txn:AB1234", "Txn AB1234", "TxnID 1234"
      r'\btxn\s*(?:id)?\s*[:#./]?\s*[a-z0-9]{4,}',
      caseSensitive: false,
    ),
    'A/c XXXX': RegExp(r'\ba\/c\s+[x*\d]{4,}', caseSensitive: false),
  };

  /// Scores [smsText] across four signal tiers and returns a
  /// [FinancialDetectionResult].
  ///
  /// [senderBoost] adds to the score when the caller has already identified
  /// the sender as a known financial institution. Pass 2.0 for a known sender,
  /// 0.0 otherwise. The sender ID must NEVER be used to *reject* an SMS.
  FinancialDetectionResult detect(String smsText, {double senderBoost = 0.0}) {
    final lower = smsText.toLowerCase();
    var score = 0.0;
    final matched = <String>[];

    void add(String label, double weight) {
      score += weight;
      matched.add(label);
    }

    if (senderBoost > 0) {
      score += senderBoost;
      matched.add('known_sender(+${senderBoost.toStringAsFixed(0)})');
    }

    // ── Currency indicators (+2 each) ──────────────────────────────────
    for (final entry in _currencyPatterns.entries) {
      if (entry.value.hasMatch(smsText)) add(entry.key, 2);
    }

    // ── Transaction verbs (+2 each) ────────────────────────────────────
    for (final verb in _transactionVerbs) {
      if (lower.contains(verb)) add(verb, 2);
    }
    for (final entry in _boundaryVerbs.entries) {
      if (entry.value.hasMatch(smsText)) add(entry.key, 2);
    }

    // ── Context keywords (+1 each) ─────────────────────────────────────
    for (final kw in _contextKeywords) {
      if (lower.contains(kw)) add(kw, 1);
    }

    // ── High-confidence patterns (+3 each) ────────────────────────────
    for (final entry in _highConfidencePatterns.entries) {
      if (entry.value.hasMatch(smsText)) add(entry.key, 3);
    }

    final isFinancial = score >= _threshold;

    debugPrint(
      '[FinancialSmsDetector] Score: $score | '
      'Matched: ${matched.join(', ')} | '
      'isFinancial: $isFinancial',
    );

    return FinancialDetectionResult(
      isFinancial: isFinancial,
      confidence: score,
      matchedSignals: List.unmodifiable(matched),
    );
  }
}

final financialSmsDetectorProvider = Provider<FinancialSmsDetector>((ref) {
  return FinancialSmsDetector();
});
