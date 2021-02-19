import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:uet_lms/core/models/UserPreferences.dart';
import 'package:uet_lms/core/services/PreferencesService.dart';
import 'package:uet_lms/ui/ui_constants.dart';

import '../locator.dart';

@lazySingleton
class ThemeService {
  String _currentTheme;
  ThemeData theme;
  ThemeMode themeMode;

  void setThemeMode() {
    if (_currentTheme == "light") {
      themeMode = ThemeMode.light;
    } else if (_currentTheme == "dark") {
      themeMode = ThemeMode.dark;
    } else if (_currentTheme == "system") {
      themeMode = ThemeMode.system;
    }
  }

  void init() {
    _currentTheme = I<PreferencesService>().preferences.theme;
    setThemeMode();
  }

  Future<void> setTheme(String name) async {
    await I<PreferencesService>().update(UserPreferences(theme: name));
    _currentTheme = name;
    setThemeMode();
  }

  static ThemeData light = ThemeData(
    backgroundColor: Color(0xfff5f5f5),
    cardColor: Colors.white,
    primaryColor: kPrimaryColor,
    accentColor: Colors.indigo,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    scaffoldBackgroundColor: Color(0xfff5f5f5),
    brightness: Brightness.dark,
    textTheme: TextTheme(
      headline1:
          kDefaultTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 34),
      headline2:
          kDefaultTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 24),
      headline3:
          kDefaultTextStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 22),
      headline4:
          kDefaultTextStyle.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
      bodyText1:
          kDefaultTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
      bodyText2:
          kDefaultTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
      headline5:
          kDefaultTextStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
      subtitle1: kDefaultTextStyle.copyWith(
          fontWeight: FontWeight.w700, fontSize: 12, color: Colors.grey[400]),
    ),
    fontFamily: 'Inter',
  );

  static ThemeData dark = ThemeData(
    backgroundColor: Color(0xff101010),
    primaryColor: Colors.white,
    cardColor: Color(0xff202020),
    accentColor: Colors.amber,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    scaffoldBackgroundColor: Color(0xff101010),
    brightness: Brightness.light,
    fontFamily: 'Inter',
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
          fontWeight: FontWeight.w700, fontSize: 12, color: Colors.grey[400]),
    ),
  );
  
  String get themeName => _currentTheme;
}
