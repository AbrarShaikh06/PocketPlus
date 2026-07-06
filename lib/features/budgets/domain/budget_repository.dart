import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import 'entities/budget.dart';

abstract interface class BudgetRepository {
  Stream<List<Budget>> watchBudgets({
    required String userId,
    required String profileId,
  });

  Future<Either<Failure, Budget>> createBudget(Budget budget);
  Future<Either<Failure, Budget>> updateBudget(Budget budget);
  Future<Either<Failure, void>> softDeleteBudget(String budgetId);
  Future<Either<Failure, Budget>> duplicateBudget(Budget budget);
  Future<Either<Failure, void>> togglePauseBudget(
      String budgetId, bool isPaused);
  Future<Either<Failure, List<Budget>>> getBudgetsFromCache({
    required String userId,
    required String profileId,
  });
}
