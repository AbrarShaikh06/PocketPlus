import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/firebase_providers.dart';
import 'data/firestore_invoice_data_source.dart';
import 'data/invoice_repository_impl.dart';
import 'domain/invoice_repository.dart';

final firestoreInvoiceDataSourceProvider =
    Provider<FirestoreInvoiceDataSource>((ref) {
  return FirestoreInvoiceDataSourceImpl(ref.watch(firestoreProvider));
});

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepositoryImpl(
    ref.watch(firestoreInvoiceDataSourceProvider),
  );
});

final monthlyInvoiceCountProvider =
    FutureProvider.family<int, String>((ref, userId) async {
  final firestore = ref.watch(firestoreProvider);
  final doc = await firestore.collection('users').doc(userId).get();
  return doc.data()?['monthlyInvoiceCount'] as int? ?? 0;
});
