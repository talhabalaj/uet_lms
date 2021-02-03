import 'dart:typed_data';

import 'package:lms_api/lms_api.dart';
import 'package:lms_api/models/obe.dues.students.challan.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';

class ChallansViewModel extends BaseViewModel {
  final lmsService = locator<LMSService>();

  List<Challan> challans;

  Future<void> loadData({bool refresh = false}) async {
    this.setBusy(true);
    lmsService.getFeesChallans(refresh: refresh).then((value) {
      challans = value.reversed.toList();
      if (challans.length < 1) {
        this.setError(LMSException("Koi Fee Challans Nahi!", description: "There are no fee challans in your account, Kesay?"));
      }
      this.setBusy(false);
    }).catchError((e) => catchLMSorInternetException(e));
    this.setInitialised(true);
  }

  Future<void> downloadChallan(Challan challan) async {
    this.setBusyForObject(challan, true);

    Uint8List challanBytes = await lmsService.user.downloadChallan(challan.id);

    await saveFile(challanBytes, "Challan_Form_${challan.id}.pdf");

    this.setBusyForObject(challan, false);
  }
}
