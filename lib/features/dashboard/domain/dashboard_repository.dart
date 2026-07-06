import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import 'dashboard_data.dart';

abstract interface class DashboardRepository {
  Stream<Either<Failure, DashboardData>> watchDashboardData({
    required String userId,
    required String profileId,
  });
}
