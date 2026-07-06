import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/firebase_providers.dart';
import 'firestore_sms_dedup_data_source.dart';

/// SHA-256 dedup gate for auto-captured SMS transactions.
class SmsDedupRepository {
  SmsDedupRepository(this._dataSource);

  final FirestoreSmsDedupDataSource _dataSource;

  Future<bool> checkDuplicate(String userId, String smsHash) =>
      _dataSource.exists(userId, smsHash);

  Future<void> writeDedupLog(
    String userId,
    String smsHash,
    DedupAction action,
    String? transactionId,
  ) =>
      _dataSource.write(userId, smsHash, action, transactionId);

  Future<bool> claim(String userId, String smsHash) =>
      _dataSource.claim(userId, smsHash);
}

final firestoreSmsDedupDataSourceProvider =
    Provider<FirestoreSmsDedupDataSource>((ref) {
  return FirestoreSmsDedupDataSourceImpl(ref.watch(firestoreProvider));
});

final smsDedupRepositoryProvider = Provider<SmsDedupRepository>((ref) {
  return SmsDedupRepository(ref.watch(firestoreSmsDedupDataSourceProvider));
});
