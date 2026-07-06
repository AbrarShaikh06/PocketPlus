import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../domain/auth_repository.dart';
import 'firebase_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource, this._firestore);
  final FirebaseAuthDataSource _dataSource;
  final FirebaseFirestore _firestore;

  FirebaseAuth get _auth => FirebaseAuth.instance;

  @override
  Future<Either<Failure, void>> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final existing = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();
      if (existing.docs.isNotEmpty) {
        return const Left(
          ConflictFailure(message: 'Username already exists.'),
        );
      }

      final credential = await _dataSource.createUserWithEmailAndPassword(
        email,
        password,
      );
      final uid = credential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'username': username,
        'email': email,
        'displayName': username,
        'photoUrl': null,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });

      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> signInWithUsername({
    required String username,
    required String password,
  }) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return const Left(
          AuthFailure(message: 'Username not found.'),
        );
      }

      final userData = query.docs.first.data();
      final email = userData['email'] as String;
      final uid = query.docs.first.id;

      await _dataSource.signInWithEmailAndPassword(email, password);

      await _firestore.collection('users').doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(
    String username,
  ) async {
    try {
      final query = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return const Left(
          AuthFailure(message: 'Username not found.'),
        );
      }

      final email = query.docs.first.data()['email'] as String;
      await _dataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> signInWithGoogle() async {
    try {
      await _dataSource.signInWithGoogle();
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          final email = user.email ?? '';
          final name = user.displayName ?? email.split('@').first;
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'username': name,
            'email': email,
            'displayName': name,
            'photoUrl': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'lastLogin': FieldValue.serverTimestamp(),
          });
        } else {
          await _firestore.collection('users').doc(user.uid).update({
            'lastLogin': FieldValue.serverTimestamp(),
          });
        }
      }
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }
}
