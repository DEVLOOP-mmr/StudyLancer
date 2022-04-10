import 'package:elite_counsel/models/review.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:mockito/mockito.dart';

class MockReview extends Mock implements Review {
  MockReview() {
    final agent = MockFirebaseAgentUser();
    final student = MockFirebaseStudentUser();
    studentId = student.uid;
    agentId = agent.uid;
    reviewContent = 'test_content';
    starsRated = '4';
  }

  static Map<String, dynamic> mockReviewDate() {
    return {
      "studentID": "w1tQWOzFPtcM6rG68LJK66lrnNx1",
      "agentID": "H9e1YBfcOoSKdqiVKx98dj7hPH3",
      "content":
          "He is a very nice guy and expert of guiding through whole process",
      "stars": 4,
      "studentName": "Lalit"
    };
  }
}
