abstract final class AppConstants {
  static const appName = 'Taskflow';
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );
  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 15);
}

abstract final class StorageKeys {
  static const jwt = 'taskflow.jwt';
  static const isOnboardingSeen = 'taskflow.onboarding-seen';
}
