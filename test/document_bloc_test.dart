import 'package:elite_counsel/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'mocks/firebase_auth_mock.dart';

void main() {
  group('Document Operations:', () {
    test('Document Upload', () async {
      await Hive.initFlutter();
      await Hive.openBox("myBox");

      final mockAuth = MockFirebaseAuth();
      final studentHomeData =
          await HomeBloc.getStudentHome(firebaseAuth: mockAuth);
      final student = studentHomeData.self;
      assert(student.id.isNotEmpty);

      /// TODO(dhruvd0) : pick a test file and convert it to [PlatformFile]
      // final pickerResult = FilePickerResult();
    });
  });
}
