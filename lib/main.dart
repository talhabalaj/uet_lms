import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lms_app/core/locator.dart';
import 'package:lms_app/ui/dialog.dart';
import 'package:lms_app/ui/shared/BasicDialog.dart';
import 'package:lms_app/ui/shared/CustomButton.dart';
import 'package:lms_app/ui/ui_constants.dart';
import 'package:lms_app/ui/views/login_view/login_view.dart';
import 'package:stacked_services/stacked_services.dart';

void main() async {
  configureDependencies();
  setupDialogUi();
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      if (kDebugMode) {
        FirebaseCrashlytics.instance
            .setCrashlyticsCollectionEnabled(false)
            .then((v) {
          log("[Crashlytics] Turned off, res: debug mode.");
        });
      }
    }

    // Timer(Duration(seconds: 5), () {
    //   FirebaseCrashlytics.instance.crash();
    // });

    return MaterialApp(
      title: 'UET LMS',
      navigatorKey: locator<NavigationService>().navigatorKey,
      theme: getTheme(),
      home: LoginView(),
    );
  }
}
