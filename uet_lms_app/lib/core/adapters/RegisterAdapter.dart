import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:lms_api/models/obe.core.register.dart';
import 'package:uet_lms/core/constants.dart';

class RegisterAdapter extends TypeAdapter<Register> {
  @override
  final typeId = kRegisterHiveType;

  @override
  Register read(BinaryReader reader) {
    return Register.fromJson(jsonDecode(reader.readString()));
  }

  @override
  void write(BinaryWriter writer, Register register) {
    writer.write(jsonEncode(register.toJson()));
  }
}
