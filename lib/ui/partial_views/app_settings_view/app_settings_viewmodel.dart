import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/ThemeService.dart';
import 'package:uet_lms/ui/dialog.dart';

class AppSettingsViewModel extends BaseViewModel {
  final ThemeService themeService = locator<ThemeService>();
  final DialogService dialogService = locator<DialogService>();

  Future<void> updateTheme(String newValue) async {
    await themeService.setTheme(newValue);
    this.notifyListeners();
  }
}
