import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/partial_views/challans_view/challans_view.dart';
import 'package:uet_lms/ui/partial_views/home_view/home_view.dart';
import 'package:uet_lms/ui/partial_views/lms_settings_view/lms_settings_view.dart';

class MainViewModel extends BaseViewModel {

  List<Widget> views = [
    DashBoardView(),
    LMSSettingsView(),
    ChallansView()
  ];
  
}