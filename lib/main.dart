import 'package:device_preview/device_preview.dart';
import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/pages/country_select_page.dart';
import 'package:elite_counsel/pages/home_page/home_page.dart';
import 'package:elite_counsel/pages/usertype_select/usertype_select_page.dart';
import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'widgets/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DevicePreview(
    builder: (context) => MaterialApp(home: const MyApp()),
    enabled: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> _initDone;

  Future<bool> deviceInit() async {
    await Firebase.initializeApp();
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
          return BlocProvider(
            create: (context) => HomeBloc(),
            child: MaterialApp(
              themeMode: ThemeMode.light,
              color: Variables.accentColor,
              theme: MyTheme.lightTheme(context),
              debugShowCheckedModeBanner: true,
              builder: EasyLoading.init(),
              home: home,
            ),
          );
        });
  }
}
