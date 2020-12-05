
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kFavBoxShadow = BoxShadow(
  offset: Offset(0, 1),
  blurRadius: 19,
  color: Colors.black.withOpacity(0.08),
  spreadRadius: 0,
);


final kPrimaryColor = Color(0xff484848);
final kDefaultTextStyle = TextStyle(color: kPrimaryColor);
final kHorizontalSpacing = 31.0;

final getTheme = () => ThemeData(
  backgroundColor: Colors.grey[50],
  primaryColor: kPrimaryColor,
  scaffoldBackgroundColor: Colors.grey[50],
  textTheme: TextTheme(
    headline1: kDefaultTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 36),
    headline2: kDefaultTextStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 26),
    bodyText1: kDefaultTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w400),
    bodyText2: kDefaultTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
    headline5: kDefaultTextStyle.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
  ),
  fontFamily: 'Inter'
);