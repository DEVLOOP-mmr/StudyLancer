import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:mockito/mockito.dart';

class MockApplication extends Application {
  MockApplication() {
    studentID = MockFirebaseStudentUser().uid;
    agentID = MockFirebaseAgentUser().uid;
    universityName = 'Toronto University';
    location = {"city": "Sydney", "country": "Australia"};
    applicationFees = '2000';
    courseFees = '450000';
    courseName = "B.Tech ComputerScience engineering";
    description =
        "Please check the university reviews over google one of the best colleges";
    courseLink = "https:www.google.com";
  }
}
