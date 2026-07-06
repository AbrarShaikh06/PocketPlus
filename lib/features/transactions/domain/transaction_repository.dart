import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import 'entities/transaction.dart';

abstract interface class TransactionRepository {
  Stream<List<Transaction>> watchTransactions({
    required String userId,
    required String profileId,
  });

  Future<Either<Failure, Transaction>> createTransaction(
    Transaction transaction,
  );

  Future<Either<Failure, Transaction>> updateTransaction(
    Transaction transaction,
  );

  Future<Either<Failure, void>> softDeleteTransaction(
    String transactionId,
  );

  Future<Either<Failure, void>> restoreTransaction(
    String transactionId,
  );

  Future<Either<Failure, List<Transaction>>> getTransactionsFromCache({
    required String userId,
    required String profileId,
  });
}
