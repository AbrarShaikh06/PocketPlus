import 'package:dartz/dartz.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../domain/dashboard_data.dart';
import '../domain/dashboard_repository.dart';
import 'firestore_dashboard_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._dataSource);

  final FirestoreDashboardDataSource _dataSource;

  @override
  Stream<Either<Failure, DashboardData>> watchDashboardData({
    required String userId,
    required String profileId,
  }) {
    return _dataSource
        .watchDashboardData(userId: userId, profileId: profileId)
        .map(
          (data) => Right<Failure, DashboardData>(data),
        )
        .handleError(
          (e) => Left<Failure, DashboardData>(ErrorMapper.fromException(e)),
        );
  }
}
