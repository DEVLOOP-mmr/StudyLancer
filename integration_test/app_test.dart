import 'package:elite_counsel/pages/country_select_page.dart';
import 'package:elite_counsel/pages/usertype_select/usertype_select_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:elite_counsel/main.dart' as app;

import 'app_start.dart';
import 'authentication/auth_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'App Start',
    (tester) async {
      await AppStartSuite().startApp(tester, 'student');
      expect(find.byType(UserTypeSelectPage), findsOneWidget);
    },
  );

  group('Authentication Integration Tests:', () {
    AuthenticationTestSuite().authTestGroup();
  });
}
