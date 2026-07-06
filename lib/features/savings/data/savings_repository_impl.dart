import 'package:dartz/dartz.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../domain/savings_entry.dart';
import '../domain/savings_goal.dart';
import '../domain/savings_repository.dart';
import 'savings_data_source.dart';

class SavingsRepositoryImpl implements SavingsRepository {
  SavingsRepositoryImpl(this._dataSource);

  final FirestoreSavingsDataSource _dataSource;

  @override
  Stream<List<SavingsGoal>> watchGoals({
    required String userId,
    required String profileId,
  }) {
    return _dataSource.watchGoals(userId: userId, profileId: profileId);
  }

  @override
  Stream<List<SavingsEntry>> watchEntries({required String goalId}) {
    return _dataSource.watchEntries(goalId: goalId);
  }

  @override
  Future<Either<Failure, SavingsGoal>> createGoal(SavingsGoal goal) async {
    try {
      return Right(await _dataSource.createGoal(goal));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateGoal(SavingsGoal goal) async {
    try {
      await _dataSource.updateGoal(goal);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> addEntry(SavingsEntry entry) async {
    try {
      await _dataSource.addEntry(entry);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> softDeleteGoal(String goalId) async {
    try {
      await _dataSource.softDeleteGoal(goalId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> restoreGoal(String goalId) async {
    try {
      await _dataSource.restoreGoal(goalId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }
}
