import 'package:firebase_auth/firebase_auth.dart';

import 'app_exception.dart';
import 'failures.dart';

abstract final class ErrorMapper {
  static Failure fromException(Object error) {
    if (error is Failure) return error;

    if (error is AppException) {
      return _fromAppException(error);
    }

    if (error is FirebaseAuthException) {
      return _fromFirebaseAuth(error);
    }

    if (error is FirebaseException) {
      return _fromFirebaseException(error);
    }

    return const ServerFailure();
  }

  static Failure _fromAppException(AppException e) {
    switch (e.code) {
      case 'VALIDATION_ERROR':
        return ValidationFailure(message: e.message, field: '');
      case 'CONFLICT':
        return ConflictFailure(message: e.message);
      case 'PLAN_LIMIT_EXCEEDED':
        return PlanLimitFailure(message: e.message);
      case 'UNAUTHENTICATED':
        return AuthFailure(message: e.message);
      case 'NETWORK_ERROR':
        return NetworkFailure(message: e.message);
      default:
        return ServerFailure(message: e.message);
    }
  }

  static Failure _fromFirebaseException(FirebaseException e) {
    if (e.code == 'unavailable' || e.code == 'network-error') {
      return const NetworkFailure();
    }
    return ServerFailure(message: e.message ?? 'Something went wrong.');
  }

  static Failure _fromFirebaseAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'too-many-requests':
        return const AuthFailure(
          message: 'Too many attempts. Please try again later.',
          code: 'RATE_LIMITED',
        );
      case 'email-already-in-use':
        return const ConflictFailure(
          message: 'An account with this email already exists.',
        );
      case 'invalid-email':
        return const ValidationFailure(
          message: 'Invalid email address.',
          field: 'email',
        );
      case 'weak-password':
        return const ValidationFailure(
          message:
              'Password must be at least 8 characters with uppercase, lowercase, and a number.',
          field: 'password',
        );
      case 'wrong-password':
        return const AuthFailure(
          message: 'Incorrect password.',
          code: 'WRONG_PASSWORD',
        );
      case 'user-not-found':
        return const AuthFailure(
          message: 'Account not found.',
          code: 'USER_NOT_FOUND',
        );
      case 'user-disabled':
        return const AuthFailure(
          message: 'This account has been disabled.',
          code: 'USER_DISABLED',
        );
      case 'network-request-failed':
        return const NetworkFailure();
      case 'invalid-credential':
        return const AuthFailure(
          message: 'Incorrect password.',
          code: 'WRONG_PASSWORD',
        );
      default:
        return AuthFailure(
          message: e.message ?? 'Authentication failed.',
        );
    }
  }
}
