import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:lms_api/lms_api.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/DataService.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:uet_lms/ui/dialog.dart';
import 'package:uet_lms/ui/views/login_view/login_view.dart';
import 'package:uet_lms/ui/views/main_view/main_view.dart';

import 'NestedNavigationService.dart';

@lazySingleton
class AuthService {
  LMS user;
  FlutterSecureStorage secureStorage = FlutterSecureStorage();

  final NavigationService navigationService = I<NavigationService>();
  final DialogService dialogService = I<DialogService>();

  bool get loggedIn => user != null && user.cookie != null;

  Future<void> setCrashReportsUserId(String userId) async {
    if (isMobile) await FirebaseCrashlytics.instance.setUserIdentifier(userId);
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

  Future<bool> canReAuth() async {
    final storedData = await this.readFromSecureStorage();
    final email = storedData['email'];
    final password = storedData['password'];
    final cookie = storedData['cookie'];

    if (email == null || password == null || cookie == null) {
      return false;
    }
    return true;
  }

  Future<bool> _reAuth() async {
    try {
      final storedData = await this.readFromSecureStorage();
      final email = storedData['email'];
      final password = storedData['password'];
      final cookie = storedData['cookie'];

      if (email == null || password == null || cookie == null) {
        return false;
      }

      user = _createLMSObject(email, password);
      await user.login();
      await storeOnSecureStorage();

      I<FirebaseAnalytics>().logEvent(name: 'reauth_with_creds');
    } on AuthError {
      await this._logout();
      return false;
    }

    setCrashReportsUserId(user.email);

    return true;
  }

  Future<void> logout() async {
    DialogResponse r = await dialogService.showCustomDialog(
      variant: DialogType.basic,
      mainButtonTitle: "I'm sure",
      secondaryButtonTitle: "Oh mistakenly",
      barrierColor: Colors.black38,
      barrierDismissible: true,
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

    // Reset the Navigation Route
    I<NestedNavigationService>().reset();
    I<DataService>().invalidate();

    // Set UserId to loggedOutUser
    setCrashReportsUserId("loggedOutUser");

    if (!kIsWeb) {
      await this.deleteAuthInfoFromSecureStorage();
    }
  }
}
