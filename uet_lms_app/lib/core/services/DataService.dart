import 'package:async/async.dart' hide Result;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:injectable/injectable.dart';
import 'package:lms_api/LMS.dart';
import 'package:lms_api/models/obe.core.register.dart';
import 'package:lms_api/models/obe.core.result.dart';
import 'package:lms_api/models/obe.core.semester.dart';
import 'package:lms_api/models/obe.core.student.dart';
import 'package:lms_api/models/obe.dues.students.challan.dart';
import 'package:lms_api/models/obe.grade.book.detail.dart';
import 'package:uet_lms/core/services/AuthService.dart';
import 'package:hive/hive.dart';
import 'package:uet_lms/core/services/NotificationService.dart';

import '../locator.dart';
import '../utils.dart';

@singleton
class DataService {
  final AuthService authService = I<AuthService>();

  LMS get user => authService.user;

  // data instants;
  final _studentProfile = AsyncCache<StudentProfile>(Duration(hours: 1));
  final _semesters = AsyncCache<List<Semester>>(Duration(hours: 1));
  final _gradeBookDetails =
      AsyncCache<List<GradeBookDetail>>(Duration(hours: 1));
  final _registerdSubjects = AsyncCache<List<Register>>(Duration(hours: 1));
  final _challans = AsyncCache<List<Challan>>(Duration(hours: 1));
  final _result = AsyncCache<List<Result>>(Duration(hours: 1));
  final Map<int, AsyncCache<double>> _attendance = {};

  Future<double> getAttendance({bool refresh = false, Register subject}) {
    if (!_attendance.containsKey(subject.id)) {
      _attendance[subject.id] = AsyncCache<double>(Duration(hours: 1));
    } else {
      if (refresh) _attendance[subject.id].invalidate();
    }

    return _attendance[subject.id].fetch(() async {
      return user.getAttendanceForRegisteredCourse(subject);
    });
  }

  Future<List<Result>> getResult({bool refresh = false}) async {
    if (refresh) _result.invalidate();
    return _result.fetch(() async {
      return user.getResult();
    });
  }

  Future<StudentProfile> getStudentProfile({bool refresh = false}) async {
    if (refresh) _studentProfile.invalidate();
    return _studentProfile.fetch(() async {
      return user.getStudentProfile();
    });
  }

  Future<List<Semester>> getRegisteredSemesters({bool refresh = false}) async {
    if (refresh) _result.invalidate();
    return _semesters.fetch(() async {
      return user.getRegisteredSemesters();
    });
  }

  Future<List<GradeBookDetail>> getSemestersSummary(
      {bool refresh = false}) async {
    if (refresh) _gradeBookDetails.invalidate();
    return _gradeBookDetails.fetch(() async {
      return user.getSemestersSummary();
    });
  }

  Future<List<Register>> getRegisteredSubjects(
      {bool refresh = false, Semester semester}) async {
    if (refresh) _registerdSubjects.invalidate();
    return _registerdSubjects.fetch(() async {
      return user.getRegisteredSubjects(semester: semester);
    });
  }

  Future<List<Challan>> getFeesChallans({bool refresh = false}) async {
    if (refresh) _challans.invalidate();
    return _challans.fetch(() async {
      return user.getFeesChallans();
    });
  }

  void invalidate() {
    _studentProfile.invalidate();
    _semesters.invalidate();
    _gradeBookDetails.invalidate();
    _registerdSubjects.invalidate();
    _challans.invalidate();
    _result.invalidate();
  }

  Future<void> checkResultAndNotify() async {
    FirebaseAnalytics analytics = I<FirebaseAnalytics>();
    await analytics.logEvent(name: "result_check_start");

    try {
      if (!I<AuthService>().loggedIn) {
        if (await I<AuthService>().canReAuth()) {
          await I<AuthService>().reAuth();
        } else {
          return;
        }
      }

      final resultBoxName = userBox("results");
      final data = await I<DataService>().getResult(refresh: true);

      if (!Hive.isBoxOpen(resultBoxName)) {
        await Hive.openBox<Result>(resultBoxName);
      }

      final resultBox = Hive.box<Result>(resultBoxName);

      for (Result each in data) {
        if (resultBox.containsKey(each.id)) {
          // check if result is changed
          if (each.grade == resultBox.get(each.id).grade) {
            continue;
          }
        } else {
          // result is new
          resultBox.put(each.id, each);
        }
        if (each.semesterName.toLowerCase() ==
            (await I<DataService>().getRegisteredSemesters())
                .first
                .name
                .toLowerCase()) {
          print("Result changed ${each.subject.name} ${each.grade}");
          await I<NotificationService>().showNotification(
              title: "New Result",
              body:
                  "Result for ${each.subject.name} has been published, you got ${each.grade}");
          await analytics.logEvent(name: "notified_result_change");
        }
      }
      await analytics.logEvent(name: "result_check_completed");
    } catch (e) {
      await analytics.logEvent(
          name: "result_check_failed", parameters: {"error": e.toString()});
      rethrow;
    }
  }

  //  Future<void> checkAttendanceAndNotify() async {
  //   FirebaseAnalytics analytics = I<FirebaseAnalytics>();
  //   await analytics.logEvent(name: "attendance_check_start");

  //   try {
  //     if (!I<AuthService>().loggedIn) {
  //       if (await I<AuthService>().canReAuth()) {
  //         await I<AuthService>().reAuth();
  //       } else {
  //         return;
  //       }
  //     }

  //     final attendanceBox = userBox("attendance");
  //     final
  //     final data = await I<DataService>().user.getAttendanceForRegisteredCourse();

  //     if (!Hive.isBoxOpen(attendanceBox)) {
  //       await Hive.openBox<Result>(attendanceBox);
  //     }

  //     final resultBox = Hive.box<Result>(attendanceBox);

  //         await analytics.logEvent(name: "notified_attendance_change");
  //     await analytics.logEvent(name: "attendance_check_completed");
  //   } catch (e) {
  //     await analytics
  //         .logEvent(name: "attendance_check_failed", parameters: {"error": e.toString()});
  //     rethrow;
  //   }
  // }
}
