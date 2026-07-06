import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, void>> signUp({
    required String username,
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signInWithUsername({
    required String username,
    required String password,
  });

  Future<Either<Failure, void>> sendPasswordResetEmail(String username);

  Future<Either<Failure, void>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();
}
