import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/firebase_providers.dart';
import '../home/presentation/home_providers.dart';
import 'data/firestore_transaction_data_source.dart';
import 'data/transaction_repository_impl.dart';
import 'domain/entities/transaction.dart';
import 'domain/transaction_repository.dart';

final firestoreTransactionDataSourceProvider =
    Provider<FirestoreTransactionDataSource>((ref) {
  return FirestoreTransactionDataSourceImpl(ref.watch(firestoreProvider));
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(
    ref.watch(firestoreTransactionDataSourceProvider),
  );
});

final allTransactionsStreamProvider =
    StreamProvider.autoDispose<List<Transaction>>((ref) {
  final currentProfile = ref.watch(currentProfileProvider);
  final userId = ref.watch(currentBookUserIdProvider);
  if (userId == null || currentProfile == null) {
    return const Stream.empty();
  }
  return ref.watch(transactionRepositoryProvider).watchTransactions(
        userId: userId,
        profileId: currentProfile.id,
      );
});
