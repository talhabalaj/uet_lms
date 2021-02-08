import 'dart:typed_data';
import 'package:lms_api/models/obe.dues.students.challan.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/models/UserShowableAppError.dart';
import 'package:uet_lms/core/services/DataService.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:uet_lms/core/locator.dart';

class ChallansViewModel extends BaseViewModel {

  List<Challan> challans;

  Future<void> loadData({bool refresh = false}) async {
    this.setBusy(true);
    try {
      challans = (await I<DataService>().getFeesChallans(refresh: refresh))
          .reversed
          .toList();
      if (challans.length < 1) {
        this.setError(
          UserShowableAppError(
            message: "Koi Fee Challans Nahi!",
            description: "There are no fee challans in your account, Kesay?",
          ),
        );
      }
      this.setBusy(false);
    } catch (e, s) {
      onlyCatchLMSorInternetException(e, stackTrace: s);
    }
    this.setInitialised(true);
  }

  Future<void> downloadChallan(Challan challan) async {
    this.setBusyForObject(challan, true);

    Uint8List challanBytes = await I<DataService>().user.downloadChallan(challan.id);

    await saveFile(challanBytes, "Challan_Form_${challan.id}.pdf");

    this.setBusyForObject(challan, false);
  }
}
