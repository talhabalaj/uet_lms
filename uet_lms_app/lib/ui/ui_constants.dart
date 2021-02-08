import 'package:flutter/material.dart';
import 'package:uet_lms/core/models/NestedRoute.dart';

final kFavBoxShadow = BoxShadow(
  offset: Offset(0, 1),
  blurRadius: 10,
  color: Colors.black.withAlpha(10),
  spreadRadius: 0,
);

final kPrimaryColor = Color(0xff484848);
final kDefaultTextStyle = TextStyle(color: kPrimaryColor);
final kHorizontalSpacing = 20.0;
final kAppBarHeight = 90.0;

List<NestedRoute> kMainViewNestedNavLinks = [
  NestedRoute(
      "Dashboard",
      "/dashboard",
      "See at a glance what’s up with your University, Current semester, CGPA, etc",
      ""),
  NestedRoute("Offered Subjects", null,
      "Register subjects you want to study for the current semester", "ACADEMIC"),
  NestedRoute(
      "Registered Subjects",
      null,
      "The subjects you registered in your University from the start.",
      "ACADEMIC"),
  NestedRoute(
      "DMC",
      "/dmc",
      "Check your grades and stuff. you know the usual, best of luck tho",
      "ACADEMIC"),
  NestedRoute("Fee Challans", "/challans",
      "Check if your fees is paid or new challan form is available", "DUES"),
  NestedRoute("Student Profile", null,
      "Check the information, University has on you.", "INFORMATION"),
  NestedRoute(
      "GPA Estimator",
      "/gpa_estimator",
      "Estimate your GPA and CGPA by plotting your expected result",
      "TOOLS",
      true),
  NestedRoute("App Settings", "/app_settings",
      "The usual thing to have in an app", "SETTINGS"),
  NestedRoute("LMS Settings", "/lms_settings",
      "Change you profile picture or password, or both", "SETTINGS"),
];
