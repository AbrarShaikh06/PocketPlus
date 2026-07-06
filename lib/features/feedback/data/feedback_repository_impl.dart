import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/error_mapper.dart';
import '../../../core/errors/failures.dart';
import '../domain/entities/feedback_item.dart';
import '../domain/feedback_repository.dart';
import 'firestore_feedback_data_source.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  FeedbackRepositoryImpl({
    required FirestoreFeedbackDataSource dataSource,
    required this.firebaseStorage,
  }) : _dataSource = dataSource;

  final FirestoreFeedbackDataSource _dataSource;
  final FirebaseStorage firebaseStorage;

  static const _uuid = Uuid();

  @override
  Future<Either<Failure, void>> submitFeedback(
    FeedbackItem item, {
    String? localScreenshotPath,
  }) async {
    try {
      final id = item.id.isEmpty ? _uuid.v4() : item.id;
      var toSubmit = item.copyWith(id: id);

      if (localScreenshotPath != null && localScreenshotPath.isNotEmpty) {
        try {
          final ref = firebaseStorage.ref('feedback/$id.jpg');
          await ref.putFile(File(localScreenshotPath));
          final url = await ref.getDownloadURL();
          toSubmit = toSubmit.copyWith(screenshotUrl: url);
        } catch (e) {
          // Storage may be unavailable (Spark plan / not enabled). Submit the
          // feedback without the screenshot rather than failing entirely.
          debugPrint('Feedback screenshot upload skipped: $e');
        }
      }

      await _dataSource.submitFeedback(toSubmit);
      return const Right(null);
    } catch (e) {
      return Left(ErrorMapper.fromException(e));
    }
  }
}
