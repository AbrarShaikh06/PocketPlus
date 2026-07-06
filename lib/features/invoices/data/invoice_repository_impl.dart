import 'package:dartz/dartz.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../domain/entities/invoice.dart';
import '../domain/invoice_repository.dart';
import 'firestore_invoice_data_source.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl(this._dataSource);

  final FirestoreInvoiceDataSource _dataSource;

  @override
  Stream<List<Invoice>> watchInvoices({
    required String userId,
    required String profileId,
  }) {
    return _dataSource.watchInvoices(userId: userId, profileId: profileId);
  }

  @override
  Future<Either<Failure, Invoice>> createInvoice(Invoice invoice) async {
    try {
      return Right(await _dataSource.createInvoice(invoice));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Invoice>> updateInvoice(Invoice invoice) async {
    try {
      return Right(await _dataSource.updateInvoice(invoice));
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> markAsPaid(String invoiceId) async {
    try {
      await _dataSource.markAsPaid(invoiceId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> softDeleteInvoice(String invoiceId) async {
    try {
      await _dataSource.softDeleteInvoice(invoiceId);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }
}
