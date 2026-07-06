import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/entities/feedback_item.dart';

abstract interface class FirestoreFeedbackDataSource {
  Future<void> submitFeedback(FeedbackItem item);
}

class FirestoreFeedbackDataSourceImpl implements FirestoreFeedbackDataSource {
  FirestoreFeedbackDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('feedback');

  @override
  Future<void> submitFeedback(FeedbackItem item) async {
    await _col.doc(item.id).set(item.toJson());
  }
}
