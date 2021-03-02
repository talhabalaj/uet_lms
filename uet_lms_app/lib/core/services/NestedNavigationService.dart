import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:uet_lms/ui/partial_views/app_settings_view/app_settings_view.dart';
import 'package:uet_lms/ui/partial_views/challans_view/challans_view.dart';
import 'package:uet_lms/ui/partial_views/dmc_view/dmc_view.dart';
import 'package:uet_lms/ui/partial_views/gpa_estimator/gpa_estimator_view.dart';
import 'package:uet_lms/ui/partial_views/home_view/home_view.dart';
import 'package:uet_lms/ui/partial_views/lms_settings_view/lms_settings_view.dart';
import 'package:uet_lms/ui/partial_views/student_profile/student_profile_view.dart';

import '../locator.dart';

@lazySingleton
class NestedNavigationService {
  final routeObserver = FirebaseAnalyticsObserver(
    analytics: I<FirebaseAnalytics>(),
  );

  int _index = 0;
  int dpChangeTimes = 0;
  List<int> stack = [];
  List<Widget> currentViews = [];
  List<Widget> browsed = [];
  List<Widget> views = [
    DashBoardView(),
    LMSSettingsView(),
    ChallansView(),
    GPAEstimatorView(),
    DMCView(),
    AppSettingsView(),
    StudentProfileView()
  ];

  get index => _index;
  set index(int idx) {
    _index = idx;
    _addCurrentToBrowsed();
    updateViews();
    _setScreenName();
    if (stack.length == 0 || stack.last != idx)
      stack.add(idx);
  }

  int back() {
    if (stack.length > 1) {
      stack.removeLast();
      index = stack.last;
      return index;
    }
    return -1;
  }

  void _setScreenName() {
    routeObserver.analytics
        .setCurrentScreen(screenName: '${(currentViews[index] as dynamic).id}');
  }

  void _addCurrentToBrowsed() => browsed.add(views[index]);

  NestedNavigationService() {
    index = 0;
  }

  void updateViews() {
    currentViews.clear();
    currentViews.addAll(views.map(_mapView));
  }

  Widget _mapView(Widget view) {
    if (browsed.contains(view)) {
      return view;
    }

    return Container();
  }

  void reset() {
    browsed.clear();
    stack.clear();
    index = 0;
  }

  bool isCurrent(String screenName) {
    return (currentViews[index] as dynamic).id == screenName;
  }
}
