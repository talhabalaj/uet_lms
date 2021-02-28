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
import 'package:uet_lms/core/services/AuthService.dart';
import 'package:uet_lms/core/utils.dart';

class SplashViewModel extends BaseViewModel {
  final authService = I<AuthService>();
  final navigationService = I<NavigationService>();
  final dialogService = I<DialogService>();

  bool _internet = true;

  get internet => _internet;

  Future<void> initialise() async {
    this.setBusy(true);

    if (kIsWeb || isMobile) {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        this.setBusy(false);
        return noInternet();
      }
    }

    try {
      await authService.reAuth();
    } on SocketException {
      noInternet();
    } on Exception catch (e, s) {
      bool retry = await onlyCatchLMSorInternetException(e, stackTrace: s);
      if (retry) return this.initialise();
    }
    this.setBusy(false);
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
