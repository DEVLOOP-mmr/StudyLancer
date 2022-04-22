import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:elite_counsel/variables.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:elite_counsel/main.dart' as app;
import 'package:mockito/mockito.dart';

class AppStartSuite {
  Future<WidgetTester> startApp(WidgetTester tester, String userType,
      {bool autoSignIn,}) async {
    autoSignIn = autoSignIn ?? false;
    await Hive.initFlutter();
    await Hive.openBox("myBox");
    await Variables.sharedPreferences.clear();

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if (autoSignIn) {
      await Variables.sharedPreferences.put(Variables.userType, userType);

      await _authenticateWithMockUser(tester, userType);
    } else {
      await FirebaseAuth.instance.signOut();
      await app.main();
      await tester.pumpAndSettle();
    }

    return tester;
  }

  Future<void> _authenticateWithMockUser(
      WidgetTester tester, String userType) async {
    final mockUser = userType == Variables.userTypeStudent
        ? MockFirebaseStudentUser()
        : MockFirebaseAgentUser();
    debugPrint("\n\n $userType" ":" + mockUser.uid +"\n\n");
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: mockUser.phoneNumber,
      verificationFailed: (error) {},
      verificationCompleted: (phoneAuthCredential) {},
      codeAutoRetrievalTimeout: (verificationId) {},
      codeSent: (verifyID, token) async {
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verifyID,
          smsCode: mockUser.otp,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
      },
    );

    await Future.doWhile(() async {
      await tester.pump();
      return FirebaseAuth.instance.currentUser == null;
    });
    await app.main();
    await tester.pumpAndSettle();
  }
}
