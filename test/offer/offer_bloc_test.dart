import 'package:elite_counsel/bloc/offer_bloc.dart';
import 'package:elite_counsel/test_config/mocks/application_mock.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../profile/profile_test.dart';

void main() {
  group('Offer Tests', () {
    test('Test to create an offer', () async {
      var mockApplication = MockApplication();
      final response = await OfferBloc.addOffer(
        mockApplication,
        MockFirebaseAgentUser().uid,
      );

      expect(response.statusCode, 201);
    });

    test(
      'Test to accept an offer',
      () async {
        var student = await ProfileTestSuite().getStudentProfile();
        if (student.applications.isEmpty) {
          var mockApplication = MockApplication();
          await OfferBloc.addOffer(
            mockApplication,
            MockFirebaseAgentUser().uid,
          );
          student = await ProfileTestSuite().getStudentProfile();
        }

        final application = student.applications.last;
        var response = await OfferBloc.acceptOffer(
          application.offerId,
          application.agentID,
          application.studentID,
        );
        expect(response.statusCode, 200);
      },
    );
  });
}
