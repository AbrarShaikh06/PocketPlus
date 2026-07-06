import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_providers.dart';

/// Auth state wrapper for GoRouter redirects (Frontend Spec 1.1).
class AuthState {
  const AuthState({required this.isAuthenticated});

  final bool isAuthenticated;
}

final authStateProvider = Provider<AuthState>((ref) {
  final user = ref.watch(authStateChangesProvider).asData?.value;
  return AuthState(isAuthenticated: user != null);
});
