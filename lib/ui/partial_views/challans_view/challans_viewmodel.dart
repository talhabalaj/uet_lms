import 'package:lms_api/models/obe.dues.students.challan.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';

class ChallansViewModel extends BaseViewModel {
  final lmsService = locator<LMSService>();

  List<Challan> challans;

  Future<void> initialize() async {
    this.setBusy(true);
    lmsService.user.getFeesChallans().then((value) {
      challans = value.reversed.toList();
      this.setBusy(false);
    });
    this.setInitialised(true);
  }

}