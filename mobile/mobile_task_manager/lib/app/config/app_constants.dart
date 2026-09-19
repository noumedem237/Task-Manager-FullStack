abstract final class AppConstants {
  static const appName = 'Taskflow';
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
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
