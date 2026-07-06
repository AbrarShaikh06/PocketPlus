import 'package:dartz/dartz.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../domain/entities/khata_customer.dart';
import '../domain/entities/khata_entry.dart';
import '../domain/khata_repository.dart';
import 'firestore_khata_data_source.dart';

class KhataRepositoryImpl implements KhataRepository {
  KhataRepositoryImpl(this._dataSource);

  final FirestoreKhataDataSource _dataSource;

  @override
  Stream<List<KhataCustomer>> watchCustomers({
    required String userId,
    required String profileId,
  }) {
    return _dataSource.watchCustomers(userId: userId, profileId: profileId);
  }

  @override
  Stream<List<KhataEntry>> watchCustomerEntries(String customerId) {
    return _dataSource.watchCustomerEntries(customerId);
  }

  @override
  Future<Either<Failure, KhataCustomer>> createCustomer(
    KhataCustomer customer,
  ) async {
    try {
      return Right(await _dataSource.createCustomer(customer));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> addCreditEntry({
    required String customerId,
    required int amountPaise,
    String? note,
  }) async {
    try {
      await _dataSource.addEntry(
        customerId: customerId,
        amountPaise: amountPaise,
        type: KhataEntryType.creditGiven,
        note: note,
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> addRepaymentEntry({
    required String customerId,
    required int amountPaise,
    String? note,
  }) async {
    try {
      await _dataSource.addEntry(
        customerId: customerId,
        amountPaise: amountPaise,
        type: KhataEntryType.repaymentReceived,
        note: note,
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> softDeleteCustomer(String customerId) async {
    try {
      await _dataSource.softDeleteCustomer(customerId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }
}
