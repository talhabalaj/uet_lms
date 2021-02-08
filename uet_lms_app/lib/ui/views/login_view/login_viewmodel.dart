import 'package:flutter/material.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/AuthService.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final lmsService = I<AuthService>();
  final dialogService = I<DialogService>();

  String regNo = "", password = "";

  Future<void> login() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      this.setBusy(true);

      try {
        await lmsService.login(
            email: "$regNo@student.uet.edu.pk", password: password);
      } catch (e) {
        onlyCatchLMSorInternetException(
          e,
          mainTitleButton: "Try again",
          secondaryButtonTitle: null,
        );
      }
      // async code
      this.setBusy(false);
    }
  }
}
