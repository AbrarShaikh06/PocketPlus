import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/providers/firebase_providers.dart';
import 'data/feedback_repository_impl.dart';
import 'data/firestore_feedback_data_source.dart';
import 'domain/feedback_repository.dart';

final firestoreFeedbackDataSourceProvider =
    Provider<FirestoreFeedbackDataSource>((ref) {
  return FirestoreFeedbackDataSourceImpl(ref.watch(firestoreProvider));
});

final feedbackRepositoryProvider = Provider<FeedbackRepository>((ref) {
  return FeedbackRepositoryImpl(
    dataSource: ref.watch(firestoreFeedbackDataSourceProvider),
    firebaseStorage: ref.watch(firebaseStorageProvider),
  );
});
