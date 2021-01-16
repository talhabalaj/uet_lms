import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uet_lms/ui/ui_constants.dart';

@lazySingleton
class ThemeService {
  String _currentTheme;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentTheme = prefs.getString("theme") ?? "light";
  }

  Future<void> setTheme(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", name);
    _currentTheme = name;
  }

  static Map<String, ThemeData> themes = {
    "light": ThemeData(
        backgroundColor: Colors.grey[100],
        cardColor: Colors.white,
        primaryColor: kPrimaryColor,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        scaffoldBackgroundColor: Colors.grey[100],

        textTheme: TextTheme(
          headline1: kDefaultTextStyle.copyWith(
              fontWeight: FontWeight.bold, fontSize: 34),
          headline2: kDefaultTextStyle.copyWith(
              fontWeight: FontWeight.bold, fontSize: 24),
          headline3: kDefaultTextStyle.copyWith(
              fontWeight: FontWeight.w700, fontSize: 22),
          headline4: kDefaultTextStyle.copyWith(
              fontWeight: FontWeight.w700, fontSize: 18),
          bodyText1: kDefaultTextStyle.copyWith(
              fontSize: 16, fontWeight: FontWeight.w400),
          bodyText2: kDefaultTextStyle.copyWith(
              fontSize: 12, fontWeight: FontWeight.w400),
          headline5: kDefaultTextStyle.copyWith(
              fontWeight: FontWeight.w600, fontSize: 14),
          subtitle1: kDefaultTextStyle.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Colors.grey[400]),
        ),
        fontFamily: 'Inter'),
    "dark": ThemeData(
        backgroundColor: Colors.black,
        primaryColor: Colors.white,
        cardColor: Color(0xff141414),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(
          headline1: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 34),
          headline2: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          headline3: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 22),
          headline4: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
          bodyText1: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
          bodyText2: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
          headline5: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          subtitle1: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: Colors.grey[400]),
        ),
        fontFamily: 'Inter'),
  };

  ThemeData get theme => themes[_currentTheme];
  String get themeName => _currentTheme;
}
