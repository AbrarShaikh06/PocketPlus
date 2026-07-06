/// Data-source layer exceptions. Mapped to [Failure] before crossing repo boundary.
class AppException implements Exception {
  const AppException({
    required this.message,
    required this.code,
    this.cause,
  });

  final String message;
  final String code;
  final Object? cause;

  @override
  String toString() => 'AppException($code): $message';
}
