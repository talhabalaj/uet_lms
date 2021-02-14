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
      final currentSemester = registeredSemesters.first;
      _result = await I<DataService>().getResult(
        refresh: refresh,
      );
      subjects = (await I<DataService>().getRegisteredSubjects(
        refresh: refresh,
      ))
          .where(
        (subject) =>
            subject.semesterName.toLowerCase() ==
            currentSemester.name.toLowerCase(),
      ).toList();
      currentSemesterResult = _result.where(
        (each) =>
            each.semesterName.toLowerCase() ==
            currentSemester.name.toLowerCase(),
      );
      for (Result result in currentSemesterResult) {
        final filteredSubjects = subjects.where((s) =>
            s.subjectName.toLowerCase() == result.subject.name.toLowerCase());
        if (filteredSubjects.length > 0) {
          final subject = filteredSubjects.first;
          subjectGradeMap[subject] = result.grade;
        }
      }
      calculateResult();
    } on Exception catch (e, s) {
      onlyCatchLMSorInternetException(e, stackTrace: s);
    }
    this.setBusy(false);
  }

  void calculateResult() {
    assert(_result != null, 'result should not be null');
    double totalCreds = 0, obtained = 0;

    for (final each in _result.where(
      (r) => !currentSemesterResult.contains(r),
    )) {
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
    else
      gpa = 0;

    cgpa = (obtained + obtainedCurrent) /
        ((totalCreds + totalCredsCurrent) * 4) *
        4;
  }
}
