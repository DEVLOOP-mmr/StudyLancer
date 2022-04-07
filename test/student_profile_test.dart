import 'package:elite_counsel/bloc/home_bloc.dart';
import 'package:elite_counsel/models/student.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'mocks/firebase_auth_mock.dart';
import 'utils/setups.dart';

void main() {
  try {
    setUp(() async {
      try {
        await TestSetups().setupHive();
      }  catch (e) {
        // TODO
      }
    });
  }  catch (e) {
    // TODO
  }
  test('Test To fetch student data', () async {
    final student = await StudentProfileTestSuite.getStudentProfile();
    expect(student.id, MockFirebaseUser().uid);
    expect(student.phone, MockFirebaseUser().phoneNumber);
  });
}

class StudentProfileTestSuite {
  static Future<Student> getStudentProfile() async {
    final mockAuth = MockFirebaseAuth();
    final studentHomeData =
        await HomeBloc.getStudentHome(firebaseAuth: mockAuth);
    final student = studentHomeData.self;
    return student;
  }
}
