import 'package:pocket_plus/core/analytics/analytics_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pocket_plus/main.dart';
import 'package:pocket_plus/shared/providers/firebase_providers.dart';
import 'package:pocket_plus/features/sms_capture/data/sms_permission_service.dart';
import 'package:pocket_plus/features/sms_capture/domain/use_cases/process_sms_use_case.dart';
import 'package:pocket_plus/features/sms_capture/domain/services/capture_notification_service.dart';
import 'package:pocket_plus/features/sms_capture/domain/entities/parsed_sms.dart';
import 'package:pocket_plus/features/sms_capture/data/sms_platform_channel.dart';
import 'package:pocket_plus/features/sms_capture/data/firestore_sms_dedup_data_source.dart';
import 'package:pocket_plus/features/sms_capture/data/bank_pattern_matcher.dart';
import 'package:pocket_plus/features/sms_capture/data/financial_sms_detector.dart';
import 'package:pocket_plus/features/sms_capture/data/sms_parser.dart';
import 'package:pocket_plus/shared/widgets/pocketplus_loader.dart';
import 'package:go_router/go_router.dart';

class FakeSmsPermissionService implements SmsPermissionService {
  @override
  Future<PermissionStatus> requestPermission() async => PermissionStatus.denied;
  @override
  Future<bool> isGranted() async => false;
  @override
  Future<PermissionStatus> status() async => PermissionStatus.denied;
  @override
  Future<bool> openSettings() async => true;
}

class FakeSmsDedupRepository implements SmsDedupRepository {
  final Set<String> _claimed = {};

  @override
  Future<bool> checkDuplicate(String userId, String smsHash) async => false;

  @override
  Future<bool> claim(String userId, String smsHash) async {
    if (_claimed.contains(smsHash)) return false;
    _claimed.add(smsHash);
    return true;
  }

  @override
  Future<void> writeDedupLog(
    String userId,
    String smsHash,
    DedupAction action,
    String? transactionId,
  ) async {}
}

class FakeProcessSmsUseCase extends ProcessSmsUseCase {
  FakeProcessSmsUseCase()
      : super(
          patternMatcher: BankPatternMatcher(),
          detector: FinancialSmsDetector(),
          parser: SmsParser(analytics: FakeAnalyticsService()),
          dedupRepository: FakeSmsDedupRepository(),
          analytics: FakeAnalyticsService(),
        );

  @override
  Future<ParsedSms?> execute(RawSms rawSms, String userId) async => null;
}

class FakeCaptureNotificationService implements CaptureNotificationService {
  @override
  void setRouter(GoRouter router) {}

  @override
  void triggerNotification(ParsedSms parsedSms) {}

  @override
  void navigateToConfirmation(ParsedSms parsedSms) {}
}

class FakeAnalyticsService extends Fake implements AnalyticsService {}

void main() {
  testWidgets('PocketPlus app renders splash screen then redirects to login',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateChangesProvider.overrideWith((ref) => Stream.value(null)),
          smsPermissionServiceProvider
              .overrideWithValue(FakeSmsPermissionService()),
          processSmsUseCaseProvider.overrideWithValue(FakeProcessSmsUseCase()),
          captureNotificationServiceProvider
              .overrideWithValue(FakeCaptureNotificationService()),
          analyticsServiceProvider.overrideWithValue(FakeAnalyticsService()),
        ],
        child: const PocketPlusApp(),
      ),
    );

    // Verify initial splash screen is shown (branded PocketPlus loader).
    expect(find.byType(PocketPlusLoader), findsOneWidget);

    // Fast-forward time for splash delay (2 seconds)
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify it has redirected to the login screen
    expect(find.text('Track your business income & expenses'), findsOneWidget);
  });
}
