class UserPreferences {
  String theme;
  bool notifyGradeUpdate;

  UserPreferences({this.theme, this.notifyGradeUpdate});
  
  UserPreferences.from(Map<String, dynamic> map) {
    theme = map['theme'];
    notifyGradeUpdate = map['notifyGradeUpdate'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {};
    map['theme'] = theme;
    map['notifyGradeUpdate'] = notifyGradeUpdate;
    return map;
  }
}