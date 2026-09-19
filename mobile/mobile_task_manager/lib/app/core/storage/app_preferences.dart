import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_constants.dart';

class AppPreferences {
  const AppPreferences(this._preferences);

  final SharedPreferences _preferences;

  bool get isOnboardingSeen => _preferences.getBool(StorageKeys.isOnboardingSeen) ?? false;
  Future<void> setOnboardingSeen() => _preferences.setBool(StorageKeys.isOnboardingSeen, true);
}
