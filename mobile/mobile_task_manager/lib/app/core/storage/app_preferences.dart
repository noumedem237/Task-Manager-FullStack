import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_constants.dart';
import 'dart:convert';

class AppPreferences {
  const AppPreferences(this._preferences);

  final SharedPreferences _preferences;

  bool get isOnboardingSeen =>
      _preferences.getBool(StorageKeys.isOnboardingSeen) ?? false;
  Future<void> setOnboardingSeen() =>
      _preferences.setBool(StorageKeys.isOnboardingSeen, true);

  List<Map<String, dynamic>> get cachedTasks {
    final raw = _preferences.getString(StorageKeys.tasksCache);
    if (raw == null) return const [];
    try {
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return const [];
    }
  }

  Future<void> saveTasks(List<Map<String, dynamic>> tasks) =>
      _preferences.setString(StorageKeys.tasksCache, jsonEncode(tasks));
  Future<void> clearTasks() => _preferences.remove(StorageKeys.tasksCache);
}
