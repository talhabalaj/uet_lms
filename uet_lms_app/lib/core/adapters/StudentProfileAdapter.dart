import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:lms_api/lms_api.dart';
import 'package:uet_lms/core/constants.dart';

class StudentProfileAdapter extends TypeAdapter<StudentProfile> {
  @override
  StudentProfile read(BinaryReader reader) {
    return StudentProfile.fromJson(
      jsonDecode(
        reader.readString(),
      ),
    );
  }

  @override
  final typeId = kStudentProfileHiveType;

  @override
  void write(BinaryWriter writer, StudentProfile obj) {
    
  }
}
