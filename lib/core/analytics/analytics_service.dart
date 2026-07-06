import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/firebase_providers.dart';

/// Thin wrapper over Firebase Analytics. All methods are fire-and-forget and
/// never throw — analytics must never break a user flow.
class AnalyticsService {
  AnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> _log(String name, [Map<String, Object?>? params]) async {
    final clean = <String, Object>{};
    params?.forEach((k, v) {
      if (v == null) return;
      clean[k] = v is bool ? v.toString() : v;
    });
    try {
      await _analytics.logEvent(
        name: name,
        parameters: clean.isEmpty ? null : clean,
      );
    } catch (_) {}
  }

  /// Coarse amount bucket (in rupees) so we never log exact transaction values.
  static String getAmountBucket(int amountPaise) {
    final rupees = amountPaise / 100;
    if (rupees < 100) return '0-100';
    if (rupees < 500) return '100-500';
    if (rupees < 1000) return '500-1000';
    if (rupees < 5000) return '1000-5000';
    if (rupees < 10000) return '5000-10000';
    return '10000+';
  }

  Future<void> logTransactionCreated({
    String? source,
    String? type,
    String? categoryId,
    String? profileId,
    String? amountBucket,
  }) =>
      _log('transaction_created', {
        'source': source,
        'type': type,
        'category_id': categoryId,
        'profile_id': profileId,
        'amount_bucket': amountBucket,
      });

  Future<void> logVoiceEntryUsed({
    bool? parsedSuccessfully,
    String? language,
  }) =>
      _log('voice_entry_used', {
        'parsed_successfully': parsedSuccessfully,
        'language': language,
      });

  Future<void> logReceiptScanned({bool? parsedSuccessfully}) =>
      _log('receipt_scanned', {'parsed_successfully': parsedSuccessfully});

  Future<void> logRewardedAdStarted({String? adUnitId, String? context}) =>
      _log('rewarded_ad_started', {'ad_unit_id': adUnitId, 'context': context});

  Future<void> logRewardedAdCompleted({bool? rewardGranted}) =>
      _log('rewarded_ad_completed', {'reward_granted': rewardGranted});

  Future<void> logRewardedAdFailed({String? errorCode, String? fallback}) =>
      _log(
        'rewarded_ad_failed',
        {'error_code': errorCode, 'fallback': fallback},
      );

  Future<void> logInvoiceShared() => _log('invoice_shared');

  Future<void> logInvoiceCreated({bool? hasGst, String? planAtCreation}) =>
      _log(
        'invoice_created',
        {'has_gst': hasGst, 'plan_at_creation': planAtCreation},
      );

  Future<void> logPdfExportAttempted({String? plan, num? quotaRemaining}) =>
      _log(
        'pdf_export_attempted',
        {'plan': plan, 'quota_remaining': quotaRemaining},
      );

  Future<void> logWhatsappSupportTapped() => _log('whatsapp_support_tapped');

  Future<void> logFeedbackSubmitted({
    String? type,
    num? rating,
    num? npsScore,
  }) =>
      _log(
        'feedback_submitted',
        {'type': type, 'rating': rating, 'nps_score': npsScore},
      );

  Future<void> logSmsPermissionGranted() => _log('sms_permission_granted');

  Future<void> logSmsPermissionDenied() => _log('sms_permission_denied');

  Future<void> logUpgradeCTATapped({
    String? trigger,
    String? targetPlan,
    String? currentPlan,
  }) =>
      _log('upgrade_cta_tapped', {
        'trigger': trigger,
        'target_plan': targetPlan,
        'current_plan': currentPlan,
      });

  Future<void> logUpgradePromptShown({
    String? trigger,
    String? featureName,
    String? currentPlan,
  }) =>
      _log('upgrade_prompt_shown', {
        'trigger': trigger,
        'feature_name': featureName,
        'current_plan': currentPlan,
      });

  Future<void> logSubscriptionStarted({
    String? plan,
    String? price,
    bool? isUpgrade,
  }) =>
      _log(
        'subscription_started',
        {'plan': plan, 'price': price, 'is_upgrade': isUpgrade},
      );

  Future<void> logSmsParseFailed() => _log('sms_parse_failed');

  Future<void> logSmsDuplicateSkipped() => _log('sms_duplicate_skipped');

  Future<void> logAppRated({String? trigger}) =>
      _log('app_rated', {'trigger': trigger});

  Future<void> logSmsCaptureConfirmed({
    String? bank,
    String? category,
    num? timeToConfirmMs,
  }) =>
      _log('sms_capture_confirmed', {
        'bank': bank,
        'category': category,
        'time_to_confirm_ms': timeToConfirmMs,
      });

  Future<void> logSmsCaptureDismissed({String? bank}) =>
      _log('sms_capture_dismissed', {'bank': bank});

  Future<void> logSmsAutoCaptured({String? bank, bool? parsedSuccessfully}) =>
      _log(
        'sms_auto_captured',
        {'bank': bank, 'parsed_successfully': parsedSuccessfully},
      );

  Future<void> logKhataReminderSent({num? balanceInPaise}) =>
      _log('khata_reminder_sent', {'balance_in_paise': balanceInPaise});

  Future<void> logKhataCustomerAdded() => _log('khata_customer_added');

  Future<void> logTutorialSkipped({num? stepNumber, String? role}) =>
      _log('tutorial_skipped', {'step_number': stepNumber, 'role': role});

  Future<void> logTutorialCompleted({String? role, num? stepsViewed}) =>
      _log('tutorial_completed', {'role': role, 'steps_viewed': stepsViewed});

  Future<void> logTutorialStepViewed({
    num? stepNumber,
    String? screenName,
    String? role,
  }) =>
      _log('tutorial_step_viewed', {
        'step_number': stepNumber,
        'screen_name': screenName,
        'role': role,
      });
}

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(ref.watch(firebaseAnalyticsProvider));
});
