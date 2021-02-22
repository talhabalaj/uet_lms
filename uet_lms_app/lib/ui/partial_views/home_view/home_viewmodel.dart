import 'package:lms_api/LMS.dart';
import 'package:lms_api/lms_api.dart';
import 'package:lms_api/models/obe.grade.book.detail.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/DataService.dart';
import 'package:uet_lms/core/services/NestedNavigationService.dart';
import 'package:uet_lms/core/services/AuthService.dart';
import "package:uet_lms/core/string_extension.dart";
import 'package:uet_lms/core/utils.dart';

class HomeViewModel extends BaseViewModel {
  final authService = I<AuthService>();
  final NavigationService navigationService = I<NavigationService>();
  final DialogService dialogService = I<DialogService>();
  final NestedNavigationService indexedStackService =
      I<NestedNavigationService>();

  StudentProfile studentProfile;
  List<Semester> semesters;
  List<GradeBookDetail> gradeBookDetails;
  List<Register> registerdSubjects;
  Map<Register, double> attendance = Map();

  LMS get user => authService.user;

  String get userFirstName {
    String name = studentProfile?.name;
    if (name != null) {
      return name.split(" ")[0].toLowerCase().capitalize();
    }
    return null;
  }

  void onError(dynamic e, StackTrace s) async {
    bool retry = await onlyCatchLMSorInternetException(e, stackTrace: s);
    if (retry) this.loadData();
  }

  Future<void> loadData({bool refresh = false}) async {
    this.setBusyForObject(studentProfile, true);
    this.setBusyForObject(semesters, true);
    this.setBusyForObject(gradeBookDetails, true);
    this.setBusyForObject(registerdSubjects, true);
    this.setBusyForObject(attendance, true);
    try {
      studentProfile =
          await I<DataService>().getStudentProfile(refresh: refresh);

      this.setBusyForObject(studentProfile, false);

      semesters =
          (await I<DataService>().getRegisteredSemesters(refresh: refresh))
              .reversed
              .toList();
      final lastSemester = semesters.last;
      this.setBusyForObject(semesters, false);

      registerdSubjects = (await I<DataService>().getRegisteredSubjects(
        refresh: refresh,
      ))
          .where((element) =>
              element.semesterName.toLowerCase() ==
              lastSemester.name.toLowerCase())
          .toList();

      this.setBusyForObject(registerdSubjects, false);

      // load last GPA
      gradeBookDetails =
          await I<DataService>().getSemestersSummary(refresh: refresh);
      this.setBusyForObject(gradeBookDetails, false);
      
      for (Register subject in registerdSubjects)
        this.attendance[subject] = await I<DataService>()
            .user
            .getAttendanceForRegisteredCourse(subject);

      this.setBusyForObject(attendance, false);

    } catch (e, s) {
      onError(e, s);
    }
  }
}
