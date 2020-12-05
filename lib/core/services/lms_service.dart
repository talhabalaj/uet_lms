import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:lms_api/lms_api.dart';

@lazySingleton
class LMSService {
  LMS user;

  get loggedIn => user != null;

  Future<LMS> login({String email, String password}) async {
    user = LMS(email: email, password: password);
    await user.login();
    await storeOnSecureStorage();
    return user;
  }

  Future<void> storeOnSecureStorage() async {
    if (user == null) throw Exception("User is null, can't store.");
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: "email", value: user.email);
    await secureStorage.write(key: "password", value: user.password);
    await secureStorage.write(key: "cookie", value: user.cookie);
    FirebaseCrashlytics.instance.setUserIdentifier(user.email);
  }

  Future<bool> reAuth() async {
    final secureStorage = FlutterSecureStorage();
     try {
      final cookie = await secureStorage.read(key: "cookie");
      final email = await secureStorage.read(key: "email");
      final password = await secureStorage.read(key: "password");

      if (email == null || password == null || cookie == null) {
        return false;
      }

      try {
        user = LMS(email: email, password: password);
        await user.loginWithCookie(cookie);
      } on LMSException {
        await user.login();
        await storeOnSecureStorage();
      }

      FirebaseCrashlytics.instance.setUserIdentifier(user.email);

      return true;
    } on PlatformException catch(e) {
      log("[Error Flutter Secure Storage]", error: e);
    } on LMSException  catch(e) {
      log("[Error LMS]", error: e);
    }

    await this.logout();

    return false;
  }

  Future<void> logout() async {
    // TODO: invalidate the cookie
    user = null;
    FirebaseCrashlytics.instance.setUserIdentifier("loggedOutUser");
    final secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: "email");
    await secureStorage.delete(key: "password");
    await secureStorage.delete(key: "cookie");
  }
}
