import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../locator.dart';

class AdsService {
  static String admobAppId = "ca-app-pub-5202859744156180~8918472272";

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['education', 'bachelors', 'gpa', 'cgpa'],
    childDirected: false,
  );

  static BannerAd myBanner = BannerAd(
    adUnitId: "ca-app-pub-5202859744156180/3917179615",
    size: AdSize.banner,
    targetingInfo: AdsService.targetingInfo,
    listener: (MobileAdEvent event) {
      I<FirebaseAnalytics>().logEvent(
          name: 'ad_state_event', parameters: {'value': event.toString()});
    },
  );

  static void initiliase() {
    FirebaseAdMob.instance.initialize(appId: admobAppId);
  }

  static void showBannerAd() {
    if (Platform.isAndroid) {
      myBanner
        ..load()
        ..show();
    }
  }
}
