import 'package:flutter/material.dart';

final kFavBoxShadow = BoxShadow(
  offset: Offset(0, 1),
  blurRadius: 19,
  color: Colors.black.withOpacity(0.06),
  spreadRadius: 0,
);

final kPrimaryColor = Color(0xff484848);
final kDefaultTextStyle = TextStyle(color: kPrimaryColor);
final kHorizontalSpacing = 25.0;

ThemeData getTheme() {
  return ThemeData(
      backgroundColor: Colors.grey[50],
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: Colors.grey[50],
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
            fontWeight: FontWeight.w600, fontSize: 13),
        subtitle1: kDefaultTextStyle.copyWith(
            fontWeight: FontWeight.w700, fontSize: 12, color: Colors.grey[400]),
      ),
      fontFamily: 'Inter');
}
