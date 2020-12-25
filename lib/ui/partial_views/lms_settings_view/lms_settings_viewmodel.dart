import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';
import 'package:uet_lms/ui/dialog.dart';

class LMSSettingsViewModel extends BaseViewModel {
  String currentPassword;
  String newPassword;
  String confirmPassword;
  final formKey = GlobalKey<FormState>();

  final lmsService = locator<LMSService>();
  final dialogService = locator<DialogService>();

  Future<void> changePassword() async {
    this.setBusy(true);
    if (formKey.currentState.validate()) {
      await lmsService.user.changePassword(currentPassword, newPassword);
      await lmsService.storeOnSecureStorage();
      formKey.currentState.reset();
      await dialogService.showCustomDialog(
          variant: DialogType.basic,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          title: "Password changed Successfully",
          description: "We hope you set a good for your account, Be secure.");
    }
    this.setBusy(false);
  }
}
