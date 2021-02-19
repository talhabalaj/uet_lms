import 'package:background_fetch/background_fetch.dart';
import 'package:injectable/injectable.dart';
import 'package:uet_lms/core/services/DataService.dart';
import 'package:uet_lms/core/services/PreferencesService.dart';

import '../locator.dart';

@lazySingleton
class BackgroundService {
  void registerBackgroundService() {
    BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 120,
        startOnBoot: true,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: true,
        requiresCharging: false,
        requiresStorageNotLow: true,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY,
      ),
      (String taskId) async {
        if (I<PreferencesService>().preferences.notifyGradeUpdate) {
          await I<DataService>().checkResultAndNotify();
        }
        BackgroundFetch.finish(taskId);
      },
    );
  }
}
