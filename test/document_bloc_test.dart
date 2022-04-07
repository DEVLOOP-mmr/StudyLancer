import 'dart:developer';

import 'package:elite_counsel/bloc/document_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'mocks/document_mock.dart';
import 'mocks/firebase_auth_mock.dart';
import 'student_profile_test.dart';
import 'utils/setups.dart';

void main() {
  setUp(() async {
    await TestSetups().setupHive();
  });
  group('Document Operations:', () {
    test('Document Fetch', () async {
      final student = await StudentProfileTestSuite.getStudentProfile();
      assert(student.id.isNotEmpty);

      expect(student.otherDoc, isNotEmpty);
      expect(student.otherDoc.first.id, isNotEmpty);
    });
    test('Document Upload', () async {
      final mockDocument = MockDocument();
      final response = await DocumentBloc.postDocument(
        mockDocument,
        MockFirebaseUser().uid,
        overrideUserType: 'student',
      );

      expect(response.statusCode, 200);
      final student = await StudentProfileTestSuite.getStudentProfile();
      assert(student.id.isNotEmpty);
      expect(student.otherDoc.any((element) => element.name == mockDocument.name),
          true);
    });
  });
}
