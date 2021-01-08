import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/nested_navigation_service.dart';
import 'package:uet_lms/core/services/lms_service.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:uet_lms/ui/dialog.dart';

class LMSSettingsViewModel extends BaseViewModel {
  String currentPassword;
  String newPassword;
  String confirmPassword;
  final formKey = GlobalKey<FormState>();

  final lmsService = locator<LMSService>();
  final dialogService = locator<DialogService>();

  final updatingProfilePic = 'UPDATING';
  final removingProfilePic = 'REMOVING';

  get dpChangeTimes => locator<NestedNavigationService>().dpChangeTimes;
  void incrementDpChangeTimes() =>
      locator<NestedNavigationService>().dpChangeTimes++;

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

  Future<void> updateProfilePicture() async {
    this.setBusyForObject(updatingProfilePic, true);
    final image = await openImage();
    if (image != null) {
      await lmsService.user.updateProfilePicture(image);
      incrementDpChangeTimes();
    }
    this.setBusyForObject(updatingProfilePic, false);
  }

  Future<void> removeProfilePic() async {
    this.setBusyForObject(removingProfilePic, true);
    await lmsService.user.updateProfilePicture();
    incrementDpChangeTimes();
    this.setBusyForObject(removingProfilePic, false);
  }
}
