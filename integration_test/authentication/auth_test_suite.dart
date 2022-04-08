import 'package:elite_counsel/pages/usertype_select/student_select_button.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:elite_counsel/main.dart' as app;
import 'package:integration_test/integration_test.dart';

import '../app_start.dart';

class AuthenticationTestSuite {
  Future<WidgetTester> loginWithPhoneNumber(WidgetTester tester,
      {bool autoSignIn}) async {
    tester = await AppStartSuite().startApp(tester, autoSignIn: true);

    await tester.pumpAndSettle();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Integration Tests:', () {
    testWidgets('Login With Phone number/OTP', (tester) async {
      final authTestSuite = AuthenticationTestSuite();
      await authTestSuite.loginWithPhoneNumber(tester, autoSignIn: true);
      await tester.tap(find.text('Australia'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Next'));

      await tester.pumpAndSettle();
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
    });
  });
}
