import 'package:lms_api/models/obe.core.register.dart';
import 'package:lms_api/models/obe.core.result.dart';
import 'package:lms_api/models/obe.core.semester.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';
import 'package:uet_lms/core/utils.dart';

class DMCViewModel extends BaseViewModel {
  final LMSService lmsService = locator<LMSService>();

  List<Semester> registeredSemesters;

  String _selectedSemester;
  List<Result> _result;
  List<Register> registeredSubjects;

  get result => _result.where((a) =>
      registeredSubjects
          .firstWhere((b) => a.subject.name == b.subjectName)
          .semesterName ==
      _selectedSemester);

  get selectedSemester => _selectedSemester;
  set selectedSemester(String value) {
    _selectedSemester = value;
    this.notifyListeners();
  }

  Future<void> loadData({bool refresh = false}) async {
    this.setBusy(true);
    try {
      registeredSemesters =
          await lmsService.getRegisteredSemesters(refresh: refresh);
      selectedSemester ??= registeredSemesters.first.name;
      _result = await lmsService.getResult(refresh: refresh);
      registeredSubjects =
          await lmsService.getRegisteredSubjects(refresh: refresh);
    } on Exception catch (e) {
      catchLMSorInternetException(e);
    }
    this.setBusy(false);
  }
}
