import 'dart:async';

import 'package:device_preview/device_preview.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/notification_bloc/notification_bloc.dart';
import 'package:elite_counsel/chat/backend/firebase_chat_bloc/firebase_chat_bloc.dart';
import 'package:elite_counsel/pages/country_select_page.dart';
import 'package:elite_counsel/pages/home_page/home_page.dart';
import 'package:elite_counsel/pages/usertype_select/usertype_select_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'widgets/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    runApp(DevicePreview(
      builder: (context) => const MaterialApp(home: MyApp()),
      enabled: false,
    ));
  } else {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runZonedGuarded<Future<void>>(
      () async {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

        runApp(DevicePreview(
          builder: (context) => const MaterialApp(home: MyApp()),
          enabled: false,
        ));
      },
      (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool>? _initDone;

  Future<bool> deviceInit() async {
    await Hive.initFlutter();
    await Hive.openBox("myBox");

    return true;
  }

  @override
  void initState() {
    super.initState();
    _initDone = deviceInit();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _initDone,
      builder: (context, snapshot) {
        Widget home = const Center(
          child: CircularProgressIndicator(),
        );
        if (snapshot.hasError) {
          home = Center(
            child: Text(snapshot.error.toString()),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          home = FirebaseAuth.instance.currentUser != null
              ? Variables.sharedPreferences.get(Variables.countryCode) != null
                  ? const HomePage()
                  : const CountrySelectPage()
              : const UserTypeSelectPage();
        }

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => HomeBloc(),
            ),
            BlocProvider(
              lazy: false,
              create: (context) =>
                  FirebaseChatBloc(homeBloc: context.read<HomeBloc>()),
            ),
            BlocProvider(
              lazy: false,
              create: (context) => NotificationCubit(),
            ),
          ],
          child: MaterialApp(
            themeMode: ThemeMode.light,
            color: Variables.accentColor,
            theme: MyTheme.lightTheme(context),
            debugShowCheckedModeBanner: true,
            builder: EasyLoading.init(),
            home: home,
          ),
        );
      },
    );
  }
}
