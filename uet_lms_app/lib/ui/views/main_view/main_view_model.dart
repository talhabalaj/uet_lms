import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/NestedNavigationService.dart';
import 'package:uet_lms/core/services/AuthService.dart';

class MainViewModel extends BaseViewModel {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService lmsService = I<AuthService>();
  final NestedNavigationService indexedStackService =
      I<NestedNavigationService>();

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

  Future<void> requestReview() async {
    //final InAppReview inAppReview = InAppReview.instance;

    // if (await inAppReview.isAvailable()) {
    //   inAppReview.requestReview();
    // }
  }
}
