import 'package:cloud_firestore/cloud_firestore.dart';

class CreateFeedbackRequest {
  final String userId;
  final bool? positive;
  final String? suggestions;

  CreateFeedbackRequest({
    required this.userId,
    required this.positive,
    required this.suggestions,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'positive': positive,
      // max length : 1024
      'suggestions': suggestions,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
