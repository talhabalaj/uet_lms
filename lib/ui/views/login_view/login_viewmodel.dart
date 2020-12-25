import 'package:flutter/material.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LoginViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final lmsService = locator<LMSService>();
  final dialogService = locator<DialogService>();

  String regNo = "", password = "";

  Future<void> login() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      this.setBusy(true);

      try {
        await lmsService.login(
            email: "$regNo@student.uet.edu.pk", password: password);
      } catch (e) {
        catchLMSorInternetException(
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
