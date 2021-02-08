import 'package:async/async.dart' hide Result;
import 'package:injectable/injectable.dart';
import 'package:lms_api/LMS.dart';
import 'package:lms_api/models/obe.core.register.dart';
import 'package:lms_api/models/obe.core.result.dart';
import 'package:lms_api/models/obe.core.semester.dart';
import 'package:lms_api/models/obe.core.student.dart';
import 'package:lms_api/models/obe.dues.students.challan.dart';
import 'package:lms_api/models/obe.grade.book.detail.dart';
import 'package:uet_lms/core/services/AuthService.dart';

import '../locator.dart';

@lazySingleton
class DataService {
  final AuthService authService = I<AuthService>();

  LMS get user => authService.user;

  // data instants;
  final _studentProfile = AsyncCache<StudentProfile>(Duration(hours: 1));
  final _semesters = AsyncCache<List<Semester>>(Duration(hours: 1));
  final _gradeBookDetails = AsyncCache<List<GradeBookDetail>>(Duration(hours: 1));
  final _registerdSubjects = AsyncCache<List<Register>>(Duration(hours: 1));
  final _challans = AsyncCache<List<Challan>>(Duration(hours: 1));
  final _result = AsyncCache<List<Result>>(Duration(hours: 1));

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

  Future<List<Register>> getRegisteredSubjects({bool refresh = false}) async {
    if (refresh) _registerdSubjects.invalidate();
    return _registerdSubjects.fetch(() async {
      return user.getRegisteredSubjects();
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
}
