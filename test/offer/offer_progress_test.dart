import 'dart:math';

import 'package:elite_counsel/bloc/cubit/student_application_cubit.dart';
import 'package:elite_counsel/bloc/offer_bloc.dart';
import 'package:elite_counsel/test_config/mocks/application_mock.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:flutter_test/flutter_test.dart';

import '../profile/profile_test.dart';

void main() {
  test('Test to change progress of application', () async {
    var student = await ProfileTestSuite().getStudentProfile();
    if (student!.applications?.isEmpty ?? false) {
      var mockApplication = MockApplication();
      var response = await OfferBloc.addOffer(
        mockApplication,
        MockFirebaseAgentUser().uid,
      );
      student = await ProfileTestSuite().getStudentProfile();
    }
    final application = student!.applications!.last;
    int randomProgress = Random().nextInt(6);
    await StudentApplicationCubit(application)
        .changeApplicationProgress(randomProgress);
    student = await ProfileTestSuite().getStudentProfile();
  
    expect(
      student!.applications!.any((element) =>
          element.progress == randomProgress &&
          element.applicationID == application.applicationID),
      true,
    );
  });
}
