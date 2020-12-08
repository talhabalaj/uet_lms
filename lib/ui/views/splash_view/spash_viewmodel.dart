import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';

class SplashViewModel extends BaseViewModel {
  final lmsService = locator<LMSService>();
  final navigationService = locator<NavigationService>();

  bool _internet = true;

  get internet => _internet;

  Future<void> initialise() async {
    if (kIsWeb || !Platform.isLinux) {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        return noInternet();
      }
    }

    try {
      await lmsService.reAuth();
    } on SocketException {
      noInternet();
    }
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
