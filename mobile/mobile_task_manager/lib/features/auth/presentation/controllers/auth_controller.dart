import 'package:get/get.dart';

import '../../../../app/routes/app_pages.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/register_use_case.dart';

class AuthController extends GetxController {
  AuthController(this._repository, this._login, this._register);
  final AuthRepository _repository;
  final LoginUseCase _login;
  final RegisterUseCase _register;
  final isLoading = false.obs;

  Future<void> login(String email, String password) => _authenticate(() => _login(email: email, password: password));
  Future<void> register(String email, String password) => _authenticate(() => _register(email: email, password: password));

  Future<void> _authenticate(Future<void> Function() action) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await action();
      Get.offAllNamed(AppRoutes.tasks);
    } catch (error) {
      Get.snackbar('Erreur', error.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}
