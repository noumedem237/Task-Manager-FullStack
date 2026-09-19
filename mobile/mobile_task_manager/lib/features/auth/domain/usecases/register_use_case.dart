import '../repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);
  final AuthRepository _repository;
  Future<void> call({required String email, required String password}) =>
      _repository.register(email: email, password: password);
}
