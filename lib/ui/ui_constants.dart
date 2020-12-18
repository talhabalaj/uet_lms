import 'package:flutter/material.dart';
import 'package:uet_lms/ui/partial_views/challans_view/challans_view.dart';
import 'package:uet_lms/ui/partial_views/dmc_view/dmc_view.dart';
import 'package:uet_lms/ui/partial_views/home_view/home_view.dart';
import 'package:uet_lms/ui/partial_views/lms_settings_view/lms_settings_view.dart';

final kFavBoxShadow = BoxShadow(
  offset: Offset(0, 1),
  blurRadius: 19,
  color: Colors.black.withOpacity(0.06),
  spreadRadius: 0,
);

final kPrimaryColor = Color(0xff484848);
final kDefaultTextStyle = TextStyle(color: kPrimaryColor);
final kHorizontalSpacing = 25.0;
final kAppBarHeight = 80.0;

ThemeData getTheme() {
  return ThemeData(
      backgroundColor: Colors.grey[100],
      primaryColor: kPrimaryColor,
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
            fontWeight: FontWeight.w700, fontSize: 12, color: Colors.grey[400]),
      ),
      fontFamily: 'Inter');
}

// TODO: mention screen name instead
List<Map<String, dynamic>> kNavLinks = [
  {
    "name": "",
    "children": [
      {
        "name": "Dashboard",
        "screen": DashBoardView(),
        "description":
            "See at a glance what’s up with your University, Current semester, CGPA, etc"
      },
    ],
  },
  {
    "name": "ACADEMIC",
    "children": [
      {
        "name": "Register subjects",
        "description": "Register subjects you want to study in this semester"
      },
      {
        "name": "DMC",
        "screen": DMCView(),
        "description":
            "Check your grades and stuff. you can the usual, best of luck tho"
      },
    ],
  },
  {
    "name": "DUES",
    "children": [
      {
        "name": "Fee Challans",
        "description":
            "Check if your fees is paid or new challan form is available",
        "screen": ChallansView(),
      },
    ],
  },
  {
    "name": "INFORMATION",
    "children": [
      {
        "name": "Student Profile",
        "description": "Check the information, University has on you."
      },
    ],
  },
  {
    "name": "SETTINGS",
    "children": [
      {
        "name": "App Settings",
        "description": "The usual thing to have in an app"
      },
      {
        "name": "LMS Settings",
        "description": "Change you profile picture, password and other stuff",
        "screen": LMSSettingsView()
      },
    ],
  },
];
