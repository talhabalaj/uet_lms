import 'dart:typed_data';

import 'package:lms_api/models/obe.dues.students.challan.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';

class ChallansViewModel extends BaseViewModel {
  final lmsService = locator<LMSService>();

  List<Challan> challans;

  Future<void> loadData() async {
    this.setBusy(true);
    lmsService.user.getFeesChallans().then((value) {
      challans = value.reversed.toList();
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
