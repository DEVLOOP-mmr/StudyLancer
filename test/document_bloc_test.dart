import 'package:elite_counsel/bloc/home_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';

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
    });
  });
 
}
