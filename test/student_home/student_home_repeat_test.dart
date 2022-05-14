import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../profile/profile_test.dart';

void main() {
  test('Test To fetch agent home twice', () async {
    var home = HomeBloc();
    await ProfileTestSuite().getStudentHome(home);
    await ProfileTestSuite().getStudentHome(home);
  },skip: true);
}
