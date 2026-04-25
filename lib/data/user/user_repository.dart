import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weeksalive/data/crashlytics/crashlytics_repository.dart';
import 'package:weeksalive/data/services/firestore_user_queries.dart';
import 'package:weeksalive/data/user/update_user_config_request.dart';
import 'package:weeksalive/domain/user/user.dart';

class UserRepository {
  final FirestoreUserQueries _firestoreUserQueries;
  final CrashlyticsRepository _crashlyticsRepository;

  UserRepository({
    required FirestoreUserQueries firestoreUserQueries,
    required CrashlyticsRepository crashlyticsRepository,
  }) : _firestoreUserQueries = firestoreUserQueries,
       _crashlyticsRepository = crashlyticsRepository;

  Future<User> createUser(String userId) async {
    try {
      await _firestoreUserQueries.setUserDocument(
        userId: userId,
        data: {
          'id': userId,
          'createdAt': FieldValue.serverTimestamp(),
        },
      );

      return User(id: userId, premiumPlan: null, createdAt: DateTime.now());
    } catch (e, s) {
      _crashlyticsRepository.recordError(e, s);
      rethrow;
    }
  }

  Future<User?> getUser(String userId) async {
    try {
      final doc = await _firestoreUserQueries.getUserFromId(userId);
      if (doc == null) return null;
      return User.fromDocument(doc);
    } catch (e, s) {
      _crashlyticsRepository.recordError(e, s, reason: 'Failed to get user document');
      rethrow;
    }
  }

  Future<void> updateUserConfig(String userId, UpdateUserConfigRequest userConfig) async {
    try {
      await _firestoreUserQueries.updateUserConfig(
        userId: userId,
        data: userConfig.toJson(),
      );
    } catch (e, s) {
      _crashlyticsRepository.recordError(e, s);
      rethrow;
    }
  }

  Stream<User?> streamUser(String userId) {
    try {
      return _firestoreUserQueries.userDocument(userId).map((doc) {
        if (doc == null) return null;
        return User.fromDocument(doc);
      });
    } catch (e, s) {
      _crashlyticsRepository.recordError(e, s);
      rethrow;
    }
  }
}
