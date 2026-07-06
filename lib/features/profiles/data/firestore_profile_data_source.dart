import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/entities/profile.dart';

/// Firestore access for the `profiles` collection. Scoped by userId and
/// excludes soft-deleted profiles (`deletedAt == null`).
abstract interface class FirestoreProfileDataSource {
  Stream<List<Profile>> watchProfiles(String userId);
  Future<Profile> createProfile(Profile profile);
  Future<Profile> updateProfile(Profile profile);

  /// Returns the id of the (non-deleted) profile whose `bankAccountLast4`
  /// contains [bankAccountLast4], used to route incoming bank-SMS to the right
  /// profile. Null when no profile matches.
  Future<String?> getProfileIdByBankLast4(String bankAccountLast4);
}

class FirestoreProfileDataSourceImpl implements FirestoreProfileDataSource {
  FirestoreProfileDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('profiles');

  @override
  Stream<List<Profile>> watchProfiles(String userId) {
    return _col
        .where('userId', isEqualTo: userId)
        .where('deletedAt', isNull: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => Profile.fromJson(d.data())).toList(),
        );
  }

  @override
  Future<Profile> createProfile(Profile profile) async {
    await _col.doc(profile.id).set(profile.toJson());
    return profile;
  }

  @override
  Future<Profile> updateProfile(Profile profile) async {
    await _col.doc(profile.id).set(profile.toJson());
    return profile;
  }

  @override
  Future<String?> getProfileIdByBankLast4(String bankAccountLast4) async {
    final snap = await _col
        .where('bankAccountLast4', arrayContains: bankAccountLast4)
        .where('deletedAt', isNull: true)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return snap.docs.first.id;
  }
}
