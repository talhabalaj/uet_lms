
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';

class SplashViewModel extends BaseViewModel {
  final lmsService = locator<LMSService>();
  final navigationService = locator<NavigationService>();

  bool _internet = true;

  get internet => _internet;

  Future<void> initialise() async {
    try {
      final didAuth = await lmsService.reAuth();
      if (!didAuth) {
        await navigationService.clearStackAndShow("/login");
      } else {
        await navigationService.clearStackAndShow("/home");
      }
    } catch(e) {
      _internet = false;
      this.notifyListeners();
    }
    this.setInitialised(true);
  }
}
