import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:elite_counsel/variables.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:elite_counsel/main.dart' as app;

class AppStartSuite {
  Future<WidgetTester> startApp(WidgetTester tester) async {
    await Hive.initFlutter();
    await Hive.openBox("myBox");
    await Variables.sharedPreferences.clear();
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseAuth.instance.signOut();
    await app.main();
    await tester.pumpAndSettle();

    return tester;
  }
}
