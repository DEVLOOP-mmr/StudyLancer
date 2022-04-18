import 'package:elite_counsel/bloc/review_bloc.dart';
import 'package:elite_counsel/models/review.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:elite_counsel/test_config/mocks/review_mock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Test to add, then fetch a review',
    () async {
      final review = MockReview();

      final success = await ReviewBloc.postAgentReview(review, 'test_student');

      expect(success is bool, true);

      final agentReviews = await ReviewBloc.getAgentReview(
          MockFirebaseAgentUser().uid, MockFirebaseStudentUser().uid);

      expect(agentReviews, isNotNull);
      expect(agentReviews.reviews, isNotEmpty);
      expect(
          agentReviews.reviews
              .any((element) => element.agentId == review.agentId),
          true);
    },
  );
}
