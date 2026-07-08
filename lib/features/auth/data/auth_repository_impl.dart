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

  /// Public username→account index. Keyed by the lowercased username so the
  /// `users` collection can stay private (owner-only) while login and the
  /// uniqueness check use a single document `get` instead of a collection
  /// query. Rules allow `get` but not `list`, so usernames can't be enumerated.
  DocumentReference<Map<String, dynamic>> _usernameRef(String username) =>
      _firestore.collection('usernames').doc(username.trim().toLowerCase());

  @override
  Future<Either<Failure, void>> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final existing = await _usernameRef(username).get();
      if (existing.exists) {
        return const Left(
          ConflictFailure(message: 'Username already exists.'),
        );
      }

      final credential = await _dataSource.createUserWithEmailAndPassword(
        email,
        password,
      );
      final uid = credential.user!.uid;

      // Claim the username and create the profile atomically. If another
      // signup claimed the same username between the check and here, the
      // usernames write becomes an update (denied by rules) and the whole
      // batch fails, rolling back cleanly.
      final batch = _firestore.batch();
      batch.set(_firestore.collection('users').doc(uid), {
        'uid': uid,
        'username': username,
        'email': email,
        'displayName': username,
        'photoUrl': null,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
      batch.set(_usernameRef(username), {
        'uid': uid,
        'email': email,
        'username': username,
      });
      await batch.commit();

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
      final doc = await _usernameRef(username).get();

      if (!doc.exists) {
        return const Left(
          AuthFailure(message: 'Username not found.'),
        );
      }

      final data = doc.data()!;
      final email = data['email'] as String;
      final uid = data['uid'] as String;

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
      final doc = await _usernameRef(username).get();

      if (!doc.exists) {
        return const Left(
          AuthFailure(message: 'Username not found.'),
        );
      }

      final email = doc.data()!['email'] as String;
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
