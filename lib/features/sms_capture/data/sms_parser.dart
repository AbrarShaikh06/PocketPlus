import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/analytics/analytics_service.dart';
import '../../../shared/models/transaction_type.dart';
import '../domain/entities/parsed_sms.dart';

class SmsParser {
  final AnalyticsService _analytics;

  SmsParser({required AnalyticsService analytics}) : _analytics = analytics;

  static const Map<String, List<String>> _currencyIndicators = {
    'INR': ['rs', '₹', 'rupee', 'rupees', 'inr'],
    'AED': ['aed', 'dh', 'dirham'],
    'KES': ['ksh', 'kes'],
  };

  static const Map<String, int> _monthMap = {
    'jan': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'aug': 8,
    'sep': 9,
    'oct': 10,
    'nov': 11,
    'dec': 12,
  };

  ParsedSms? parse(String rawSmsText, String senderId, {DateTime? now}) {
    debugPrint('Parsing SMS from $senderId: $rawSmsText');
    final textLower = rawSmsText.toLowerCase();

    // 1. Skip credit card billing statements — not transaction SMSes.
    if (textLower.contains('bill') ||
        textLower.contains('minimum due') ||
        textLower.contains('outstanding') ||
        textLower.contains('due statement')) {
      debugPrint('Skipping SMS: contains bill/statement keyword');
      return null;
    }

    // 2. Detect currency from text content.
    final currencyCode = _detectCurrency(textLower);

    // 3. Skip non-INR currencies that are unrecognised (e.g. USD, EUR, GBP).
    final hasNonInr = textLower.contains('usd') ||
        textLower.contains('eur') ||
        textLower.contains('gbp') ||
        textLower.contains('\$');
    final hasRecognizedCurrency = currencyCode != null;

    if (hasNonInr && !hasRecognizedCurrency) {
      debugPrint('Skipping SMS: non-INR currency detected');
      return null;
    }

    // 4. Compute SHA256 of raw text for deduplication.
    final bytes = utf8.encode(rawSmsText);
    final smsHash = sha256.convert(bytes).toString();

    // ── Verb lists ────────────────────────────────────────────────────────────
    final debitVerbs = [
      'debited',
      'paid',
      'sent',
      'spent',
      'purchased',
      'purchase',
      'withdrawn',
      'withdrawal',
      'withdraw',
      'transferred',
      'transfer',
      'payment',
      'upi',
      'trf',
    ];
    final creditVerbs = [
      'credited',
      'received',
      'deposited',
      'refund',
      'refunded',
      'cashback',
      'cash back',
      'repayment',
      'repaid',
      'added',
    ];
    final allVerbs = [...debitVerbs, ...creditVerbs];
    final hasVerb = allVerbs.any((v) => textLower.contains(v));

    // ── Regex patterns ────────────────────────────────────────────────────────
    // currencyPattern covers the currency symbol/code that precedes the amount.
    const currencyPattern = r'(?:Rs\.?|INR|₹|AED|KSH|KES|DH)';
    const verbAlternation =
        r'(debited|credited|paid|received|sent|spent|purchased|withdrawn|withdrawal|transferred|deposited|refund|refunded|cashback|repaid|payment)';

    // Pattern 1: Currency-then-amount-then-verb  e.g. "₹500 debited"
    final patternAmountFirst = RegExp(
      '$currencyPattern\\.?\\s*([\\d,]+(?:\\.[\\d]+)?)\\s*$verbAlternation',
      caseSensitive: false,
    );

    // Pattern 2: Verb-then-currency-then-amount  e.g. "debited by Rs.35"
    final patternVerbFirst = RegExp(
      '$verbAlternation.{0,30}?$currencyPattern\\.?\\s*([\\d,]+(?:\\.[\\d]+)?)',
      caseSensitive: false,
    );

    // Pattern 3: "debited by Rs.35" / "credited with ₹500"
    final patternDebitedBy = RegExp(
      '(?:debited|credited|paid|sent)\\s+(?:by|of|with)\\s+$currencyPattern\\.?\\s*([\\d,]+(?:\\.[\\d]+)?)',
      caseSensitive: false,
    );

    // Pattern 4: Currency-then-amount at end of message  e.g. "Trf to X - Rs.35"
    final patternAmountEnd = RegExp(
      '$currencyPattern\\.?\\s*([\\d,]+(?:\\.[\\d]+)?)\\s*\$',
      caseSensitive: false,
    );

    // Pattern 5: Amount-then-currency  e.g. "500 INR", "2400 AED"
    // Common in some bank formats where the unit follows the number.
    final patternAmountBeforeCurrency = RegExp(
      r'([\d,]+(?:\.\d+)?)\s+(?:INR|AED|KSH|KES)\b',
      caseSensitive: false,
    );

    String? matchedAmountStr;
    String? matchedVerb;

    // Try patterns in descending specificity.
    final matchDebitedBy = patternDebitedBy.firstMatch(rawSmsText);
    if (matchDebitedBy != null) {
      matchedAmountStr = matchDebitedBy.group(1);
      matchedVerb = textLower.contains('credited') ? 'credited' : 'debited';
      debugPrint(
        'Matched pattern "debited by Rs": amount=$matchedAmountStr, verb=$matchedVerb',
      );
    }

    if (matchedAmountStr == null) {
      final m = patternAmountFirst.firstMatch(rawSmsText);
      if (m != null) {
        matchedAmountStr = m.group(1);
        matchedVerb = m.group(2);
        debugPrint(
          'Matched pattern "amount-first": amount=$matchedAmountStr, verb=$matchedVerb',
        );
      }
    }

    if (matchedAmountStr == null) {
      final m = patternVerbFirst.firstMatch(rawSmsText);
      if (m != null) {
        matchedVerb = m.group(1);
        matchedAmountStr = m.group(2);
        debugPrint(
          'Matched pattern "verb-first": amount=$matchedAmountStr, verb=$matchedVerb',
        );
      }
    }

    if (matchedAmountStr == null) {
      final m = patternAmountBeforeCurrency.firstMatch(rawSmsText);
      if (m != null) {
        matchedAmountStr = m.group(1);
        // Prefer verb found AFTER the amount+currency — the controlling verb
        // often follows the amount (e.g. "500 INR credited"). Scanning the full
        // text first-debit-wins would incorrectly pick up noun uses of "payment".
        final tail = textLower.substring(m.end);
        final verbInTail = allVerbs.firstWhere(
          (v) => tail.contains(v),
          orElse: () => '',
        );
        if (verbInTail.isNotEmpty) {
          matchedVerb = verbInTail;
        } else {
          // Nothing after the amount — check full text, credit-first so that
          // "Salary 50000 INR" doesn't get beaten by a preceding noun "payment".
          matchedVerb = [...creditVerbs, ...debitVerbs].firstWhere(
            (v) => textLower.contains(v),
            orElse: () => '',
          );
        }
        if (matchedVerb.isNotEmpty) {
          debugPrint(
            'Matched pattern "amount-before-currency": amount=$matchedAmountStr, verb=$matchedVerb',
          );
        }
      }
    }

    // Fallback: known verb in text but amount only at end of message.
    if (matchedAmountStr == null && hasVerb) {
      final m = patternAmountEnd.firstMatch(rawSmsText);
      if (m != null) {
        matchedAmountStr = m.group(1);
        final isDebitSms = debitVerbs.any((v) => textLower.contains(v));
        final isCreditSms = creditVerbs.any((v) => textLower.contains(v));
        if (isDebitSms && !isCreditSms) {
          matchedVerb = 'debited';
        } else if (isCreditSms && !isDebitSms) {
          matchedVerb = 'credited';
        } else {
          matchedVerb = debitVerbs.firstWhere(
            (v) => textLower.contains(v),
            orElse: () => '',
          );
          if (matchedVerb.isEmpty) {
            matchedVerb = allVerbs.firstWhere(
              (v) => textLower.contains(v),
              orElse: () => '',
            );
          }
        }
        if (matchedVerb.isNotEmpty) {
          debugPrint(
            'Matched pattern "amount-end": amount=$matchedAmountStr, verb=$matchedVerb',
          );
        }
      }
    }

    if (matchedAmountStr == null ||
        matchedVerb == null ||
        matchedVerb.isEmpty) {
      debugPrint(
        'Parse failed: no amount/verb match found. '
        'hasVerb=$hasVerb, hasCurrency=$hasRecognizedCurrency',
      );
      if (hasVerb && hasRecognizedCurrency) _logParseFailed();
      return null;
    }

    // Convert amount string → paise (int).
    final cleanAmountStr = matchedAmountStr.replaceAll(',', '');
    final doubleAmount = double.tryParse(cleanAmountStr);
    if (doubleAmount == null) {
      debugPrint('Parse failed: could not parse amount "$cleanAmountStr"');
      _logParseFailed();
      return null;
    }

    final amountInPaise = (doubleAmount * 100).round();
    if (amountInPaise <= 0) {
      debugPrint('Parse failed: amount <= 0 ($amountInPaise)');
      return null;
    }

    // Resolve transaction type from the matched verb.
    final verbLower = matchedVerb.toLowerCase();
    final TransactionType type;
    final isDebitVerb = debitVerbs.any((v) => verbLower.contains(v.trim()));
    final isCreditVerb = creditVerbs.any((v) => verbLower.contains(v.trim()));
    if (isDebitVerb) {
      type = TransactionType.expense;
    } else if (isCreditVerb) {
      type = TransactionType.income;
    } else {
      debugPrint('Parse failed: unknown verb "$matchedVerb"');
      return null;
    }

    debugPrint(
      '[SmsParser] Transaction parsed successfully: amount=${amountInPaise}paise, type=$type',
    );

    final merchantName = _extractMerchant(rawSmsText);
    final accountLast4 = _extractAccountLast4(rawSmsText);
    final mpesaCode = _extractMpesaCode(rawSmsText);
    final transactionDateTime =
        _extractTransactionDateTime(rawSmsText, now ?? DateTime.now());

    return ParsedSms(
      amount: amountInPaise,
      type: type,
      merchantName: merchantName,
      transactionDate: transactionDateTime,
      smsHash: smsHash,
      senderId: senderId,
      rawSmsText: rawSmsText,
      accountLast4: accountLast4,
      currencyCode: currencyCode ?? 'INR',
      mpesaCode: mpesaCode,
    );
  }

