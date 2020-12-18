import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/indexed_stack_service.dart';
import 'package:uet_lms/core/services/lms_service.dart';

class MainViewModel extends BaseViewModel {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final LMSService lmsService = locator<LMSService>();
  final IndexedStackService indexedStackService =
      locator<IndexedStackService>();

  get index => indexedStackService.index;
  get scaffold => scaffoldKey.currentState;
  get currentViews => indexedStackService.currentViews;
  get views => indexedStackService.views;

  void setIndex(int idx) {
    indexedStackService.index = idx;
    this.notifyListeners();
  }
}
