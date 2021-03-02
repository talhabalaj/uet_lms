import 'package:lms_api/lms_api.dart';
import 'package:lms_api/models/campus.hostel.detail.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/DataService.dart';
import 'package:uet_lms/core/utils.dart';

class StudentProfileViewModel extends BaseViewModel {
  StudentProfile profile;
  List<HostelAllocationDetail> hostelAllocationDetail;

  Future<void> loadData({bool refresh = false}) async {
    this.setBusy(true);
    this.clearErrors();
    try {
      profile = await I<DataService>().getStudentProfile(refresh: refresh);
      if (profile.room.id != null) {
        hostelAllocationDetail = await I<DataService>()
            .getHostelInformation(profile.room.id, refresh: refresh);

        hostelAllocationDetail = hostelAllocationDetail
            .where((e) => e.state == 'Alloted' && e.studentId.id != profile.id)
            .toList();
      }
    } catch (e, s) {
      await onlyCatchLMSorInternetException(e, stackTrace: s);
      this.setError(e);
    }
    this.setBusy(false);
  }
}
