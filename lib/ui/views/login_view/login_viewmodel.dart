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
    bool retry = false;
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      this.setBusy(true);
      do {
        try {
          await lmsService.login(
              email: "$regNo@student.uet.edu.pk", password: password);
        } catch (e) {
          retry = await catchLMSorInternetException(e);
        }
      } while (retry);
      // async code
      this.setBusy(false);
    }
  }
}
