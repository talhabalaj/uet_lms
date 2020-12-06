import 'package:flutter/material.dart';
import 'package:lms_api/LMS.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';
import 'package:uet_lms/ui/dialog.dart';
import 'package:uet_lms/ui/views/login_view/login_view.dart';

class HomeViewModel extends BaseViewModel {
  final lmsService = locator<LMSService>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final NavigationService navigationService = locator<NavigationService>();
  final DialogService dialogService = locator<DialogService>();

  ScaffoldState get scaffold => scaffoldKey.currentState;
  LMS get user => lmsService.user;

  Future<void> logout() async {
    DialogResponse r = await dialogService.showCustomDialog(
      variant: DialogType.basic,
      mainButtonTitle: "I'm sure",
      secondaryButtonTitle: "Oh mistakenly",
      title: "Are you sure?",
      description: "We hate to see you go, Please come back soon. ",
    );

    if (r.confirmed) {
      await lmsService.logout();
      await navigationService.clearStackAndShow(LoginView.id);
    }
  }
}
