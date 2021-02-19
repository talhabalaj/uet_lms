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

import '../locator.dart';

@lazySingleton
class NestedNavigationService {

  final routeObserver = FirebaseAnalyticsObserver(
    analytics: I<FirebaseAnalytics>(),
  );

  int _index = 0;
  int dpChangeTimes = 0;
  List<Widget> currentViews = [];
  List<Widget> browsed = [];
  List<Widget> views = [
    DashBoardView(),
    LMSSettingsView(),
    ChallansView(),
    GPAEstimatorView(),
    DMCView(),
    AppSettingsView(),
  ];

  get index => _index;
  set index(int idx) {
    _index = idx;
    _addCurrentToBrowsed();
    updateViews();
    _setScreenName();
  }

  void _setScreenName() {
    routeObserver.analytics.setCurrentScreen(screenName: '/${(currentViews[index] as dynamic).id}');
  }

  void _addCurrentToBrowsed() => browsed.add(views[index]);

  NestedNavigationService() {
    _addCurrentToBrowsed();
    updateViews();
    _setScreenName();
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
    index = 0;
  }

  bool isCurrent(String screenName) {
    return (currentViews[index] as dynamic).id == screenName;
  }
}
