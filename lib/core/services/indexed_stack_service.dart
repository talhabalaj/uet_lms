import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:uet_lms/ui/partial_views/challans_view/challans_view.dart';
import 'package:uet_lms/ui/partial_views/dmc_view/dmc_view.dart';
import 'package:uet_lms/ui/partial_views/home_view/home_view.dart';
import 'package:uet_lms/ui/partial_views/lms_settings_view/lms_settings_view.dart';

@lazySingleton
class IndexedStackService {
  int _index = 0;
  List<Widget> currentViews = [];
  List<Widget> browsed = [];
  List<Widget> views = [
    DashBoardView(),
    LMSSettingsView(),
    ChallansView(),
    DMCView()
  ];

  get index => _index;
  set index(int idx) {
    _index = idx;
    _addCurrentToBrowsed();
    updateViews();
  }

  void _addCurrentToBrowsed() => browsed.add(views[index]);

  IndexedStackService() {
    _addCurrentToBrowsed();
    updateViews();
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
