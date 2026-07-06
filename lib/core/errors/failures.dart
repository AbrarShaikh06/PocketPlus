/// Repository-layer error types. All repos return `Either<Failure, T>`.
abstract class Failure {
  const Failure({required this.message, required this.code});

  final String message;
  final String code;
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Changes will sync when online.',
    super.code = 'NETWORK_ERROR',
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code = 'UNAUTHENTICATED',
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    required this.field,
    super.code = 'VALIDATION_ERROR',
  });

  final String field;
}

class ConflictFailure extends Failure {
  const ConflictFailure({
    required super.message,
    super.code = 'CONFLICT',
  });
}

class PlanLimitFailure extends Failure {
  const PlanLimitFailure({
    required super.message,
    super.code = 'PLAN_LIMIT_EXCEEDED',
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Something went wrong. Please try again.',
    super.code = 'INTERNAL_ERROR',
  });
}

class InvalidTokenFailure extends Failure {
  const InvalidTokenFailure({
    super.message = 'Invite expired or invalid. Ask your client to resend.',
    super.code = 'INVALID_TOKEN',
  });
}

class PhoneMismatchFailure extends Failure {
  const PhoneMismatchFailure({
    super.message = 'This invite was not sent to your number.',
    super.code = 'PHONE_MISMATCH',
  });
}
