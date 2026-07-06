import 'package:dartz/dartz.dart';
import 'package:pocket_plus/core/analytics/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pocket_plus/core/errors/failures.dart';
import 'package:pocket_plus/features/onboarding/domain/onboarding_repository.dart';
import 'package:pocket_plus/features/onboarding/presentation/onboarding_view_model.dart';
import 'package:pocket_plus/features/onboarding/presentation/sms_permission_screen.dart';
import 'package:pocket_plus/features/sms_capture/data/sms_permission_service.dart';
import 'package:pocket_plus/features/sms_capture/data/sms_capture_service.dart';
import 'package:pocket_plus/features/sms_capture/data/bank_pattern_matcher.dart';
import 'package:pocket_plus/features/sms_capture/data/financial_sms_detector.dart';
import 'package:pocket_plus/features/sms_capture/data/sms_parser.dart';
import 'package:pocket_plus/features/sms_capture/data/firestore_sms_dedup_data_source.dart';
import 'package:pocket_plus/features/sms_capture/data/sms_platform_channel.dart';
import 'package:pocket_plus/features/sms_capture/domain/use_cases/process_sms_use_case.dart';
import 'package:pocket_plus/features/sms_capture/domain/entities/parsed_sms.dart';
import 'package:pocket_plus/features/sms_capture/domain/services/capture_notification_service.dart';
import 'package:pocket_plus/features/profiles/domain/entities/profile.dart';
import 'package:pocket_plus/shared/models/profile_type.dart';
import 'package:pocket_plus/shared/providers/firebase_providers.dart';
import 'package:pocket_plus/features/home/presentation/home_providers.dart';

class FakeOnboardingRepository implements OnboardingRepository {
  bool saveOnboardingDataCalled = false;
  String? savedRole;
  String? savedBusinessName;
  String? savedDisplayName;
  Failure? failureToReturn;

  @override
  Future<Either<Failure, void>> saveOnboardingData({
    required String role,
    String? businessName,
    String? displayName,
    String? phone,
    String? region,
    String? currencyCode,
    int? age,
  }) async {
    saveOnboardingDataCalled = true;
    savedRole = role;
    savedBusinessName = businessName;
    savedDisplayName = displayName;
    if (failureToReturn != null) {
      return Left(failureToReturn!);
    }
    return const Right(null);
  }
}

class FakeSmsPermissionService implements SmsPermissionService {
  PermissionStatus statusToReturn = PermissionStatus.denied;
  bool isGrantedCalled = false;
  bool requestPermissionCalled = false;
  bool openSettingsCalled = false;

  @override
  Future<PermissionStatus> requestPermission() async {
    requestPermissionCalled = true;
    return statusToReturn;
  }

  @override
  Future<bool> isGranted() async {
    isGrantedCalled = true;
    return statusToReturn.isGranted;
  }

  @override
  Future<PermissionStatus> status() async {
    return statusToReturn;
  }

  @override
  Future<bool> openSettings() async {
    openSettingsCalled = true;
    return true;
  }
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
  bool executeCalled = false;
  RawSms? lastRawSms;
  String? lastUserId;
  ParsedSms? parsedSmsToReturn;

  FakeProcessSmsUseCase()
      : super(
          detector: FinancialSmsDetector(),
          patternMatcher: BankPatternMatcher(),
          parser: SmsParser(analytics: FakeAnalyticsService()),
          dedupRepository: FakeSmsDedupRepository(),
          analytics: FakeAnalyticsService(),
        );

  @override
  Future<ParsedSms?> execute(RawSms rawSms, String userId) async {
    executeCalled = true;
    lastRawSms = rawSms;
    lastUserId = userId;
    return parsedSmsToReturn;
  }
}

class FakeCaptureNotificationService implements CaptureNotificationService {
  bool triggerNotificationCalled = false;
  ParsedSms? lastParsedSms;

  @override
  void triggerNotification(ParsedSms parsedSms) {
    triggerNotificationCalled = true;
    lastParsedSms = parsedSms;
  }

  @override
  void navigateToConfirmation(ParsedSms parsedSms) {}

  @override
  void setRouter(GoRouter router) {}
}

class FakeAnalyticsService extends Fake implements AnalyticsService {
  final List<String> loggedEvents = [];

  @override
  Future<void> logSmsPermissionGranted() async {
    loggedEvents.add('sms_permission_granted');
  }

  @override
  Future<void> logSmsPermissionDenied() async {
    loggedEvents.add('sms_permission_denied');
  }
}

