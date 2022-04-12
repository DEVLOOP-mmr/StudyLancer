import 'package:elite_counsel/bloc/review_bloc.dart';
import 'package:elite_counsel/models/review.dart';
import 'package:elite_counsel/test_config/mocks/review_mock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'Test to add a review',
    () async {
      final review = MockReview();

      final success = await ReviewBloc.postAgentReview(review, 'test_student');

      expect(success is bool, true);
    },
  );
}
