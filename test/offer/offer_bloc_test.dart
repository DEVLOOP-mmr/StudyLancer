import 'package:elite_counsel/bloc/offer_bloc.dart';
import 'package:elite_counsel/test_config/mocks/application_mock.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../profile/profile_test.dart';

void main() {
  group('Offer Tests', () {
    test('Test to create an offer', () async {
      var mockApplication = MockApplication();
      var response = await OfferBloc.addOffer(
        mockApplication,
        MockFirebaseAgentUser().uid,
      );
      if (response.statusCode == 500) {
        await ProfileTestSuite().updateStudentRequiredDocs();
        response = await OfferBloc.addOffer(
          mockApplication,
          MockFirebaseAgentUser().uid,
        );
      }
      expect(response.statusCode, 201);

      var agentHome = await ProfileTestSuite().getAgentHome();

      bool applicationIsInOptionsProvided = agentHome.applications!.any((app) {
        return app.courseName == mockApplication.courseName &&
            app.agent?.id == agentHome.agent!.id &&
            app.status == 2;
      });

      expect(applicationIsInOptionsProvided, true);
    });

    test(
      'Test to accept an offer',
      () async {
        var student = (await (ProfileTestSuite().getStudentProfile()))!;
        var mockApplication = MockApplication();
        if (student.applications!.isEmpty) {
          await OfferBloc.addOffer(
            mockApplication,
            MockFirebaseAgentUser().uid,
          );
          student = (await (ProfileTestSuite().getStudentProfile()))!;
        }

        final application = student.applications!.last;
        mockApplication.courseName = application.courseName;
        var response = await OfferBloc.acceptOffer(
          application.applicationID,
          application.agent?.id,
          MockFirebaseStudentUser().uid,
        );
        expect(response.statusCode==200 || response.statusCode==202, true);

        var agentHome = await ProfileTestSuite().getAgentHome();
        bool applicationIsInOngoing =
            agentHome.applications!.any((app) {
          return app.courseName == mockApplication.courseName &&
              app.agent?.id == agentHome.agent!.id &&
              app.status == 3;
        });

        expect(applicationIsInOngoing, true);
      },
    );
  });
}
