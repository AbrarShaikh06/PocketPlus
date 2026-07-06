import 'package:dartz/dartz.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../domain/budget_repository.dart';
import '../domain/entities/budget.dart';
import 'firestore_budget_data_source.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._dataSource);

  final FirestoreBudgetDataSource _dataSource;

  @override
  Stream<List<Budget>> watchBudgets(
      {required String userId, required String profileId}) {
    return _dataSource.watchBudgets(userId: userId, profileId: profileId);
  }

  @override
  Future<Either<Failure, Budget>> createBudget(Budget budget) async {
    try {
      return Right(await _dataSource.createBudget(budget));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Budget>> updateBudget(Budget budget) async {
    try {
      return Right(await _dataSource.updateBudget(budget));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> softDeleteBudget(String budgetId) async {
    try {
      await _dataSource.softDeleteBudget(budgetId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Budget>> duplicateBudget(Budget budget) async {
    try {
      final duplicate = budget.copyWith(
        id: '',
        name: '${budget.name} (Copy)',
        spentAmount: 0,
        remainingAmount: 0,
      );
      return Right(await _dataSource.createBudget(duplicate));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> togglePauseBudget(
      String budgetId, bool isPaused) async {
    try {
      await _dataSource.togglePauseBudget(budgetId, isPaused);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<Budget>>> getBudgetsFromCache(
      {required String userId, required String profileId}) async {
    try {
      return Right(await _dataSource.getBudgetsFromCache(
          userId: userId, profileId: profileId));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }
}
