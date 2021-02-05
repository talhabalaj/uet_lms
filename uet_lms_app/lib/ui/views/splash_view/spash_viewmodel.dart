import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lms_api/lms_api.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:uet_lms/ui/dialog.dart';

class SplashViewModel extends BaseViewModel {
  final lmsService = L<LMSService>();
  final navigationService = L<NavigationService>();
  final dialogService = L<DialogService>();

  bool _internet = true;

  get internet => _internet;

  Future<void> initialise() async {
    if (kIsWeb || isMobile) {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return noInternet();
      }
    }

    bool shouldRetry = false;
    do {
      try {
        await lmsService.reAuth();
      } on SocketException {
        noInternet();
      } on Exception catch (e) {
        String errMessage, description;

        if (e is LMSException) {
          errMessage = e.message;
          description = e.description;
        } else {
          errMessage = e.runtimeType.toString();
        }

        shouldRetry = (await dialogService.showCustomDialog(
                variant: DialogType.basic,
                title: errMessage,
                barrierColor: Colors.black38,
                barrierDismissible: true,
                description:
                    description ?? "Please report this issue to the developer.",
                mainButtonTitle: "Retry",
                secondaryButtonTitle: "Exit"))
            .confirmed;
        if (!shouldRetry) {
          SystemNavigator.pop();
        }
      }
    } while (shouldRetry);

    this.setInitialised(true);
  }

  void noInternet() {
    _internet = false;
    this.notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
