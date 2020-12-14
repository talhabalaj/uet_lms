import 'package:lms_api/LMS.dart';
import 'package:lms_api/lms_api.dart';
import 'package:lms_api/models/obe.grade.book.detail.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';
import "package:uet_lms/core/string_extension.dart";

class HomeViewModel extends BaseViewModel {
  final lmsService = locator<LMSService>();
  final NavigationService navigationService = locator<NavigationService>();
  final DialogService dialogService = locator<DialogService>();

  StudentProfile studentProfile;
  Semester lastSemester;
  GradeBookDetail lastGradeBookDetail;
  List<Register> registerdSubjects;

  LMS get user => lmsService.user;
  String get userFirstName =>
      studentProfile.name.split(" ")[0].toLowerCase().capitalize();

  void onError(dynamic err) async {
    if (err is LMSException)
      await dialogService.showCustomDialog(
          title: err.message, description: err.description);
  }

  Future<void> init() async {
    this.setBusyForObject(studentProfile, true);
    this.setBusyForObject(lastSemester, true);
    this.setBusyForObject(lastGradeBookDetail, true);
    this.setBusyForObject(registerdSubjects, true);
    user.getStudentProfile().then((value) {
      studentProfile = value;
      this.setBusyForObject(studentProfile, false);
    }).catchError(onError);
    user.getRegisteredSemesters().then((value) async {
      lastSemester = value.first;
      this.setBusyForObject(lastSemester, false);
      registerdSubjects =
          await user.getRegisteredSubjects(semester: lastSemester);
      this.setBusyForObject(registerdSubjects, false);
    }).catchError(onError);
    user.getSemestersSummary().then((value) {
      lastGradeBookDetail = value.last;
      this.setBusyForObject(lastGradeBookDetail, false);
    }).catchError(onError);
  }
}