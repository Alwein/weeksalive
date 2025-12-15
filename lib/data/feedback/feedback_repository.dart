import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fast_template/data/crashlytics/crashlytics_repository.dart';
import 'package:flutter_fast_template/data/feedback/create_feedback_request.dart';

class FeedbackRepository {
  FeedbackRepository({
    FirebaseFirestore? firestore,
    required CrashlyticsRepository crashlyticsRepository,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _crashlyticsRepository = crashlyticsRepository;

  final FirebaseFirestore _firestore;
  final CrashlyticsRepository _crashlyticsRepository;

  Future<void> uploadFeedback(CreateFeedbackRequest request) async {
    try {
      await _firestore.collection('feedbacks').add(request.toJson());
    } catch (e, stackTrace) {
      await _crashlyticsRepository.recordError(
        e,
        stackTrace,
        reason: 'Failed to upload feedback',
      );
    }
  }
}
