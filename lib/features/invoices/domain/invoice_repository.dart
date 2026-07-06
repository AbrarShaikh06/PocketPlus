import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import 'entities/invoice.dart';

abstract interface class InvoiceRepository {
  Stream<List<Invoice>> watchInvoices({
    required String userId,
    required String profileId,
  });

  Future<Either<Failure, Invoice>> createInvoice(Invoice invoice);

  Future<Either<Failure, Invoice>> updateInvoice(Invoice invoice);

  Future<Either<Failure, void>> markAsPaid(String invoiceId);

  Future<Either<Failure, void>> softDeleteInvoice(String invoiceId);
}
