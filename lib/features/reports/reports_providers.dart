import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/firebase_providers.dart';
import 'data/firestore_report_data_source.dart';
import 'data/report_repository_impl.dart';
import 'domain/report_repository.dart';

final firestoreReportDataSourceProvider =
    Provider<FirestoreReportDataSource>((ref) {
  return FirestoreReportDataSourceImpl(ref.watch(firestoreProvider));
});

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(ref.watch(firestoreReportDataSourceProvider));
});