  // ── Private helpers ─────────────────────────────────────────────────────────

  String? _detectCurrency(String textLower) {
    for (final entry in _currencyIndicators.entries) {
      for (final indicator in entry.value) {
        if (textLower.contains(indicator)) return entry.key;
      }
    }
    return null;
  }

  /// Extracts the transaction date and (when present) time from the SMS body.
  ///
  /// Handles the common Indian bank formats:
  ///   18-Jun-26 / 18-Jun-2026 / 18 Jun 2026   (month name, day-first)
  ///   18-06-26 / 18/06/2026                    (numeric, day-first)
  ///   2026-06-18                               (ISO)
  /// plus an optional time "14:32", "14:32:05" or "02:30 PM", optionally
  /// preceded by "at".
  ///
  /// Falls back to [fallback] when no date is found. When a date is found
  /// without a time, the time defaults to midnight — except for a same-day
  /// (real-time) capture, where [fallback]'s accurate current time is kept.
  DateTime _extractTransactionDateTime(String text, DateTime fallback) {
    int? year, month, day;

    // Month-name date: 18-Jun-26, 18 Jun 2026, 18/June/2026
    final mName = RegExp(
      r'\b(\d{1,2})[\-/\s]([A-Za-z]{3})[A-Za-z]*[\-/\s](\d{2,4})\b',
      caseSensitive: false,
    ).firstMatch(text);
    if (mName != null) {
      day = int.tryParse(mName.group(1)!);
      month = _monthMap[mName.group(2)!.toLowerCase()];
      year = _normalizeYear(int.tryParse(mName.group(3)!));
    }

    // ISO date: 2026-06-18
    if (month == null) {
      final iso = RegExp(r'\b(\d{4})-(\d{1,2})-(\d{1,2})\b').firstMatch(text);
      if (iso != null) {
        year = int.tryParse(iso.group(1)!);
        month = int.tryParse(iso.group(2)!);
        day = int.tryParse(iso.group(3)!);
      }
    }

    // Numeric day-first date: 18-06-26, 18/06/2026
    if (month == null) {
      final numeric =
          RegExp(r'\b(\d{1,2})[\-/](\d{1,2})[\-/](\d{2,4})\b').firstMatch(text);
      if (numeric != null) {
        day = int.tryParse(numeric.group(1)!);
        month = int.tryParse(numeric.group(2)!);
        year = _normalizeYear(int.tryParse(numeric.group(3)!));
      }
    }

    if (year == null ||
        month == null ||
        day == null ||
        month < 1 ||
        month > 12 ||
        day < 1 ||
        day > 31) {
      return fallback;
    }

    // Optional time: "14:32", "14:32:05", "02:30 PM".
    final timeMatch = RegExp(
      r'\b(\d{1,2}):(\d{2})(?::(\d{2}))?\s*(am|pm)?\b',
      caseSensitive: false,
    ).firstMatch(text);

    if (timeMatch == null) {
      // No explicit time in the SMS. For a same-day (real-time) capture the
      // current time is accurate, so keep it; for older SMS use midnight.
      if (year == fallback.year &&
          month == fallback.month &&
          day == fallback.day) {
        return fallback;
      }
      return DateTime(year, month, day);
    }

    int hour = int.tryParse(timeMatch.group(1)!) ?? 0;
    final minute = int.tryParse(timeMatch.group(2)!) ?? 0;
    final second = int.tryParse(timeMatch.group(3) ?? '') ?? 0;
    final ampm = timeMatch.group(4)?.toLowerCase();
    if (ampm == 'pm' && hour < 12) hour += 12;
    if (ampm == 'am' && hour == 12) hour = 0;
    if (hour > 23 || minute > 59 || second > 59) {
      return DateTime(year, month, day);
    }

    return DateTime(year, month, day, hour, minute, second);
  }

