import 'package:elite_counsel/bloc/profile_bloc.dart';
import 'package:elite_counsel/models/agent.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import '../utils/setups.dart';
import 'profile_test.dart';

void main() {
 
  group('Profile Update:', () {
    test('agent', () async {
      var agent = await ProfileTestSuite().getAgentProfile();
      var _name = 'test_agent_name_' + Uuid().v4();
      agent.name = _name;
      var response = await ProfileBloc.setAgentProfile(agent);
      expect(response.statusCode, 200);
      agent = await ProfileTestSuite().getAgentProfile();
      expect(agent.name, _name);
    });

    test('student', () async {
      var student = await ProfileTestSuite().getStudentProfile();
      var _name = 'test_student_name_' + Uuid().v4();
      student.name = _name;
      var response = await ProfileBloc.updateStudentProfile(student);
      expect(response.statusCode, 200);
      student = await ProfileTestSuite().getStudentProfile();
      expect(student.name, _name);
    });
  });
}
