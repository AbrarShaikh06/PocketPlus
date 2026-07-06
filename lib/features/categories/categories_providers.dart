import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/firebase_providers.dart';
import 'data/firestore_category_data_source.dart';
import 'data/category_repository_impl.dart';
import 'domain/category_repository.dart';

final firestoreCategoryDataSourceProvider =
    Provider<FirestoreCategoryDataSource>((ref) {
  return FirestoreCategoryDataSourceImpl(ref.watch(firestoreProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(
    ref.watch(firestoreCategoryDataSourceProvider),
  );
});
