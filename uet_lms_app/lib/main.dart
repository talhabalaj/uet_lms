import 'package:desktop_window/desktop_window.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/AdsService.dart';
import 'package:uet_lms/core/services/BackgroundService.dart';
import 'package:uet_lms/core/services/NotificationService.dart';
import 'package:uet_lms/core/services/PreferencesService.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:uet_lms/ui/dialog.dart';
import 'package:uet_lms/ui/views/login_view/login_view.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/ui/views/main_view/main_view.dart';
import 'package:uet_lms/ui/views/splash_view/splash_view.dart';

import 'core/services/ThemeService.dart';

void main() async {
  configureDependencies();
  setupDialogUi();
  registerHiveTypeAdapters();
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // initialise firebase
  if (isMobile) {
    await Firebase.initializeApp();

    if (!kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    I<NotificationService>().initialize();
    I<BackgroundService>().registerBackgroundService();
    AdsService.initiliase();
  }
  // for desktop app set windows size, check web first, reason no implementation of Platform on web
  if (isDesktop) {
    await DesktopWindow.setWindowSize(Size(400, 700));
    await DesktopWindow.setMinWindowSize(Size(400, 600));
    await DesktopWindow.setMaxWindowSize(Size(400, 1000));
    await DesktopWindow.setFullScreen(false);
  }

  await I<PreferencesService>().init();
  I<ThemeService>().init();

  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AdsService.showBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = I<ThemeService>().themeMode;
    Brightness brightness = Brightness.light;

    if (themeMode == ThemeMode.light) {
      brightness = Brightness.dark;
    } else if (themeMode == ThemeMode.system) {
      brightness = Theme.of(context).brightness;
    }

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: brightness,
        statusBarIconBrightness: brightness,
        systemNavigationBarIconBrightness: brightness,
      ),
    );

    return Container(
      color: brightness != Brightness.dark ? Colors.black : Colors.white,
      padding: EdgeInsets.only(bottom: 50.0),
      child: MaterialApp(
        title: 'UET LMS',
        debugShowCheckedModeBanner: false,
        navigatorKey: StackedService.navigatorKey,
        theme: ThemeService.light,
        darkTheme: ThemeService.dark,
        themeMode: themeMode,
        routes: {
          SplashView.id: (context) => SplashView(),
          LoginView.id: (context) => LoginView(),
          MainView.id: (context) => MainView(),
        },
        initialRoute: SplashView.id,
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: I<FirebaseAnalytics>())
        ],
      ),
    );
  }
}
