import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/nested_navigation_service.dart';
import 'package:uet_lms/core/services/lms_service.dart';

class MainViewModel extends BaseViewModel {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final LMSService lmsService = locator<LMSService>();
  final NestedNavigationService indexedStackService =
      locator<NestedNavigationService>();

  bool _isTopBarTransparent = true;
  get dpChangeTimes => indexedStackService.dpChangeTimes;

  get isTopBarTransparent => _isTopBarTransparent;
  set isTopBarTransparent(bool value) {
    _isTopBarTransparent = value;
    this.notifyListeners();
  }

  get index => indexedStackService.index;
  get scaffold => scaffoldKey.currentState;
  get currentViews => indexedStackService.currentViews;
  get views => indexedStackService.views;

  void setIndex(int idx) {
    indexedStackService.index = idx;
    _isTopBarTransparent = true;
    this.notifyListeners();
  }
}
