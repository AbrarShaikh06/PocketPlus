import 'package:dartz/dartz.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../domain/entities/transaction.dart';
import '../domain/transaction_repository.dart';
import 'firestore_transaction_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._dataSource);

  final FirestoreTransactionDataSource _dataSource;

  @override
  Stream<List<Transaction>> watchTransactions({
    required String userId,
    required String profileId,
  }) {
    return _dataSource.watchTransactions(userId: userId, profileId: profileId);
  }

  @override
  Future<Either<Failure, Transaction>> createTransaction(
    Transaction transaction,
  ) async {
    try {
      return Right(await _dataSource.createTransaction(transaction));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Transaction>> updateTransaction(
    Transaction transaction,
  ) async {
    try {
      return Right(await _dataSource.updateTransaction(transaction));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> softDeleteTransaction(
    String transactionId,
  ) async {
    try {
      await _dataSource.softDeleteTransaction(transactionId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> restoreTransaction(
    String transactionId,
  ) async {
    try {
      await _dataSource.restoreTransaction(transactionId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getTransactionsFromCache({
    required String userId,
    required String profileId,
  }) async {
    try {
      return Right(
        await _dataSource.getTransactionsFromCache(
          userId: userId,
          profileId: profileId,
        ),
      );
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }
}
