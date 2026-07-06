import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/firebase_providers.dart';
import 'data/firestore_khata_data_source.dart';
import 'data/khata_repository_impl.dart';
import 'domain/khata_repository.dart';

final firestoreKhataDataSourceProvider =
    Provider<FirestoreKhataDataSource>((ref) {
  return FirestoreKhataDataSourceImpl(ref.watch(firestoreProvider));
});

final khataRepositoryProvider = Provider<KhataRepository>((ref) {
  return KhataRepositoryImpl(
    ref.watch(firestoreKhataDataSourceProvider),
  );
});
