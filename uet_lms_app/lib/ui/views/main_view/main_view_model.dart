import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/NestedNavigationService.dart';
import 'package:uet_lms/core/services/AuthService.dart';

import '../../ui_constants.dart';

class MainViewModel extends BaseViewModel {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService lmsService = I<AuthService>();
  final NestedNavigationService indexedStackService =
      I<NestedNavigationService>();

  final AutoScrollController navScrollController = AutoScrollController();

  bool isReverse = false;
  bool _isTopBarTransparent = true;
  int scrollIdx = 0;
  int get dpChangeTimes => indexedStackService.dpChangeTimes;

  bool get isTopBarTransparent => _isTopBarTransparent;
  set isTopBarTransparent(bool value) {
    _isTopBarTransparent = value;
    this.notifyListeners();
  }

  int get index => indexedStackService.index;
  ScaffoldState get scaffold => scaffoldKey.currentState;
  List<Widget> get currentViews => indexedStackService.currentViews;
  List<Widget> get views => indexedStackService.views;

  void setActiveScreen(int _idx, String _screen) {
    scrollIdx = _idx;
    int idx = views.indexWhere((view) => (view as dynamic).id == _screen);

    if (idx != -1 && indexedStackService.index != idx) {
      indexedStackService.index = idx;
      _isTopBarTransparent = true;
      isReverse = false;
      this.notifyListeners();
    }
  }

  Future<void> requestReview() async {
    //final InAppReview inAppReview = InAppReview.instance;

    // if (await inAppReview.isAvailable()) {
    //   inAppReview.requestReview();
    // }
  }

  bool back() {
    int idx = this.indexedStackService.back();
    if (idx != -1) {
      for (int i = 0; i < kMainViewNestedNavLinks.length; i++) {
        if (kMainViewNestedNavLinks[i].screenName ==
            (views[idx] as dynamic).id) {
          scrollIdx = i;
          isReverse = true;
          this.notifyListeners();
          return true;
        }
      }
    }
    return false;
  }
}