  /// Expands a two-digit year (e.g. 26 → 2026); passes four-digit years through.
  int? _normalizeYear(int? y) {
    if (y == null) return null;
    return y < 100 ? 2000 + y : y;
  }

  /// Extracts the last 4 digits of the account number from masked patterns
  /// such as "A/c XX1234", "Acct XX1234", "card ending 1234", or "XXXX1234".
  String? _extractAccountLast4(String text) {
    // "A/c XX1234", "Acct XX1234", "account XX1234"
    final labelMatch = RegExp(
      r'(?:a\/c|acct|account|card\s+ending|card\s+no\.?)\s+[xX*\s]*(\d{4})\b',
      caseSensitive: false,
    ).firstMatch(text);
    if (labelMatch != null) return labelMatch.group(1);

    // Pure masked pattern "XXXX1234" or "**1234"
    final maskMatch = RegExp(r'[xX*]{3,}\s*(\d{4})\b').firstMatch(text);
    return maskMatch?.group(1);
  }

  /// Extracts M-Pesa transaction code (e.g. QGH7YK2L3P).
  String? _extractMpesaCode(String text) {
    final match = RegExp(
      r'([A-Z0-9]{10})\s*Confirmed',
      caseSensitive: false,
    ).firstMatch(text);
    return match?.group(1);
  }

