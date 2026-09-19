abstract final class AppConstants {
  static const appName = 'Taskflow';
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    // Android emulator: use http://10.0.2.2:8080/api.
    // Physical device: replace the IP with the computer's LAN IP.
    defaultValue: 'http://192.168.137.1:8080/api',
  );
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 15);
}

abstract final class StorageKeys {
  static const jwt = 'taskflow.jwt';
  static const isOnboardingSeen = 'taskflow.onboarding-seen';
  static const tasksCache = 'taskflow.tasks-cache';
}
