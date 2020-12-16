import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:lms_api/lms_api.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/ui/dialog.dart';
import 'package:uet_lms/ui/views/login_view/login_view.dart';
import 'package:uet_lms/ui/views/main_view/main_view.dart';

import '../run_on_mobile.dart';

@lazySingleton
class LMSService {
  LMS user;
  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  final NavigationService navigationService = locator<NavigationService>();
  final DialogService dialogService = locator<DialogService>();

  get loggedIn => user != null;

  Future<void> setCrashReportsUserId(String userId) {
    return runOnlyOnMobile(() async {
      await FirebaseCrashlytics.instance.setUserIdentifier(user.email);
    });
  }

  LMS _createLMSObject(String email, String password) {
    String target = "https://lms.uet.edu.pk";
    if (kIsWeb) target = "https://lms-uet-edu-pk-webproxy.herokuapp.com";
    return LMS(email: email, password: password, target: target);
  }

  Future<LMS> _login() async {
    await user.login();
    await storeOnSecureStorage();
    await setCrashReportsUserId(user.email);
    return user;
  }

  Future<void> login({String email, String password}) async {
    user = _createLMSObject(email, password);
    await _login();
    await navigationService.clearStackAndShow(MainView.id);
  }

  Future<void> storeOnSecureStorage() async {
    if (user == null) throw Exception("User is null, can't store.");
    if (kIsWeb) {
      // TODO: store stuff on web too
    } else {
      await secureStorage.write(key: "email", value: user.email);
      await secureStorage.write(key: "password", value: user.password);
      await secureStorage.write(key: "cookie", value: user.cookie);
    }
  }

  Future<void> deleteAuthInfoFromSecureStorage() async {
    await secureStorage.delete(key: "email");
    await secureStorage.delete(key: "password");
    await secureStorage.delete(key: "cookie");
  }

  Future<Map<String, String>> readFromSecureStorage() async {
    if (!kIsWeb) {
      final cookie = await secureStorage.read(key: "cookie");
      final email = await secureStorage.read(key: "email");
      final password = await secureStorage.read(key: "password");
      return {
        "cookie": cookie,
        "email": email,
        "password": password,
      };
    }
    return null;
  }

  Future<void> reAuth() async {
    if (await _reAuth()) {
      await navigationService.clearStackAndShow(MainView.id);
    } else {
      await navigationService.clearStackAndShow(LoginView.id);
    }
  }

  Future<bool> _reAuth() async {
    if (kIsWeb) {
      return false;
    }

    try {
      final storedData = await this.readFromSecureStorage();
      final email = storedData['email'];
      final password = storedData['password'];
      final cookie = storedData['cookie'];

      if (email == null || password == null || cookie == null) {
        return false;
      }

      try {
        user = _createLMSObject(email, password);
        await user.loginWithCookie(cookie);
      } on LMSException {
        await user.login();
        await storeOnSecureStorage();
      }

      setCrashReportsUserId(user.email);
      return true;
    } on PlatformException catch (e) {
      log("[Error Flutter Secure Storage]", error: e);
    } on LMSException catch (e) {
      log("[Error LMS]", error: e);
    }

    await this._logout();

    return false;
  }

  Future<void> logout() async {
    DialogResponse r = await dialogService.showCustomDialog(
      variant: DialogType.basic,
      mainButtonTitle: "I'm sure",
      secondaryButtonTitle: "Oh mistakenly",
      title: "Are you sure?",
      description: "We hate to see you go, Please come back soon. ",
    );

    if (r.confirmed) {
      await this._logout();
      await navigationService.clearStackAndShow(LoginView.id);
    }
  }

  Future<void> _logout() async {
    // TODO: invalidate the cookie
    user = null;
    setCrashReportsUserId("loggedOutUser");
    if (kIsWeb) {
      return;
    }
    await this.deleteAuthInfoFromSecureStorage();
  }
}