  void _logParseFailed() {
    try {
      _analytics.logSmsParseFailed();
    } catch (e) {
      debugPrint('Analytics log error: $e');
    }
  }

  String? _extractMerchant(String text) {
    String? clean(String raw) {
      var name = raw.trim();
      name = name.replaceAll(
        RegExp(r'\s+(ref|via|on|at|by)\s+.*$', caseSensitive: false),
        '',
      );
      name = name.replaceAll(RegExp(r'\s+[-–(].*$'), '');
      name = name.replaceAll(RegExp(r'[.,;!?]+$'), '');
      name = name.trim();
      return name.length >= 2 ? name : null;
    }

    // Pattern 1: Standard merchant-introducing prepositions + "merchant" keyword.
    final match = RegExp(
      r'(?:to|at|paid to|received from|trf to|transfer to|payment to|for|via UPI at|merchant)\s+([A-Za-z0-9\s&.\-]{3,40})',
      caseSensitive: false,
    ).firstMatch(text);
    if (match != null) {
      final name = clean(match.group(1) ?? '');
      if (name != null) {
        debugPrint('Extracted merchant: "$name"');
        return name;
      }
    }

    // Pattern 2: "at POS at <Merchant>"
    final matchPos = RegExp(
      r'at\s+POS\s+at\s+([A-Za-z0-9\s&.\-]{3,40})',
      caseSensitive: false,
    ).firstMatch(text);
    if (matchPos != null) {
      final name = clean(matchPos.group(1) ?? '');
      if (name != null) {
        debugPrint('Extracted merchant (POS): "$name"');
        return name;
      }
    }

    // Pattern 3: UPI VPA — extract the handle before '@'.
    final vpaMatch = RegExp(
      r'([a-zA-Z0-9._\-]+@[a-zA-Z]{3,10})',
      caseSensitive: false,
    ).firstMatch(text);
    if (vpaMatch != null) {
      final vpa = vpaMatch.group(1)!;
      final name = vpa.split('@')[0];
      if (name.length >= 2) {
        debugPrint('Extracted merchant from VPA: "$name"');
        return name;
      }
    }

    // Pattern 4: "Trf to XXXX" — short transfer notation.
    final trfMatch = RegExp(
      r'(?:trf\s+to|transfer\s+to)\s+([A-Za-z0-9]+)',
      caseSensitive: false,
    ).firstMatch(text);
    if (trfMatch != null) {
      final name = clean(trfMatch.group(1) ?? '');
      if (name != null) {
        debugPrint('Extracted merchant (trf): "$name"');
        return name;
      }
    }

    return null;
  }
}

final smsParserProvider = Provider<SmsParser>((ref) {
  return SmsParser(analytics: ref.watch(analyticsServiceProvider));
});
