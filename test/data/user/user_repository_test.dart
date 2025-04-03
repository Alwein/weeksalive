import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fast_template/data/user/user_repository.dart';
import 'package:flutter_fast_template/domain/user/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../utils/mocks.dart';

void main() {
  late MockFirestoreUserQueries mockFirestoreUserQueries;
  late MockCrashlyticsRepository mockCrashlyticsRepository;

  late UserRepository userRepository;

  setUp(() {
    mockFirestoreUserQueries = MockFirestoreUserQueries();
    mockCrashlyticsRepository = MockCrashlyticsRepository();

    userRepository = UserRepository(
      firestoreUserQueries: mockFirestoreUserQueries,
      crashlyticsRepository: mockCrashlyticsRepository,
    );
  });

  group('createUser', () {
    test('should succeed', () async {
      // Given
      mockFirestoreUserQueries.withSetUserDocumentSuccess();

      // When
      final result = await userRepository.createUser('123');

      // Then
      expect(result, isA<User>());
      verify(() => mockFirestoreUserQueries.setUserDocument(
            userId: '123',
            data: {
              'id': '123',
              'createdAt': isA<FieldValue>(),
            },
          )).called(1);
    });

    test('should throw an exception', () async {
      // Given
      mockFirestoreUserQueries.withSetUserDocumentError();

      // When
      final call = userRepository.createUser('123');

      // Then
      expect(call, throwsA(isA<Exception>()));

      verify(() => mockFirestoreUserQueries.setUserDocument(
            userId: '123',
            data: {
              'id': '123',
              'createdAt': isA<FieldValue>(),
            },
          )).called(1);
    });
  });
}
