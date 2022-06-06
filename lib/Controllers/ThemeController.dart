// ignore_for_file: file_names, prefer_const_constructors
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeController, ThemeData>((ref) {
  return ThemeController();
});

class ThemeController extends StateNotifier<ThemeData> {
  static final ThemeData lightTheme = ThemeData(
      fontFamily: "Poppins",
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6:
            TextStyle(fontSize: 36.0, fontWeight: FontWeight.w600, height: 0.8),
        bodyText2: TextStyle(fontSize: 14.0, color: Color(0xFF282828)),
      ),
      colorScheme: ColorScheme(
          primary: Color(0xFF282828),
          secondary: Color(0xFF48c75c),
          surface: Color(0xFFF4F4F4),
          background: Color(0xFFFAFAFA),
          error: Color.fromARGB(255, 255, 0, 47),
          onPrimary: Color(0xFFABABAB),
          onSecondary: Color(0xFF48c75c),
          onSurface: Color(0xFF48c75c),
          onBackground: Color(0xFFFAFAFA),
          onError: Color(0xFFB00020),
          brightness: Brightness.light),
      appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF282828),
          foregroundColor: Color(0xFFFAFAFA)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Color(0xFFFAFAFA),
          backgroundColor: Color(0xFF48C75C)),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Color(0xFF48C75C)),
              foregroundColor: MaterialStateColor.resolveWith(
                  (states) => Color(0xFFFAFAFA)))));
  static final ThemeData darkTheme = ThemeData(
      fontFamily: "Poppins",
      textTheme: const TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6:
            TextStyle(fontSize: 36.0, fontWeight: FontWeight.w600, height: 0.8),
        bodyText2: TextStyle(fontSize: 14.0, color: Color(0xFFFAFAFA)),
      ),
      colorScheme: ColorScheme(
          primary: Color(0xFFFAFAFA),
          secondary: Color(0xFF48c75c),
          surface: Color(0xFF282828),
          background: Color(0xFF181818),
          error: Color.fromARGB(255, 255, 0, 47),
          onPrimary: Color(0xFFFAFAFA),
          onSecondary: Color(0xFF48c75c),
          onSurface: Color(0xFF48c75c),
          onBackground: Color(0xFF181818),
          onError: Color(0xFFB00020),
          brightness: Brightness.dark),
      appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF282828),
          foregroundColor: Color(0xFFFAFAFA)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Color(0xFFFAFAFA),
          backgroundColor: Color(0xFF48C75C)),
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateColor.resolveWith((states) => Color(0xFF48C75C)),
              foregroundColor: MaterialStateColor.resolveWith(
                  (states) => Color(0xFFFAFAFA)))));

  ThemeController() : super(lightTheme) {
    SharedPreferences? prefs;
    var brightness = SchedulerBinding.instance!.window.platformBrightness;

    () async {
      prefs = await SharedPreferences.getInstance();
      bool? theme = prefs!.getBool("theme");
      if (theme != null) {
        state = theme == true ? lightTheme : darkTheme;
      } else {
        state = brightness == Brightness.dark ? darkTheme : lightTheme;
      }
    }();
  }

  void switchTheme() async {
    state = state == lightTheme ? darkTheme : lightTheme;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool lightThemeBool = state == lightTheme ? true : false;
    prefs.setBool("theme", lightThemeBool);
  }
}
