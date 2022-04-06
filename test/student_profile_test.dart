import 'package:elite_counsel/bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'mocks/firebase_auth_mock.dart';

void main() {
  test('Test To fetch student data', ()  async{
    await Hive.initFlutter();
    await Hive.openBox("myBox");
    
    final mockAuth = MockFirebaseAuth();
    await HomeBloc.getStudentHome(firebaseAuth: mockAuth);
  });
}
