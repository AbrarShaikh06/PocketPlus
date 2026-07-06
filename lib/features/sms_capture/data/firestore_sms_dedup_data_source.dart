import 'package:cloud_firestore/cloud_firestore.dart';

// Re-exported so consumers that only import this file also see
// SmsDedupRepository + smsDedupRepositoryProvider.
export 'sms_dedup_repository.dart';

/// How a parsed SMS was ultimately handled — recorded in `sms_dedup_log`.
enum DedupAction { logged, dismissed, duplicateSkipped }

/// Firestore access for the `sms_dedup_log` collection. Only the SHA-256 hash
/// of the SMS is stored — the raw text is never persisted (CLAUDE.md).
abstract interface class FirestoreSmsDedupDataSource {
  Future<bool> exists(String userId, String smsHash);
  Future<void> write(
    String userId,
    String smsHash,
    DedupAction action,
    String? transactionId,
  );

  /// Atomically claims an SMS hash for this user. Uses a Firestore transaction
  /// to read then write — only the first caller succeeds. Returns `true` if
  /// this caller claimed the hash, `false` if it was already claimed.
  Future<bool> claim(String userId, String smsHash);
}

class FirestoreSmsDedupDataSourceImpl implements FirestoreSmsDedupDataSource {
  FirestoreSmsDedupDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('sms_dedup_log');

  String _docId(String userId, String smsHash) => '${userId}_$smsHash';

  @override
  Future<bool> exists(String userId, String smsHash) async {
    final doc = await _col.doc(_docId(userId, smsHash)).get();
    return doc.exists;
  }

  @override
  Future<void> write(
    String userId,
    String smsHash,
    DedupAction action,
    String? transactionId,
  ) async {
    await _col.doc(_docId(userId, smsHash)).set(
      {
        'userId': userId,
        'smsHash': smsHash,
        'action': action.name,
        if (transactionId != null) 'transactionId': transactionId,
        'createdAt': Timestamp.now(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<bool> claim(String userId, String smsHash) async {
    final docRef = _col.doc(_docId(userId, smsHash));
    try {
      await _firestore.runTransaction((txn) async {
        final doc = await txn.get(docRef);
        if (doc.exists) {
          throw Exception('duplicate');
        }
        txn.set(docRef, {
          'userId': userId,
          'smsHash': smsHash,
          'action': DedupAction.logged.name,
          'createdAt': Timestamp.now(),
        });
      });
      return true;
    } catch (_) {
      return false;
    }
  }
}
