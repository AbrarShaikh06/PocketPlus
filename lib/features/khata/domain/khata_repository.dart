import 'package:dartz/dartz.dart';

import '../../../core/errors/failures.dart';
import 'entities/khata_customer.dart';
import 'entities/khata_entry.dart';

abstract interface class KhataRepository {
  Stream<List<KhataCustomer>> watchCustomers({
    required String userId,
    required String profileId,
  });

  Stream<List<KhataEntry>> watchCustomerEntries(String customerId);

  Future<Either<Failure, KhataCustomer>> createCustomer(
    KhataCustomer customer,
  );

  Future<Either<Failure, void>> addCreditEntry({
    required String customerId,
    required int amountPaise,
    String? note,
  });

  Future<Either<Failure, void>> addRepaymentEntry({
    required String customerId,
    required int amountPaise,
    String? note,
  });

  Future<Either<Failure, void>> softDeleteCustomer(String customerId);
}
