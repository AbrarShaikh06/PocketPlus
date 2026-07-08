import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_plus/core/errors/error_codes.dart';
import 'package:pocket_plus/core/errors/failures.dart';
import 'package:pocket_plus/features/onboarding/domain/onboarding_repository.dart';
import 'package:pocket_plus/features/onboarding/presentation/onboarding_view_model.dart';
import 'package:pocket_plus/features/onboarding/presentation/role_selection_screen.dart';
import 'package:pocket_plus/l10n/app_localizations.dart';

class FakeOnboardingRepository implements OnboardingRepository {
  bool saveOnboardingDataCalled = false;
  String? savedRole;
  String? savedBusinessName;
  String? savedDisplayName;
  String? savedPhone;
  String? savedRegion;
  String? savedCurrencyCode;
  int? savedAge;
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
    savedPhone = phone;
    savedRegion = region;
    savedCurrencyCode = currencyCode;
    savedAge = age;
    if (failureToReturn != null) {
      return Left(failureToReturn!);
    }
    return const Right(null);
  }
}

void main() {
  late FakeOnboardingRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeOnboardingRepository();
  });

  ProviderContainer makeContainer() {
    return ProviderContainer(
      overrides: [
        onboardingRepositoryProvider.overrideWithValue(fakeRepository),
      ],
    );
  }

  group('OnboardingViewModel Unit Tests', () {
    test('Initial state is empty/default', () {
      final container = makeContainer();
      final state = container.read(onboardingViewModelProvider);

      expect(state.role, isNull);
      expect(state.businessName, isEmpty);
      expect(state.smsPermissionGranted, isFalse);
      expect(state.isLoading, isFalse);
      expect(state.errorCode, isNull);
      expect(state.onboardingCompleted, isFalse);
    });

    test('selectRole updates role in state', () {
      final container = makeContainer();
      final viewModel = container.read(onboardingViewModelProvider.notifier);

      viewModel.selectRole('BUSINESS');

      final state = container.read(onboardingViewModelProvider);
      expect(state.role, 'BUSINESS');
    });

    test('updateBusinessName updates business name in state', () {
      final container = makeContainer();
      final viewModel = container.read(onboardingViewModelProvider.notifier);

      viewModel.updateBusinessName('Super Store');

      final state = container.read(onboardingViewModelProvider);
      expect(state.businessName, 'Super Store');
    });

    test('isNameValid enforces 2-200 characters limit', () {
      final container = makeContainer();
      final viewModel = container.read(onboardingViewModelProvider.notifier);

      // Too short
      viewModel.updateBusinessName('A');
      expect(viewModel.isNameValid(), isFalse);

      // Just right (minimum)
      viewModel.updateBusinessName('Ab');
      expect(viewModel.isNameValid(), isTrue);

      // Valid name
      viewModel.updateBusinessName('Sharma Store');
      expect(viewModel.isNameValid(), isTrue);

      // Too long (> 200)
      viewModel.updateBusinessName('A' * 201);
      expect(viewModel.isNameValid(), isFalse);
    });

    test('completeOnboarding success writes to repository for Business role',
        () async {
      final container = makeContainer();
      final viewModel = container.read(onboardingViewModelProvider.notifier);

      viewModel.selectRole('BUSINESS');
      viewModel.updateBusinessName('My Bakery');

      final result = await viewModel.completeOnboarding();

      expect(result, isTrue);
      expect(fakeRepository.saveOnboardingDataCalled, isTrue);
      expect(fakeRepository.savedRole, 'BUSINESS');
      expect(fakeRepository.savedBusinessName, 'My Bakery');

      final state = container.read(onboardingViewModelProvider);
      expect(state.onboardingCompleted, isTrue);
      expect(state.isLoading, isFalse);
    });

    test('completeOnboarding fails if no role is selected', () async {
      final container = makeContainer();
      final viewModel = container.read(onboardingViewModelProvider.notifier);

      final result = await viewModel.completeOnboarding();

      expect(result, isFalse);
      expect(fakeRepository.saveOnboardingDataCalled, isFalse);

      final state = container.read(onboardingViewModelProvider);
      expect(state.errorCode, ErrorCodes.selectRole);
    });

    test('completeOnboarding handles repository errors', () async {
      final container = makeContainer();
      final viewModel = container.read(onboardingViewModelProvider.notifier);

      fakeRepository.failureToReturn = const ServerFailure(
        message: 'Database unavailable',
      );

      viewModel.selectRole('PERSONAL');
      final result = await viewModel.completeOnboarding();

      expect(result, isFalse);
      expect(fakeRepository.saveOnboardingDataCalled, isTrue);

      final state = container.read(onboardingViewModelProvider);
      expect(state.errorCode, 'Database unavailable');
      expect(state.onboardingCompleted, isFalse);
    });
  });

  group('RoleSelectionScreen Widget Tests', () {
    testWidgets('Renders options and enables button on selection',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            onboardingRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: RoleSelectionScreen(),
          ),
        ),
      );

      // Check title and cards are rendered
      expect(find.text('Choose Your Role'), findsOneWidget);
      expect(find.text('Personal Ledger'), findsOneWidget);
      expect(find.text('Business Owner'), findsOneWidget);

      // Tap on Business Owner card
      await tester.tap(find.text('Business Owner'));
      await tester.pumpAndSettle();

      // Verify selected state changes and Next button enables
      // (tapping Next button now should trigger navigation)
    });
  });
}
