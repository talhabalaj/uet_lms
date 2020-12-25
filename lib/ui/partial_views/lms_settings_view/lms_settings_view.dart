import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/ui/partial_views/lms_settings_view/lms_settings_viewmodel.dart';
import 'package:uet_lms/ui/shared/CustomButton.dart';
import 'package:uet_lms/ui/shared/CutsomTextField.dart';
import 'package:uet_lms/ui/shared/HeadingWithSubtitle.dart';
import 'package:uet_lms/ui/shared/SplitScreen.dart';
import 'package:uet_lms/ui/ui_constants.dart';

class LMSSettingsView extends StatelessWidget {
  final id = "/lms_settings";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LMSSettingsViewModel>.reactive(
      builder: (context, model, _) => SplitScreen(
        leftView: Form(
          key: model.formKey,
          child: Padding(
            padding: EdgeInsets.only(
                left: kHorizontalSpacing,
                right: kHorizontalSpacing,
                bottom: 20),
            child: ListView(
              children: [
                SizedBox(
                  height: kAppBarHeight,
                ),
                HeadingWithSubtitle(
                  heading: "LMS Settings",
                  subtitle: "Let’s change that bad password, first.",
                ),
                SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  labelText: "Current Password",
                  hintText: "the secret you hold",
                  isPassword: true,
                  validator: (value) => value != model.lmsService.user.password
                      ? "This should match your current password"
                      : null,
                  onChanged: (value) => model.currentPassword = value.trim(),
                  enabled: !model.isBusy,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  labelText: "New Password",
                  hintText: "the new one you want",
                  isPassword: true,
                  onChanged: (value) => model.newPassword = value.trim(),
                  enabled: !model.isBusy,
                ),
                SizedBox(
                  height: 15,
                ),
                CustomTextField(
                  labelText: "Confirm New Password",
                  hintText: "come again?",
                  isPassword: true,
                  onChanged: (value) => model.confirmPassword = value.trim(),
                  validator: (currentVal) => currentVal != model.newPassword
                      ? "Passwords do not match"
                      : null,
                  enabled: !model.isBusy,
                ),
                SizedBox(
                  height: 30,
                ),
                SimpleWideButton(
                    text: "Change Password",
                    loading: model.isBusy,
                    onPressed: () {
                      model.changePassword();
                    }),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => LMSSettingsViewModel(),
    );
  }
}
