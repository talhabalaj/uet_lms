import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

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
      print("BannerAd event is $event");
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
