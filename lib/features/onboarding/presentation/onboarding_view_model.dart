import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/error_codes.dart';
import '../../../shared/models/supported_region.dart';
import '../../../shared/providers/firebase_providers.dart';
import '../data/onboarding_repository_impl.dart';
import '../domain/onboarding_repository.dart';

// Providers
final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepositoryImpl(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  );
});

// State definition
class OnboardingState {
  const OnboardingState({
    this.role,
    this.businessName = '',
    this.userName = '',
    this.phone = '',
    this.region = '',
    this.currencyCode = 'INR',
    this.age,
    this.smsPermissionGranted = false,
    this.isLoading = false,
    this.errorCode,
    this.onboardingCompleted = false,
  });

  final String? role;
  final String businessName;
  final String userName;
  final String phone;
  final String region;
  final String currencyCode;
  final int? age;
  final bool smsPermissionGranted;
  final bool isLoading;
  final String? errorCode;
  final bool onboardingCompleted;

  OnboardingState copyWith({
    String? role,
    String? businessName,
    String? userName,
    String? phone,
    String? region,
    String? currencyCode,
    int? age,
    bool? smsPermissionGranted,
    bool? isLoading,
    String? errorCode,
    bool? onboardingCompleted,
    bool clearError = false,
  }) {
    return OnboardingState(
      role: role ?? this.role,
      businessName: businessName ?? this.businessName,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      region: region ?? this.region,
      currencyCode: currencyCode ?? this.currencyCode,
      age: age ?? this.age,
      smsPermissionGranted: smsPermissionGranted ?? this.smsPermissionGranted,
      isLoading: isLoading ?? this.isLoading,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}

// ViewModel implementation
class OnboardingViewModel extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  OnboardingRepository get _repository =>
      ref.read(onboardingRepositoryProvider);

  void selectRole(String role) {
    state = state.copyWith(
      role: role,
      clearError: true,
    );
  }

  void updateBusinessName(String name) {
    state = state.copyWith(
      businessName: name,
      clearError: true,
    );
  }

  void updateUserName(String name) {
    state = state.copyWith(
      userName: name,
      clearError: true,
    );
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone);
  }

  void updateRegion(String region) {
    state = state.copyWith(region: region);
  }

  /// Selects one of the officially supported regions. Stores both the display
  /// name and the currency code, which drives the user's currency and the
  /// prices shown in the Pro section.
  void selectRegion(SupportedRegion region) {
    state = state.copyWith(
      region: region.displayName,
      currencyCode: region.currencyCode,
    );
  }

  void updateAge(int? age) {
    state = state.copyWith(age: age);
  }

  void setSmsPermission(bool granted) {
    state = state.copyWith(
      smsPermissionGranted: granted,
    );
  }

  bool isNameValid() {
    final length = state.businessName.trim().length;
    return length >= 2 && length <= 200;
  }

  bool isUserInfoValid() {
    final name = state.userName.trim();
    if (name.isEmpty || name.length < 2) return false;
    if (state.phone.isNotEmpty && state.phone.length < 10) return false;
    return true;
  }

  Future<bool> completeOnboarding() async {
    if (state.role == null) {
      state = state.copyWith(errorCode: ErrorCodes.selectRole);
      return false;
    }

    if ((state.role == 'BUSINESS' || state.role == 'CA') && !isNameValid()) {
      state = state.copyWith(
        errorCode: ErrorCodes.businessNameLength,
      );
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    final displayName = state.role == 'PERSONAL'
        ? state.userName.trim()
        : state.businessName.trim();

    // Save onboarding data to Firestore
    final result = await _repository.saveOnboardingData(
      role: state.role!,
      businessName: (state.role == 'BUSINESS' || state.role == 'CA')
          ? state.businessName.trim()
          : null,
      displayName: displayName,
      phone: state.phone.trim(),
      region: state.region.trim(),
      currencyCode: state.currencyCode,
      age: state.age,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorCode: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          onboardingCompleted: true,
        );
        return true;
      },
    );
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final onboardingViewModelProvider =
    NotifierProvider<OnboardingViewModel, OnboardingState>(
  OnboardingViewModel.new,
);
