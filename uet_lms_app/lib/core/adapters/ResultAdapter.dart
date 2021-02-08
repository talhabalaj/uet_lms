import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:lms_api/models/obe.core.result.dart';
import 'package:uet_lms/core/constants.dart';

class ResultAdapter extends TypeAdapter<Result> {
  @override
  final typeId = kResultHiveType;

  @override
  Result read(BinaryReader reader) {
    return Result.fromJson(jsonDecode(reader.readString()));
  }

  @override
  void write(BinaryWriter writer, Result result) {
    writer.write(jsonEncode(result.toJson()));
  }
}
