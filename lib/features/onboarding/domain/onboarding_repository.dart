import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';

abstract interface class OnboardingRepository {
  Future<Either<Failure, void>> saveOnboardingData({
    required String role,
    String? businessName,
    String? displayName,
    String? phone,
    String? region,
    String? currencyCode,
    int? age,
  });
}
