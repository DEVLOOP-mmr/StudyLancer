import 'package:elite_counsel/models/review.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:mockito/mockito.dart';

class MockReview extends Review {
  MockReview()
      : super(
          studentId: MockFirebaseStudentUser().uid,
          agentId: MockFirebaseAgentUser().uid,
          reviewContent: 'test_content',
          starsRated: '4',
        );
}
