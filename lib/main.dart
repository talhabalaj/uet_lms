
import 'package:desktop_window/desktop_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:uet_lms/ui/dialog.dart';
import 'package:uet_lms/ui/ui_constants.dart';
import 'package:uet_lms/ui/views/login_view/login_view.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/ui/views/main_view/main_view.dart';
import 'package:uet_lms/ui/views/splash_view/splash_view.dart';

void main() async {
  configureDependencies();
  setupDialogUi();
  WidgetsFlutterBinding.ensureInitialized();

  // initialise firebase
  if (isMobile()) {
    await Firebase.initializeApp();
    if (!kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
  }
    // for desktop app set windows size, check web first, reason no implementation of Platform on web
  if (isDesktop()) {
    await DesktopWindow.setWindowSize(Size(1001, 600));
    await DesktopWindow.setMinWindowSize(Size(400, 600));
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'UET LMS',
      debugShowCheckedModeBanner: false,
      navigatorKey: locator<NavigationService>().navigatorKey,
      theme: getTheme(),
      routes: {
        SplashView.id: (context) => SplashView(),
        LoginView.id: (context) => LoginView(),
        MainView.id: (context) => MainView(),
      },
      initialRoute: SplashView.id,
    );
  }
}
