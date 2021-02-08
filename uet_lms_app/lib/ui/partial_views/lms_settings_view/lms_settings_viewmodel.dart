import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/NestedNavigationService.dart';
import 'package:uet_lms/core/services/AuthService.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:uet_lms/ui/dialog.dart';

class LMSSettingsViewModel extends BaseViewModel {
  String currentPassword;
  String newPassword;
  String confirmPassword;
  final formKey = GlobalKey<FormState>();

  final authService = I<AuthService>();
  final dialogService = I<DialogService>();

  final updatingProfilePic = 'UPDATING';
  final removingProfilePic = 'REMOVING';

  get dpChangeTimes => I<NestedNavigationService>().dpChangeTimes;
  void incrementDpChangeTimes() => I<NestedNavigationService>().dpChangeTimes++;

  Future<void> changePassword() async {
    this.setBusy(true);
    if (formKey.currentState.validate()) {
      try {
        await authService.user.changePassword(currentPassword, newPassword);
        formKey.currentState.reset();
        await authService.storeOnSecureStorage();
        await dialogService.showCustomDialog(
          variant: DialogType.basic,
          barrierColor: Colors.black38,
          barrierDismissible: true,
          title: "Password changed Successfully",
          description: "We hope you set a good for your account, Be secure.",
        );
      } catch (e, s) {
        onlyCatchLMSorInternetException(e, stackTrace: s);
      }
    }
    this.setBusy(false);
  }

  Future<void> updateProfilePicture() async {
    this.setBusyForObject(updatingProfilePic, true);
    final image = await openImage();
    if (image != null) {
      try {
        await authService.user.updateProfilePicture(image);
        incrementDpChangeTimes();
      } catch (e, s) {
        onlyCatchLMSorInternetException(e, stackTrace: s);
      }
    }
    this.setBusyForObject(updatingProfilePic, false);
  }

  Future<void> removeProfilePic() async {
    this.setBusyForObject(removingProfilePic, true);
    try {
      await authService.user.updateProfilePicture();
      incrementDpChangeTimes();
    } catch (e, s) {
      onlyCatchLMSorInternetException(e, stackTrace: s);
    }
    this.setBusyForObject(removingProfilePic, false);
  }
}
