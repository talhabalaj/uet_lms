import 'package:lms_api/LMS.dart';
import 'package:lms_api/lms_api.dart';
import 'package:lms_api/models/obe.grade.book.detail.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/nested_navigation_service.dart';
import 'package:uet_lms/core/services/lms_service.dart';
import "package:uet_lms/core/string_extension.dart";
import 'package:uet_lms/core/utils.dart';

class HomeViewModel extends BaseViewModel {
  final lmsService = locator<LMSService>();
  final NavigationService navigationService = locator<NavigationService>();
  final DialogService dialogService = locator<DialogService>();
  final NestedNavigationService indexedStackService =
      locator<NestedNavigationService>();

  StudentProfile studentProfile;
  List<Semester> semesters;
  List<GradeBookDetail> gradeBookDetails;
  List<Register> registerdSubjects;
  Map<Register, double> attendance = Map();

  LMS get user => lmsService.user;

  String get userFirstName {
    String name = studentProfile?.name;
    if (name != null) {
      return name.split(" ")[0].toLowerCase().capitalize();
    }
    return null;
  }

  void onError(dynamic e, dynamic s) {
    catchLMSorInternetException(e);
  }

  Future<void> loadData({bool refresh = false}) async {
    this.setBusyForObject(studentProfile, true);
    this.setBusyForObject(semesters, true);
    this.setBusyForObject(gradeBookDetails, true);
    this.setBusyForObject(registerdSubjects, true);
    this.setBusyForObject(attendance, true);

    lmsService.getStudentProfile(refresh: refresh).then((value) {
      studentProfile = value;
      this.setBusyForObject(studentProfile, false);
    }).catchError(onError);

    lmsService.getRegisteredSemesters(refresh: refresh).then((value) async {
      semesters = value.reversed.toList();
      final lastSemester = semesters.last;
      this.setBusyForObject(semesters, false);

      registerdSubjects =
          (await lmsService.getRegisteredSubjects(refresh: refresh))
              .where((element) =>
                  element.semesterName.toLowerCase() ==
                  lastSemester.name.toLowerCase())
              .toList();
      this.setBusyForObject(registerdSubjects, false);
      for (Register subject in registerdSubjects)
        this.attendance[subject] =
            await lmsService.user.getAttendanceForRegisteredCourse(subject);

      this.setBusyForObject(attendance, false);
    }).catchError(onError);

    // load last GPA
    lmsService.getSemestersSummary(refresh: refresh).then((value) {
      gradeBookDetails = value;
      this.setBusyForObject(gradeBookDetails, false);
    }).catchError(onError);
  }
}
