import 'dart:developer';

import 'package:background_fetch/background_fetch.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:lms_api/models/obe.core.result.dart';

import '../locator.dart';

@lazySingleton
class BackgroundService {
  void registerBackgroundService() {
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      log("fired $taskId");
      // var f = await L<LMSService>().user.getResult();
      // var d = await Hive.openBox<Result>("results");
      // await d.deleteAll(d.keys);
      // d.addAll(f);
      BackgroundFetch.finish(taskId);
    });

  }

}
