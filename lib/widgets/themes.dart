import 'package:elite_counsel/variables.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static Map<int, Color> color = {
    50: Variables.accentColor.withOpacity(0.1),
    100: Variables.accentColor.withOpacity(0.2),
    200: Variables.accentColor.withOpacity(0.3),
    300: Variables.accentColor.withOpacity(0.4),
    400: Variables.accentColor.withOpacity(0.5),
    500: Variables.accentColor.withOpacity(0.6),
    600: Variables.accentColor.withOpacity(0.7),
    700: Variables.accentColor.withOpacity(0.8),
    800: Variables.accentColor.withOpacity(0.9),
    900: Variables.accentColor,
  };
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      primarySwatch: MaterialColor(0xffFFAC97, color),
      // fontFamily: 'metropolis',
      appBarTheme: AppBarTheme(
        color: Colors.white,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Color(0xffFFAC97)),
        toolbarTextStyle: Theme.of(context).textTheme.bodyText2,
        titleTextStyle: Theme.of(context).textTheme.headline6,
      ));
}
