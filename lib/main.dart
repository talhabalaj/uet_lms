import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/run_on_mobile.dart';
import 'package:uet_lms/ui/dialog.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:uet_lms/ui/views/home_view/home_view.dart';
import 'package:uet_lms/ui/views/login_view/login_view.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/ui/views/splash_view/splash_view.dart';

void main() async {
  configureDependencies();
  setupDialogUi();
  WidgetsFlutterBinding.ensureInitialized();

  // initialise firebase
  await runOnlyOnMobile(() async {
    await Firebase.initializeApp();
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
   }
  );

  // for desktop app set windows size, check web first, reason no implementation of Platform on web
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await DesktopWindow.setWindowSize(Size(1000,600));
    await DesktopWindow.setMinWindowSize(Size(400,600));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UET LMS',
      navigatorKey: locator<NavigationService>().navigatorKey,
      theme: getTheme(),
      routes: {
        SplashView.id: (context) => SplashView(),
        LoginView.id: (context) => LoginView(),
        HomeView.id: (context) => HomeView(),
      },
      initialRoute: SplashView.id,
    );
  }
}
