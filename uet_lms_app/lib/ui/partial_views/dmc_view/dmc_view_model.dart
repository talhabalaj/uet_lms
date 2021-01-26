import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lms_api/lms_api.dart';
import 'package:lms_api/models/obe.core.register.dart';
import 'package:lms_api/models/obe.core.result.dart';
import 'package:lms_api/models/obe.core.semester.dart';
import 'package:lms_api/models/obe.grade.book.detail.dart';
import 'package:stacked/stacked.dart';
import 'package:uet_lms/core/locator.dart';
import 'package:uet_lms/core/services/lms_service.dart';
import 'package:uet_lms/core/utils.dart';
import 'package:uet_lms/ui/ui_utils.dart';

class DMCViewModel extends BaseViewModel {
  final LMSService lmsService = locator<LMSService>();

  List<Semester> registeredSemesters;

  String _selectedSemester;
  List<Result> _result;
  List<GradeBookDetail> gradeBookDetails;
  List<Result> _filteredResult;
  List<Register> registeredSubjects;

  List<Result> get result => _filteredResult;

  get selectedSemester => _selectedSemester;
  set selectedSemester(String value) {
    _selectedSemester = value;
    _filteredResult = _result
        .where((a) =>
            registeredSubjects
                .firstWhere((b) => a.subject.name == b.subjectName)
                .semesterName ==
            _selectedSemester)
        .toList();
    this.notifyListeners();
  }

  Future<void> loadData({bool refresh = false}) async {
    this.clearErrors();
    this.setBusy(true);
    try {
      gradeBookDetails =
          (await lmsService.getSemestersSummary(refresh: refresh))
              .reversed
              .toList();

      registeredSemesters =
          await lmsService.getRegisteredSemesters(refresh: refresh);

      _result = await lmsService.getResult(refresh: refresh);

      if (_result.length == 0) {
        this.setError(LMSException("Nawa Aya Aein Soneya?",
            description: "No result has been declared for you. Intezar karo!"));

        this.setBusy(false);
        return;
      }

      registeredSubjects =
          await lmsService.getRegisteredSubjects(refresh: refresh);
      registeredSemesters = registeredSemesters.where((a) {
        final semesterSubjects = registeredSubjects
            .where((b) => a.name == b.semesterName)
            .map((e) => e.subjectName)
            .toList();
        final resultOfSubjects = _result.where(
            (element) => semesterSubjects.indexOf(element.subject.name) != -1);

        return resultOfSubjects.length > 0;
      }).toList();
      selectedSemester ??= registeredSemesters.first.name;
    } on Exception catch (e) {
      catchLMSorInternetException(e);
    }
    this.setBusy(false);
  }

  Color getGradeColor(Result result) {
    double amount = double.tryParse(result.subjectGPA) /
        double.tryParse(registeredSubjects
            .firstWhere((element) => element.subjectName == result.subject.name)
            .subjectCreditHour);
    return getPerColor(amount / 4 * 100);
  }
}