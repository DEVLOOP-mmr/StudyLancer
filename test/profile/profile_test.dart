import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/bloc/profile_bloc.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:elite_counsel/test_config/mocks/document_mock.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test to fetch home data for:', () {
    test('student', () async {
      var studentHome = await ProfileTestSuite().getStudentHome();
      final student = ((studentHome).student)!;
      expect(student, isNotNull);
      expect(student.id, MockFirebaseStudentUser().uid);
      expect(student.verified, true);
      if (studentHome.agents?.isEmpty ?? false) {
        final agent = (await (ProfileTestSuite().getAgentProfile()))!;
        expect(agent, isNotNull);
        studentHome = await ProfileTestSuite().getStudentHome();
      }
      expect(studentHome.agents, isNotEmpty);
    });
    test('agent', () async {
      var agentHomeState = await (ProfileTestSuite().getAgentHome());
      final agent = (agentHomeState.agent)!;
      expect(agent, isNotNull);
      expect(agent.id, MockFirebaseAgentUser().uid);
      expect(agent.verified!, true);
      if (agentHomeState.verifiedStudents?.isEmpty ?? false) {
        var studentHome = await ProfileTestSuite().getStudentHome();
        final student = ((studentHome).student)!;
        expect(student, isNotNull);
        agentHomeState = await (ProfileTestSuite().getAgentHome());
      }
      expect(agentHomeState.verifiedStudents!.isNotEmpty || agentHomeState.applications!.isNotEmpty, true);
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
  Future<Student?> getStudentProfile() async {
    StudentHomeState studentHomeData = await getStudentHome();
    final student = studentHomeData.student;

    return student;
  }

  Future<StudentHomeState> getStudentHome([HomeBloc? bloc]) async {
    final mockAuth = MockFirebaseAuth('student');
    var homeBloc = HomeBloc()..setCountry('CA', 'student');
    var studentHomeData =
        await (bloc ?? homeBloc).getStudentHome(firebaseAuth: mockAuth);
    if (!studentHomeData.student!.verified!) {
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

  Future<Agent?> getAgentProfile() async {
    AgentHomeState agentHomeData = await getAgentHome();
    final agent = agentHomeData.agent;
    return agent;
  }

  Future<AgentHomeState> getAgentHome([HomeBloc? bloc]) async {
    final mockAuth = MockFirebaseAuth('agent');
    var homeBloc = bloc ?? HomeBloc()
      ..setCountry('CA', 'agent');
    var agentHomeData = await homeBloc.getAgentHome(auth: mockAuth);
    if (!agentHomeData.agent!.verified!) {
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
