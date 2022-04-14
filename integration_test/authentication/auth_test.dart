import 'dart:developer';

import 'package:elite_counsel/pages/country_select_page.dart';
import 'package:elite_counsel/test_config/mocks/firebase_auth_mock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../app_start.dart';

class AuthenticationTestSuite {
  Future<WidgetTester> loginWithPhoneNumber(
    WidgetTester tester,
    String userType, {
    bool autoSignIn,
  }) async {
    tester = await AppStartSuite().startApp(
      tester,
      userType,
      autoSignIn: autoSignIn,
    );
    if (autoSignIn ?? false) {
      return tester;
    }
    await tester.tap(find.text(userType == 'student' ? 'Student' : 'Agent'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    final mockUser = userType == 'student'
        ? MockFirebaseStudentUser()
        : MockFirebaseAgentUser();
    await tester.enterText(find.byType(IntlPhoneField),
        mockUser.phoneNumber.replaceFirst('+91', ''));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get OTP'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('otp-input')), mockUser.otp);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    expect(find.textContaining(mockUser.otp), findsOneWidget);
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();
    return tester;
  }

  void authTestGroup() {
    group(
      'Login With Phone number/OTP for :',
      () {
        testWidgets(
          'student',
          (tester) async {
            tester = await loginWithPhoneNumber(tester, 'student',
                autoSignIn: false);
            await tester.pumpAndSettle();
            expect(find.byType(CountrySelectPage), findsOneWidget);
            await navigateToHomePage(tester);
          },
        );
        testWidgets(
          'agent',
          (tester) async {
            tester =
                await loginWithPhoneNumber(tester, 'agent', autoSignIn: false);
            await tester.pumpAndSettle();
            expect(find.byType(CountrySelectPage), findsOneWidget);
            await navigateToHomePage(tester);
          },
        );
      },
      skip: true,
    );

    group('Auto Login Tests for', () {
      testWidgets(
        'student',
        (tester) async {
          tester = await loginWithPhoneNumber(
            tester,
            'student',
            autoSignIn: true,
          );
          await tester.pumpAndSettle();
          expect(find.byType(CountrySelectPage), findsOneWidget);
          await navigateToHomePage(tester);
        },
        skip: true,
      );
      testWidgets(
        'agent',
        (tester) async {
          tester = await loginWithPhoneNumber(
            tester,
            'agent',
            autoSignIn: true,
          );
          await tester.pumpAndSettle();
          expect(find.byType(CountrySelectPage), findsOneWidget);
          await navigateToHomePage(tester);
        },
      );
    });
  }

  Future<void> navigateToHomePage(WidgetTester tester) async {
    await tester.tap(find.text('Canada'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    try {
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
    } catch (e) {
      log('skip button not found');
    }

    expect(find.text('Study Lancer'), findsOneWidget);
    await tester.pumpAndSettle();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    try {
      await Hive.initFlutter();
      if (!Hive.isBoxOpen('myBox')) {
        await Hive.openBox('myBox');
      }
    } catch (e) {
      debugPrint('file locked');
    }
  });
  group('Auth Tests', () {
    AuthenticationTestSuite().authTestGroup();
  });
}
