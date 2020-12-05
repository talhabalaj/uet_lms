import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lms_api/lms_api.dart';
import 'package:lms_app/core/locator.dart';
import 'package:lms_app/core/services/lms_service.dart';
import 'package:lms_app/ui/dialog.dart';
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
        String errorMessage, description;
        print(e);
        if (e is LMSException) {
          errorMessage = e.message ?? "Unknown Error";
          description = e.description ?? "LMS is drunk";
        }
        if (e is SocketException) {
          errorMessage = "No Internet connection.";
          description = "Maybe try again with internet";
        }
        await dialogService.showCustomDialog(
          variant: DialogType.basic,
          mainButtonTitle: "Oh my mistake..",
          title: errorMessage ?? e.runtimeType.toString(),
          description: description ?? "Try again later, something is very wrong",
        );
      }
      // async code
      this.setBusy(false);
    }
  }
}
