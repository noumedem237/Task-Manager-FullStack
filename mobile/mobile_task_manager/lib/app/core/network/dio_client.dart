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
          sendTimeout: AppConstants.connectTimeout,
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
        final body = payload is Map
            ? Map<Object?, Object?>.from(payload)
            : const <Object?, Object?>{};
        final message = body['message'] is String
            ? body['message'] as String
            : _messageFor(statusCode);
        final rawValidationErrors = body['validationErrors'];
        final validationErrors = rawValidationErrors is Map
            ? rawValidationErrors.map((key, value) => MapEntry('$key', '$value'))
            : const <String, String>{};
        handler.reject(DioException(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
          error: ApiException(message, statusCode: statusCode, validationErrors: validationErrors),
        ));
      },
    ));
  }

  final SecureTokenStorage _tokenStorage;
  final Dio dio;

  String _messageFor(int? statusCode) {
    if (statusCode == 401) return 'Votre session a expiré. Veuillez vous reconnecter.';
    if (statusCode == 400) return 'Les données envoyées sont invalides.';
    if (statusCode != null && statusCode >= 500) return 'Le serveur rencontre un problème. Réessayez plus tard.';
    return 'Connexion au serveur impossible. Vérifiez votre réseau.';
  }
}
