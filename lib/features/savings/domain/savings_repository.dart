import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import 'savings_goal.dart';
import 'savings_entry.dart';

abstract interface class SavingsRepository {
  Stream<List<SavingsGoal>> watchGoals({
    required String userId,
    required String profileId,
  });

  Stream<List<SavingsEntry>> watchEntries({
    required String goalId,
  });

  Future<Either<Failure, SavingsGoal>> createGoal(SavingsGoal goal);

  Future<Either<Failure, void>> updateGoal(SavingsGoal goal);

  Future<Either<Failure, void>> addEntry(SavingsEntry entry);

  Future<Either<Failure, void>> softDeleteGoal(String goalId);

  Future<Either<Failure, void>> restoreGoal(String goalId);
}
