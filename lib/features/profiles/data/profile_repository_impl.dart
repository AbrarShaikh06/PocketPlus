import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../../../shared/models/models.dart';
import '../domain/entities/profile.dart';
import '../domain/profile_repository.dart';
import 'firestore_profile_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({
    required FirestoreProfileDataSource dataSource,
    required this.firebaseAuth,
  }) : _dataSource = dataSource;

  final FirestoreProfileDataSource _dataSource;
  final FirebaseAuth firebaseAuth;

  static const _uuid = Uuid();

  @override
  Future<Either<Failure, Profile>> createDefaultProfile(String userId) async {
    try {
      final now = DateTime.now();
      final profile = Profile(
        id: _uuid.v4(),
        userId: userId,
        name: 'My Business',
        type: ProfileType.shop,
        isDefault: true,
        createdAt: now,
        updatedAt: now,
      );
      return Right(await _dataSource.createProfile(profile));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Stream<List<Profile>> watchProfiles(String userId) {
    return _dataSource.watchProfiles(userId);
  }

  @override
  Future<Either<Failure, Profile>> createProfile(Profile profile) async {
    try {
      final id = profile.id.isEmpty ? _uuid.v4() : profile.id;
      final now = DateTime.now();
      final toCreate = profile.copyWith(
        id: id,
        createdAt: profile.createdAt ?? now,
        updatedAt: now,
      );
      return Right(await _dataSource.createProfile(toCreate));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Profile>> updateProfile(Profile profile) async {
    try {
      final updated = profile.copyWith(updatedAt: DateTime.now());
      return Right(await _dataSource.updateProfile(updated));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, String?>> getSmsProfileRoute(
    String bankAccountLast4,
  ) async {
    try {
      return Right(await _dataSource.getProfileIdByBankLast4(bankAccountLast4));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }
}
