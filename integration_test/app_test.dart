import 'package:elite_counsel/pages/usertype_select_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:elite_counsel/main.dart' as app;


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'App Start',
    (tester) async {
      await Hive.initFlutter();
      await Hive.openBox("myBox");
      await Variables.sharedPreferences.clear();
      await app.main();

      await tester.pumpAndSettle();
      expect(find.byType(UserTypeSelectPage), findsOneWidget);
    },
  );
}

