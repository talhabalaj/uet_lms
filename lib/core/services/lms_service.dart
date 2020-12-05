import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:lms_api/lms_api.dart';

@lazySingleton
class LMSService {
  LMS api;

  get loggedIn => api != null;

  Future<LMS> login({String email, String password}) async {
    api = LMS(email: email, password: password);
    // try {
    //   final cookie = await secureStorage.read(key: "cookie");
    //   if (cookie != null) {
    //     try {
    //       await api.loginWithCookie(cookie);
    //     } on LMSException {
    //       await api.login();
    //     }
    //   }

    // } on PlatformException catch(e) {
    //   log("[Error Flutter Secure Storage]", error: e);
    // }
    await api.login();
    final secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: "email", value: email);
    await secureStorage.write(key: "password", value: password);
    await secureStorage.write(key: "cookie", value: api.cookie);
    return api;
  }

  Future<void> logout() {
    // TODO: invalidate the cookie
    api = null;
    final secureStorage = FlutterSecureStorage();
    return secureStorage.deleteAll();
  }
}
