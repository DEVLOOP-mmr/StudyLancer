import 'dart:math';

import 'package:elite_counsel/models/application.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:uuid/uuid.dart';

class MockApplication extends Application {
  MockApplication() {
    student = Student(optionStatus: 1)..id= MockFirebaseStudentUser().uid;
    agent?.id = MockFirebaseAgentUser().uid;
    universityName = 'Toronto University';
    location = {"city": "Sydney", "country": "Australia"};
    applicationFees = '2000';
    courseFees = (Random().nextInt(10000) + 100).toString();
    courseName = "course-" + const Uuid().v4();
    description =
        "Please check the university reviews over google one of the best colleges";
    courseLink = "https:www.google.com";
  }
}
