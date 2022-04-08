import 'package:elite_counsel/pages/usertype_select/student_select_button.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:elite_counsel/main.dart' as app;
import 'package:integration_test/integration_test.dart';

import '../app_start.dart';

class AuthenticationTestSuite {
  Future<WidgetTester> loginWithPhoneNumber(WidgetTester tester) async {
    tester = await AppStartSuite().startApp(tester);
   
    await tester.pumpAndSettle();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Integration Tests:', () {
    testWidgets('Login With Phone number/OTP', (tester) async {
      final authTestSuite = AuthenticationTestSuite();
      await authTestSuite.loginWithPhoneNumber(tester);
    });
  });
}
