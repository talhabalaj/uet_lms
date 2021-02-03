import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/ThemeService.dart';
import 'package:package_info/package_info.dart';
import 'package:uet_lms/core/utils.dart';

class AppSettingsViewModel extends BaseViewModel {
  final ThemeService themeService = locator<ThemeService>();
  final DialogService dialogService = locator<DialogService>();

  PackageInfo packageInfo;

  Future<void> loadData() async {
    this.setBusy(true);
    if (isMobile()) {
      packageInfo = await PackageInfo.fromPlatform();
    }
    this.setBusy(false);
  }

  Future<void> updateTheme(String newValue) async {
    await themeService.setTheme(newValue);
    this.notifyListeners();
  }
}
