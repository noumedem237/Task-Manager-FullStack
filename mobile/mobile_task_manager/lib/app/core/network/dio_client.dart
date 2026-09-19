import 'package:dio/dio.dart';

import '../../config/app_constants.dart';
import '../storage/secure_token_storage.dart';
import 'api_exception.dart';

class DioClient {
  DioClient(this._tokenStorage)
      : dio = Dio(BaseOptions(
          baseUrl: AppConstants.apiBaseUrl,
          connectTimeout: AppConstants.connectTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
          headers: const {'Accept': 'application/json'},
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _tokenStorage.readToken();
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        handler.next(options);
      },
      onError: (error, handler) {
        final statusCode = error.response?.statusCode;
        final payload = error.response?.data;
        final message = payload is Map<String, dynamic> ? payload['message'] as String? : null;
        handler.reject(DioException(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
          error: ApiException(message ?? _messageFor(statusCode), statusCode: statusCode),
        ));
      },
    ));
  }

  final SecureTokenStorage _tokenStorage;
  final Dio dio;

  String _messageFor(int? statusCode) {
    if (statusCode == 401) return 'Votre session a expiré.';
    if (statusCode != null && statusCode >= 500) return 'Le serveur est indisponible. Réessayez plus tard.';
    return 'Une erreur réseau est survenue.';
  }
}
