import 'package:elite_counsel/pages/usertype_select/usertype_select_page.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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
