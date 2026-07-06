import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/error_codes.dart';
import '../../../shared/providers/firebase_providers.dart';
import '../data/auth_repository_impl.dart';
import '../data/firebase_auth_data_source.dart';
import '../domain/auth_repository.dart';

final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSourceImpl(ref.watch(firebaseAuthProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(firebaseAuthDataSourceProvider),
    ref.watch(firestoreProvider),
  );
});

class AuthState {
  const AuthState({
    this.isLoading = false,
    this.errorCode,
  });

  final bool isLoading;
  final String? errorCode;

  AuthState copyWith({
    bool? isLoading,
    String? errorCode,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }
}

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  bool isValidEmail(String email) {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(trimmed);
  }

  bool isValidUsername(String username) {
    if (username.length < 3 || username.length > 30) return false;
    return RegExp(r'^[a-zA-Z][a-zA-Z0-9_.]*$').hasMatch(username);
  }

  bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!RegExp(r'[A-Z]').hasMatch(password)) return false;
    if (!RegExp(r'[a-z]').hasMatch(password)) return false;
    if (!RegExp(r'[0-9]').hasMatch(password)) return false;
    return true;
  }

  Future<String?> checkUsernameAvailability(String username) async {
    if (!isValidUsername(username)) return null;
    try {
      final query = await ref
          .read(firestoreProvider)
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      return query.docs.isEmpty ? null : ErrorCodes.usernameTaken;
    } catch (_) {
      return null;
    }
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.signUp(
      username: username.trim(),
      email: email.trim(),
      password: password,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorCode: failure.message,
        );
      },
      (_) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  Future<void> signInWithUsername({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.signInWithUsername(
      username: username.trim(),
      password: password,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorCode: failure.message,
        );
      },
      (_) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.signInWithGoogle();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorCode: failure.message,
        );
      },
      (_) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  Future<String?> sendPasswordResetEmail(String username) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.sendPasswordResetEmail(username.trim());

    return result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorCode: failure.message,
        );
        return failure.message;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        return null;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _repository.signOut();
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorCode: failure.message,
        );
      },
      (_) {
        state = state.copyWith(isLoading: false);
      },
    );
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final authViewModelProvider =
    NotifierProvider<AuthViewModel, AuthState>(AuthViewModel.new);