const testProfile = Profile(
  id: 'profile_123',
  userId: 'user_123',
  name: 'Test Profile',
  type: ProfileType.personal,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeOnboardingRepository fakeOnboardingRepository;
  late FakeSmsPermissionService fakeSmsPermissionService;
  late FakeProcessSmsUseCase fakeProcessSmsUseCase;
  late FakeCaptureNotificationService fakeCaptureNotificationService;
  late FakeAnalyticsService fakeFirebaseAnalytics;

  setUp(() {
    fakeOnboardingRepository = FakeOnboardingRepository();
    fakeSmsPermissionService = FakeSmsPermissionService();
    fakeProcessSmsUseCase = FakeProcessSmsUseCase();
    fakeCaptureNotificationService = FakeCaptureNotificationService();
    fakeFirebaseAnalytics = FakeAnalyticsService();
  });

  Widget buildTestWidget({
    required GoRouter router,
  }) {
    return ProviderScope(
      overrides: [
        onboardingRepositoryProvider
            .overrideWithValue(fakeOnboardingRepository),
        smsPermissionServiceProvider
            .overrideWithValue(fakeSmsPermissionService),
        processSmsUseCaseProvider.overrideWithValue(fakeProcessSmsUseCase),
        captureNotificationServiceProvider
            .overrideWithValue(fakeCaptureNotificationService),
        analyticsServiceProvider.overrideWithValue(fakeFirebaseAnalytics),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  group('SMS Permission & Capture Integration Tests', () {
    testWidgets('Permission Grant Flow completes onboarding & fires analytics',
        (tester) async {
      fakeSmsPermissionService.statusToReturn = PermissionStatus.granted;

      final router = GoRouter(
        initialLocation: '/onboarding/sms',
        routes: [
          GoRoute(
            path: '/onboarding/sms',
            builder: (context, state) => const SmsPermissionScreen(),
          ),
          GoRoute(
            path: '/onboarding/done',
            builder: (context, state) => const Text('Onboarding Done Screen'),
          ),
        ],
      );

      await tester.pumpWidget(buildTestWidget(router: router));
      await tester.pumpAndSettle();

      // Set standard role to bypass onboarding validation
      final container = ProviderScope.containerOf(
        tester.element(find.byType(SmsPermissionScreen)),
      );
      container
          .read(onboardingViewModelProvider.notifier)
          .selectRole('PERSONAL');

      // Verify Screen rendering
      expect(find.text('Auto-Capture Income'), findsOneWidget);
      expect(find.text('Allow SMS'), findsOneWidget);

      // Tap Allow SMS
      await tester.tap(find.text('Allow SMS'));
      await tester.pumpAndSettle();

      // Verify permission service request was called
      expect(fakeSmsPermissionService.requestPermissionCalled, isTrue);

      // Verify onboarding repository was called to save data
      expect(fakeOnboardingRepository.saveOnboardingDataCalled, isTrue);

      // Verify analytics log
      expect(fakeFirebaseAnalytics.loggedEvents.length, 1);
      expect(fakeFirebaseAnalytics.loggedEvents[0], 'sms_permission_granted');

      // Verify redirection to onboarding done screen
      expect(find.text('Onboarding Done Screen'), findsOneWidget);
    });

    testWidgets('Permission Deny Flow completes onboarding & fires analytics',
        (tester) async {
      fakeSmsPermissionService.statusToReturn = PermissionStatus.denied;

      final router = GoRouter(
        initialLocation: '/onboarding/sms',
        routes: [
          GoRoute(
            path: '/onboarding/sms',
            builder: (context, state) => const SmsPermissionScreen(),
          ),
          GoRoute(
            path: '/onboarding/done',
            builder: (context, state) => const Text('Onboarding Done Screen'),
          ),
        ],
      );

      await tester.pumpWidget(buildTestWidget(router: router));
      await tester.pumpAndSettle();

      // Set standard role to bypass onboarding validation
      final container = ProviderScope.containerOf(
        tester.element(find.byType(SmsPermissionScreen)),
      );
      container
          .read(onboardingViewModelProvider.notifier)
          .selectRole('PERSONAL');

      // Tap Allow SMS
      await tester.tap(find.text('Allow SMS'));
      await tester.pumpAndSettle();

      // Verify permission service request was called
      expect(fakeSmsPermissionService.requestPermissionCalled, isTrue);

      // Verify onboarding repository was called to save data
      expect(fakeOnboardingRepository.saveOnboardingDataCalled, isTrue);

      // Verify analytics log
      expect(fakeFirebaseAnalytics.loggedEvents.length, 1);
      expect(fakeFirebaseAnalytics.loggedEvents[0], 'sms_permission_denied');

      // Verify redirection to onboarding done screen
      expect(find.text('Onboarding Done Screen'), findsOneWidget);
    });

    testWidgets('Permission Permanently Denied shows settings button',
        (tester) async {
      fakeSmsPermissionService.statusToReturn =
          PermissionStatus.permanentlyDenied;

      final router = GoRouter(
        initialLocation: '/onboarding/sms',
        routes: [
          GoRoute(
            path: '/onboarding/sms',
            builder: (context, state) => const SmsPermissionScreen(),
          ),
        ],
      );

      await tester.pumpWidget(buildTestWidget(router: router));
      await tester.pumpAndSettle();

      // Pump to trigger build checks and async state update
      await tester.pump();

      // Expect Settings button instead of Allow SMS button
      expect(find.text('Enable in Settings'), findsOneWidget);
      expect(find.text('Allow SMS'), findsNothing);

      // Tap Enable in Settings
      await tester.tap(find.text('Enable in Settings'));
      await tester.pumpAndSettle();

      expect(fakeSmsPermissionService.openSettingsCalled, isTrue);
    });

    testWidgets('Platform Channel receives raw SMS & capture service matches',
        (tester) async {
      fakeSmsPermissionService.statusToReturn = PermissionStatus.granted;

      final container = ProviderContainer(
        overrides: [
          smsPermissionServiceProvider
              .overrideWithValue(fakeSmsPermissionService),
          processSmsUseCaseProvider.overrideWithValue(fakeProcessSmsUseCase),
          captureNotificationServiceProvider
              .overrideWithValue(fakeCaptureNotificationService),
          currentProfileProvider.overrideWithValue(testProfile),
          authStateChangesProvider.overrideWith((ref) => const Stream.empty()),
        ],
      );
      addTearDown(container.dispose);

      // Initialize the capture service
      container.read(smsCaptureServiceProvider);

      // Send standard mock SMS method call
      final binaryMessenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      const codec = StandardMethodCodec();
      final message = codec.encodeMethodCall(
        const MethodCall('onSmsReceived', {
          'text': 'Dear Customer, A/c X1234 credited with Rs.100.00. - Bank',
          'senderId': 'BANK-SMS',
        }),
      );

      await binaryMessenger.handlePlatformMessage(
        'pocketplus/sms',
        message,
        (data) {},
      );

      // Pump event loop to allow stream listener to handle message
      await tester.pump(Duration.zero);

      // Verify check permission was called
      expect(fakeSmsPermissionService.isGrantedCalled, isTrue);

      // Verify ProcessSmsUseCase was called with correct data
      expect(fakeProcessSmsUseCase.executeCalled, isTrue);
      expect(
        fakeProcessSmsUseCase.lastRawSms!.text,
        'Dear Customer, A/c X1234 credited with Rs.100.00. - Bank',
      );
      expect(fakeProcessSmsUseCase.lastRawSms!.senderId, 'BANK-SMS');
      expect(fakeProcessSmsUseCase.lastUserId, 'user_123');
    });

    testWidgets(
        'Platform Channel handles corrupted or missing map values safely',
        (tester) async {
      fakeSmsPermissionService.statusToReturn = PermissionStatus.granted;

      final container = ProviderContainer(
        overrides: [
          smsPermissionServiceProvider
              .overrideWithValue(fakeSmsPermissionService),
          processSmsUseCaseProvider.overrideWithValue(fakeProcessSmsUseCase),
          captureNotificationServiceProvider
              .overrideWithValue(fakeCaptureNotificationService),
          currentProfileProvider.overrideWithValue(testProfile),
          authStateChangesProvider.overrideWith((ref) => const Stream.empty()),
        ],
      );
      addTearDown(container.dispose);

      container.read(smsCaptureServiceProvider);

      final binaryMessenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      const codec = StandardMethodCodec();

      // Send invalid data structure (not a Map)
      var message = codec
          .encodeMethodCall(const MethodCall('onSmsReceived', 'Not a map'));
      await binaryMessenger.handlePlatformMessage(
        'pocketplus/sms',
        message,
        (data) {},
      );
      await tester.pump(Duration.zero);

      // Send Map with missing text
      message = codec.encodeMethodCall(
        const MethodCall('onSmsReceived', {
          'senderId': 'BANK-SMS',
        }),
      );
      await binaryMessenger.handlePlatformMessage(
        'pocketplus/sms',
        message,
        (data) {},
      );
      await tester.pump(Duration.zero);

      // Send Map with missing senderId
      message = codec.encodeMethodCall(
        const MethodCall('onSmsReceived', {
          'text': 'Dear Customer...',
        }),
      );
      await binaryMessenger.handlePlatformMessage(
        'pocketplus/sms',
        message,
        (data) {},
      );
      await tester.pump(Duration.zero);

      // Verify ProcessSmsUseCase was never called (silent drop of invalid/corrupt packets)
      expect(fakeProcessSmsUseCase.executeCalled, isFalse);
    });
  });
}
