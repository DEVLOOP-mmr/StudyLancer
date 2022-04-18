import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/setups.dart';

void main() {
  
  group('Test to fetch profile data for:', () {
    test('student', () async {
      final student = await ProfileTestSuite().getStudentProfile();
      expect(student, isNotNull);
      expect(student.id, MockFirebaseStudentUser().uid);
    });
    test('agent', () async {
      final agent = await ProfileTestSuite().getAgentProfile();
      expect(agent, isNotNull);
      expect(agent.id, MockFirebaseAgentUser().uid);
    });
  });
}

class ProfileTestSuite {
  Future<Student> getStudentProfile() async {
    final mockAuth = MockFirebaseAuth('student');
    var homeBloc = HomeBloc()..setCountry('CA','student');
    final studentHomeData =
        await homeBloc.getStudentHome(firebaseAuth: mockAuth);
    final student = studentHomeData.student;
    return student;
  }

  Future<Agent> getAgentProfile() async {
    final mockAuth = MockFirebaseAuth('agent');
     var homeBloc = HomeBloc()..setCountry('CA','agent');
    final agentHomeData = await homeBloc.getAgentHome(auth: mockAuth);
    final agent = agentHomeData.agent;
    return agent;
  }
}
