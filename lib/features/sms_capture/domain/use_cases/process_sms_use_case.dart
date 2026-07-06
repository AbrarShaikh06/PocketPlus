import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/bank_pattern_matcher.dart';
import '../../data/financial_sms_detector.dart';
import '../../data/firestore_sms_dedup_data_source.dart';
import '../../data/sms_dedup_repository.dart';
import '../../data/sms_parser.dart';
import '../../data/sms_platform_channel.dart';
import '../entities/parsed_sms.dart';
import '../../../../core/analytics/analytics_service.dart';

class ProcessSmsUseCase {
  final FinancialSmsDetector _detector;
  final BankPatternMatcher _patternMatcher;
  final SmsParser _parser;
  final SmsDedupRepository _dedupRepository;
  final AnalyticsService _analytics;

  ProcessSmsUseCase({
    required FinancialSmsDetector detector,
    required BankPatternMatcher patternMatcher,
    required SmsParser parser,
    required SmsDedupRepository dedupRepository,
    required AnalyticsService analytics,
  })  : _detector = detector,
        _patternMatcher = patternMatcher,
        _parser = parser,
        _dedupRepository = dedupRepository,
        _analytics = analytics;

  Future<ParsedSms?> execute(RawSms rawSms, String userId) async {
    debugPrint('[ProcessSmsUseCase] Processing SMS from ${rawSms.senderId}');

    // 1. Known sender → +2 confidence boost. Unknown sender → 0.
    //    Sender ID is NEVER used as a hard gatekeeper. It only adjusts the score.
    final isKnownSender = _patternMatcher.isKnownBankSender(rawSms.senderId);
    final senderBoost = isKnownSender ? 2.0 : 0.0;

    if (isKnownSender) {
      debugPrint(
        '[ProcessSmsUseCase] Known sender: ${rawSms.senderId} '
        '(confidence boost: +${senderBoost.toStringAsFixed(0)})',
      );
    } else {
      debugPrint(
        '[ProcessSmsUseCase] Unknown sender: ${rawSms.senderId} — '
        'running financial heuristic',
      );
    }

    // 2. Score SMS content. Sender boost is folded in here.
    final detection = _detector.detect(rawSms.text, senderBoost: senderBoost);

    if (!detection.isFinancial) {
      debugPrint(
        '[ProcessSmsUseCase] Rejected: score ${detection.confidence} '
        'is below threshold. Signals: ${detection.matchedSignals}',
      );
      return null;
    }

    if (!isKnownSender) {
      debugPrint(
        '[ProcessSmsUseCase] Unknown sender ${rawSms.senderId} accepted '
        'via financial heuristic (score: ${detection.confidence})',
      );
    }

    // 3. Parse — extracts amount, type, merchant, account suffix, etc.
    //    The SMS's received timestamp (when known) is the parser's fallback
    //    transaction time, used when the body has no embedded date/time.
    debugPrint('[ProcessSmsUseCase] Parsing SMS text: ${rawSms.text}');
    final smsReceivedAt = rawSms.timestampMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(rawSms.timestampMillis!)
        : null;
    final parsedSms =
        _parser.parse(rawSms.text, rawSms.senderId, now: smsReceivedAt);
    if (parsedSms == null) {
      debugPrint(
        '[ProcessSmsUseCase] Parser returned null — could not extract transaction',
      );
      return null;
    }
    debugPrint(
      '[ProcessSmsUseCase] Parsed: amount=${parsedSms.amount}paise, '
      'type=${parsedSms.type}, merchant=${parsedSms.merchantName}',
    );

    // 4. Atomic dedup claim — atomically read + write the dedup log so that
    //    concurrent paths (real-time stream + historical scan) can't both pass.
    debugPrint('[ProcessSmsUseCase] Claiming hash: ${parsedSms.smsHash}');
    final claimed = await _dedupRepository.claim(userId, parsedSms.smsHash);
    if (!claimed) {
      debugPrint('[ProcessSmsUseCase] Duplicate SMS detected, skipping');
      try {
        await _analytics.logSmsDuplicateSkipped();
      } catch (_) {}
      return null;
    }
    debugPrint('[ProcessSmsUseCase] Transaction parsed successfully');
    return parsedSms;
  }
}

final processSmsUseCaseProvider = Provider<ProcessSmsUseCase>((ref) {
  return ProcessSmsUseCase(
    detector: ref.watch(financialSmsDetectorProvider),
    patternMatcher: ref.watch(bankPatternMatcherProvider),
    parser: ref.watch(smsParserProvider),
    dedupRepository: ref.watch(smsDedupRepositoryProvider),
    analytics: ref.watch(analyticsServiceProvider),
  );
});
