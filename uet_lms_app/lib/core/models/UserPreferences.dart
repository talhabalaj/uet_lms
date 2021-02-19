class UserPreferences {
  String theme;
  bool notifyGradeUpdate;
  bool notifyAttendanceUpdate;

  UserPreferences({
    this.theme = "system",
    this.notifyGradeUpdate = true,
    this.notifyAttendanceUpdate = false,
  });

  UserPreferences.from(Map<String, dynamic> map) {
    theme = map['theme'];
    notifyGradeUpdate = map['notifyGradeUpdate'];
    notifyAttendanceUpdate = map['notifyAttendanceUpdate'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    map['theme'] = theme;
    map['notifyGradeUpdate'] = notifyGradeUpdate;
    map['notifyAttendanceUpdate'] = notifyAttendanceUpdate;
    return map;
  }
}
