import 'dart:developer';
import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:lms_api/lms_api.dart';

import '../run_on_mobile.dart';

@lazySingleton
class LMSService {
  LMS user;

  get loggedIn => user != null;

  LMS _createLMSObject(String email, String password) {
    String target = "https://lms.uet.edu.pk";
    if (kIsWeb) target = "http://localhost:3000";
    return LMS(email: email, password: password, target: target);
  }

  Future<LMS> login({String email, String password}) async {
    user = _createLMSObject(email, password);
    await user.login();
    await storeOnSecureStorage();
    return user;
  }

  Future<void> storeOnSecureStorage() async {
    if (kIsWeb) {
      return false;
    }
    if (user == null) throw Exception("User is null, can't store.");
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: "email", value: user.email);
    await secureStorage.write(key: "password", value: user.password);
    await secureStorage.write(key: "cookie", value: user.cookie);
    await runOnlyOnMobile(() async {
      await FirebaseCrashlytics.instance.setUserIdentifier(user.email);
    });
  }

  Future<bool> reAuth() async {
    if (kIsWeb) {
      return false;
    }

    final secureStorage = FlutterSecureStorage();
    try {
      final cookie = await secureStorage.read(key: "cookie");
      final email = await secureStorage.read(key: "email");
      final password = await secureStorage.read(key: "password");

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

      await runOnlyOnMobile(() async {
        await FirebaseCrashlytics.instance.setUserIdentifier(user.email);
      });
      return true;
    } on PlatformException catch (e) {
      log("[Error Flutter Secure Storage]", error: e);
    } on LMSException catch (e) {
      log("[Error LMS]", error: e);
    }

    await this.logout();

    return false;
  }

  Future<void> logout() async {
    // TODO: invalidate the cookie
    user = null;
    await runOnlyOnMobile(() async {
      await FirebaseCrashlytics.instance.setUserIdentifier("loggedOutUser");
    });
    if (kIsWeb) {
      return;
    }
    final secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: "email");
    await secureStorage.delete(key: "password");
    await secureStorage.delete(key: "cookie");
  }
}
