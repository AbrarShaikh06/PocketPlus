import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../domain/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  @override
  Future<Either<Failure, void>> saveOnboardingData({
    required String role,
    String? businessName,
    String? displayName,
    String? phone,
    String? region,
    String? currencyCode,
    int? age,
  }) async {
    final uid = firebaseAuth.currentUser?.uid;
    if (uid == null) {
      return const Left(AuthFailure(message: 'Not signed in.'));
    }
    try {
      await firestore.collection('users').doc(uid).set(
        {
          'role': role,
          if (businessName != null) 'businessName': businessName,
          if (displayName != null) 'displayName': displayName,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          if (region != null && region.isNotEmpty) 'region': region,
          if (currencyCode != null) 'country': currencyCode,
          if (age != null) 'age': age,
          'plan': 'FREE',
          'onboardingCompleted': true,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }
}
