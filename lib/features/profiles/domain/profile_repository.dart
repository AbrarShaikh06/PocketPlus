import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import 'entities/profile.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, Profile>> createDefaultProfile(String userId);

  Stream<List<Profile>> watchProfiles(String userId);

  Future<Either<Failure, Profile>> createProfile(Profile profile);

  Future<Either<Failure, Profile>> updateProfile(Profile profile);

  Future<Either<Failure, String?>> getSmsProfileRoute(String bankAccountLast4);
}
