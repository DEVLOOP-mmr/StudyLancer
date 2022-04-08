import 'package:elite_counsel/pages/country_select_page.dart';
import 'package:elite_counsel/pages/usertype_select/student_select_button.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:elite_counsel/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../app_start.dart';

class AuthenticationTestSuite {
  Future<WidgetTester> loginWithPhoneNumber(
    WidgetTester tester,
    String userType, {
    bool autoSignIn,
  }) async {
    tester = await AppStartSuite().startApp(
      tester,
      Variables.userTypeStudent,
      autoSignIn: autoSignIn,
    );
    if (autoSignIn ?? false) {

      return tester;
    }
    await tester.tap(find.text('Student'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    final mockUser = MockFirebaseStudentUser();
    await tester.enterText(find.byType(IntlPhoneField), '1111111111');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get OTP'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(PinFieldAutoFill), mockUser.otp);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();
    return tester;
  }

  void authTestGroup() {
    testWidgets('Login With Phone number/OTP', (tester) async {
      await loginWithPhoneNumber(tester, 'student', autoSignIn: false);

      expect(find.byType(CountrySelectPage), findsOneWidget);
    });

    // testWidgets('Auto Login', (tester) async {
    //   await loginWithPhoneNumber(
    //     tester,
    //     'student',
    //     autoSignIn: true,
    //   );
    //   expect(find.byType(CountrySelectPage), findsOneWidget);
    // });
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Auth Tests', () {
    AuthenticationTestSuite().authTestGroup();
  });
}
