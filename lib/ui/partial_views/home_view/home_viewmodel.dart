import 'package:lms_api/LMS.dart';
import 'package:lms_api/lms_api.dart';
import 'package:lms_api/models/obe.grade.book.detail.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/indexed_stack_service.dart';
import 'package:uet_lms/core/services/lms_service.dart';
import "package:uet_lms/core/string_extension.dart";
import 'package:uet_lms/core/utils.dart';

class HomeViewModel extends BaseViewModel {
  final lmsService = locator<LMSService>();
  final NavigationService navigationService = locator<NavigationService>();
  final DialogService dialogService = locator<DialogService>();
  final IndexedStackService indexedStackService =
      locator<IndexedStackService>();

  StudentProfile studentProfile;
  Semester lastSemester;
  GradeBookDetail lastGradeBookDetail;
  List<Register> registerdSubjects;

  LMS get user => lmsService.user;

  String get userFirstName {
    String name = studentProfile?.name;
    if (name != null) {
      return name.split(" ")[0].toLowerCase().capitalize();
    }
    return null;
  }

  void onError(dynamic e) {
    catchLMSorInternetException(e);
  }

  Future<void> loadData({bool refresh = false}) async {
    this.setBusyForObject(studentProfile, true);
    this.setBusyForObject(lastSemester, true);
    this.setBusyForObject(lastGradeBookDetail, true);
    this.setBusyForObject(registerdSubjects, true);
    lmsService.getStudentProfile(refresh: refresh).then((value) {
      studentProfile = value;
      this.setBusyForObject(studentProfile, false);
    }).catchError(onError);
    lmsService.getRegisteredSemesters(refresh: refresh).then((value) async {
      lastSemester = value.first;
      this.setBusyForObject(lastSemester, false);
      registerdSubjects =
          (await lmsService.getRegisteredSubjects(refresh: refresh))
              .where((element) =>
                  element.semesterName.toLowerCase() ==
                  lastSemester.name.toLowerCase())
              .toList();
      this.setBusyForObject(registerdSubjects, false);
    }).catchError(onError);
    lmsService.getSemestersSummary(refresh: refresh).then((value) {
      lastGradeBookDetail = value.last;
      this.setBusyForObject(lastGradeBookDetail, false);
    }).catchError(onError);
  }
}
