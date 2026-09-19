import 'package:dio/dio.dart';

import '../models/auth_response_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);
  final Dio _dio;

  Future<AuthResponseModel> login({required String email, required String password}) async {
    final response = await _dio.post<Map<String, dynamic>>('/api/auth/login', data: {'email': email, 'password': password});
    return AuthResponseModel.fromJson(response.data!);
  }

  Future<AuthResponseModel> register({required String email, required String password}) async {
    final response = await _dio.post<Map<String, dynamic>>('/api/auth/register', data: {'email': email, 'password': password});
    return AuthResponseModel.fromJson(response.data!);
  }
}
