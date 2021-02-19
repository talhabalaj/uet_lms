import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/models/UserPreferences.dart';
import 'package:uet_lms/core/services/PreferencesService.dart';
import 'package:uet_lms/core/services/ThemeService.dart';
import 'package:package_info/package_info.dart';
import 'package:uet_lms/core/utils.dart';

class AppSettingsViewModel extends BaseViewModel {
  final ThemeService themeService = I<ThemeService>();
  final DialogService dialogService = I<DialogService>();
  final preferencesService = I<PreferencesService>();

  UserPreferences get preferences => preferencesService.preferences;
  PackageInfo packageInfo;

  Future<void> loadData() async {
    this.setBusy(true);
    if (isMobile) {
      packageInfo = await PackageInfo.fromPlatform();
    }
    this.setBusy(false);
  }

  Future<void> updateTheme(String newValue) async {
    await themeService.setTheme(newValue);
    this.notifyListeners();
  }

  Future<void> setNotifyGradePreference(bool val) async {
    await preferencesService.update(
      UserPreferences(notifyGradeUpdate: val),
    );
    this.notifyListeners();
  }
}
