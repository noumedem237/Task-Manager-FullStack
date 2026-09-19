import 'package:dio/dio.dart';

import '../models/auth_response_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);
  final Dio _dio;

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return _parseResponse(response.data);
  }

  Future<AuthResponseModel> register({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/register',
      data: {'email': email, 'password': password},
    );
    return _parseResponse(response.data);
  }

  AuthResponseModel _parseResponse(Map<String, dynamic>? data) {
    if (data == null) {
      throw const FormatException('La réponse du serveur est vide.');
    }
    return AuthResponseModel.fromJson(data);
  }
}
