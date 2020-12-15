import 'dart:io';
import 'dart:typed_data';

import 'package:lms_api/models/obe.dues.students.challan.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';

class ChallansViewModel extends BaseViewModel {
  final lmsService = locator<LMSService>();

  List<Challan> challans;
  String download;

  Future<void> initialize() async {
    this.setBusy(true);
    lmsService.user.getFeesChallans().then((value) {
      challans = value.reversed.toList();
      this.setBusy(false);
    });
    this.setInitialised(true);
  }

  Future<void> downloadChallan(int challanId) async {
    this.setBusyForObject(download, true);

    Uint8List challanBytes = await lmsService.user.downloadChallan(challanId);
    Directory tempDir = await getTemporaryDirectory();

    String tempPath = tempDir.path;
    File tempFile = File("$tempPath/challan_form.pdf");

    tempFile.writeAsBytes(challanBytes);
    
    OpenFile.open(tempFile.path);
    this.setBusyForObject(download, false);
  }
}
