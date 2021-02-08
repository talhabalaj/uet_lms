import 'package:background_fetch/background_fetch.dart';
import 'package:injectable/injectable.dart';
import 'package:uet_lms/core/services/DataService.dart';

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
        requiredNetworkType: NetworkType.ANY,
      ),
      (String taskId) async {
        await I<DataService>().checkResultAndNotify();
        BackgroundFetch.finish(taskId);
      },
    );
  }
}
