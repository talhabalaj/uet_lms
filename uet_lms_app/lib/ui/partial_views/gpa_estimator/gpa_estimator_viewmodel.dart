import 'package:lms_api/lms_api.dart';
import 'package:lms_api/models/obe.core.result.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/constants.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/AuthService.dart';
import 'package:uet_lms/core/services/DataService.dart';
import 'package:uet_lms/core/utils.dart';

class GPAEstimatorViewModel extends BaseViewModel {
  List<Result> _result;
  List<Semester> registeredSemesters;
  List<Register> subjects;
  Iterable<Result> currentSemesterResult;

  Map<Register, String> subjectGradeMap = {};
  double gpa = 0;
  double cgpa = 0;

  Future<void> loadData({bool refresh = false}) async {
    this.clearErrors();
    this.setBusy(true);
    try {
      subjectGradeMap = {};
      registeredSemesters = await I<DataService>().getRegisteredSemesters(
        refresh: refresh,
      );
      _result = await I<DataService>().getResult(
        refresh: refresh,
      );
      subjects = await I<AuthService>().user.getRegisteredSubjects(
        semester: registeredSemesters.first,
      );
      currentSemesterResult = _result.where(
        (each) =>
            each.semesterName.toLowerCase() ==
            registeredSemesters.first.name.toLowerCase(),
      );
      calculateResult();
    } on Exception catch (e, s) {
      onlyCatchLMSorInternetException(e, stackTrace: s);
    }
    this.setBusy(false);
  }

  void calculateResult() {
    assert(_result != null, 'result should not be null');
    double totalCreds = 0, obtained = 0;

    for (final each in _result) {
      totalCreds += each.totalCredHrs ?? 0;
      obtained += double.tryParse(each.subjectGPA) ?? 0;
    }

    double totalCredsCurrent = 0, obtainedCurrent = 0;
    for (final entry in subjectGradeMap.entries) {
      double cred = double.tryParse(entry.key.subjectCreditHour);
      totalCredsCurrent += cred;
      obtainedCurrent += kGradeGPAMap[entry.value] * cred;
    }
    if (totalCredsCurrent != 0)
      gpa = (obtainedCurrent / (totalCredsCurrent * 4)) * 4;
    
    cgpa = (obtained + obtainedCurrent) /
        ((totalCreds + totalCredsCurrent) * 4) *
        4;
  }
}
