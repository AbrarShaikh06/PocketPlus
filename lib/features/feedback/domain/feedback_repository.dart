import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import 'entities/feedback_item.dart';

abstract interface class FeedbackRepository {
  Future<Either<Failure, void>> submitFeedback(
    FeedbackItem item, {
    String? localScreenshotPath,
  });
}
