import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/bloc/profile_bloc.dart';
import 'package:elite_counsel/classes/classes.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/test_config/mocks/document_mock.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/setups.dart';

void main() {
  group('Test to fetch home data for:', () {
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

  test('Test to fetch a single profile by uid for a wrong user type', () async {
    var mock = MockFirebaseStudentUser();
    final user =
        await ProfileBloc.getUserProfile(uid: mock.uid, userType: 'agent');
    expect(user.id, mock.uid);
    expect(user.phone, isNotEmpty);
  });
}

class ProfileTestSuite {
  Future<Student> getStudentProfile() async {
    StudentHomeState studentHomeData = await getStudentHome();
    final student = studentHomeData.student;

    return student;
  }

  Future<StudentHomeState> getStudentHome() async {
    final mockAuth = MockFirebaseAuth('student');
    var homeBloc = HomeBloc()..setCountry('CA', 'student');
    var studentHomeData = await homeBloc.getStudentHome(firebaseAuth: mockAuth);
    if (!studentHomeData.student.verified) {
      await updateStudentRequiredDocs();
      homeBloc.setCountry('CA', 'student');
      studentHomeData = await homeBloc.getStudentHome(firebaseAuth: mockAuth);
    }
    return studentHomeData;
  }

  Future<void> updateStudentRequiredDocs() async {
    await Future.wait(Student.requiredDocs.map((docName) async {
      var doc = MockDocument()..name = docName;
      await DocumentBloc(userType: 'student')
          .postDocument(doc, MockFirebaseStudentUser().uid);
    }).toList());
  }

  Future<Agent> getAgentProfile() async {
    AgentHomeState agentHomeData = await getAgentHome();
    final agent = agentHomeData.agent;
    return agent;
  }

  Future<AgentHomeState> getAgentHome() async {
    final mockAuth = MockFirebaseAuth('agent');
    var homeBloc = HomeBloc()..setCountry('CA', 'agent');
    var agentHomeData = await homeBloc.getAgentHome(auth: mockAuth);
    if (!agentHomeData.agent.verified) {
      await updateAgentRequiredDocs();
       homeBloc.setCountry('CA', 'agent');
      agentHomeData = await homeBloc.getAgentHome(auth: mockAuth);
    }
    return agentHomeData;
  }

  Future<void> updateAgentRequiredDocs() async {
    await Future.wait(Agent.requiredDocNames.map((docName) async {
      var doc = MockDocument()..name = docName;
      await DocumentBloc(userType: 'agent')
          .postDocument(doc, MockFirebaseAgentUser().uid);
    }).toList());
  }
}
