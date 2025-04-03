import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUserQueries {
  FirestoreUserQueries({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> userRef(String userId) => _firestore.collection('users').doc(userId);

  Future<void> setUserDocument({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await userRef(userId).set(data);
  }

  Stream<Map<String, dynamic>?> userDocument(String userId) {
    return userRef(userId).snapshots().map((snapshot) => snapshot.data());
  }

  Future<void> updateUserConfig({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await userRef(userId).update(data);
  }
}
