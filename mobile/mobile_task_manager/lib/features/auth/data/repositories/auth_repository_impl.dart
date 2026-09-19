import '../../../../app/core/storage/secure_token_storage.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote, this._tokenStorage);
  final AuthRemoteDataSource _remote;
  final SecureTokenStorage _tokenStorage;

  @override
  Future<bool> hasSession() async => (await _tokenStorage.readToken()) != null;

  @override
  Future<void> login({required String email, required String password}) async {
    final response = await _remote.login(email: email, password: password);
    await _tokenStorage.saveToken(response.token);
  }

  @override
  Future<void> register({required String email, required String password}) async {
    final response = await _remote.register(email: email, password: password);
    await _tokenStorage.saveToken(response.token);
  }

  @override
  Future<void> logout() => _tokenStorage.clearToken();
}
