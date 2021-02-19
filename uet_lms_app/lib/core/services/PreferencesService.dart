import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uet_lms/core/models/UserPreferences.dart';

@lazySingleton
class PreferencesService {
  static String keyName = "userPreferences";

  SharedPreferences plugin;
  UserPreferences _preferences;

  UserPreferences get preferences => _preferences;

  Future<void> init() async {
    plugin = await SharedPreferences.getInstance();
    return this.load();
  }

  Future<void> update(UserPreferences updatedPreferences) async {
    final uMap = updatedPreferences.toMap();
    final oMap = _preferences.toMap();
    for (final entry in uMap.entries) {
      if (entry.value != null) oMap[entry.key] = uMap[entry.key];
    }
    _preferences = UserPreferences.from(oMap);
    return this.save();
  }

  Future<void> load() async {
    final json = plugin.getString(keyName);
    if (json != null) {
      _preferences = UserPreferences.from(
        jsonDecode(json),
      );
    } else {
      _preferences = UserPreferences();
    }
  }

  Future<void> save() async {
    await plugin.setString(
      keyName,
      jsonEncode(
        preferences.toMap(),
      ),
    );
  }
}
