abstract interface class AuthRepository {
  Future<void> login({required String email, required String password});
  Future<void> register({required String email, required String password});
  Future<bool> hasSession();
  Future<void> logout();
}
