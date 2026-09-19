import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../../app/core/network/api_exception.dart';
import '../../../../app/routes/app_pages.dart';
import '../../../../app/core/storage/app_preferences.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/register_use_case.dart';

class AuthController extends GetxController {
  AuthController(this._repository, this._login, this._register);
  final AuthRepository _repository;
  final LoginUseCase _login;
  final RegisterUseCase _register;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  Future<void> login(String email, String password) =>
      _authenticate(() => _login(email: email, password: password), isLogin: true);
  Future<void> register(String email, String password) =>
      _authenticate(() => _register(email: email, password: password), isLogin: false);

  Future<void> _authenticate(Future<void> Function() action, {required bool isLogin}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    errorMessage.value = '';
    try {
      // The web application deliberately keeps the progress state visible for
      // two seconds, even when the API answers immediately.
      await Future.wait<void>([
        action(),
        Future<void>.delayed(const Duration(seconds: 2)),
      ]);
      Get.offAllNamed(AppRoutes.tasks);
    } catch (error) {
      final message = _messageFor(error, isLogin: isLogin);
      errorMessage.value = message;
      Get.snackbar(
        'Erreur',
        message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _messageFor(Object error, {required bool isLogin}) {
    final apiError = error is ApiException
        ? error
        : error is DioException && error.error is ApiException
            ? error.error! as ApiException
            : null;
    if (apiError == null) return 'Impossible de joindre le serveur. Vérifiez votre réseau.';
    if (!isLogin && apiError.statusCode == 409) {
      return 'Cet e-mail est déjà utilisé. Connectez-vous ou utilisez une autre adresse.';
    }
    if (isLogin && apiError.statusCode == 401) {
      return 'Adresse e-mail ou mot de passe incorrect.';
    }
    if (apiError.validationErrors.isNotEmpty) return apiError.validationErrors.values.first;
    return apiError.message;
  }

  Future<void> logout() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      await _repository.logout();
      await Get.find<AppPreferences>().clearTasks();
      Get.offAllNamed(AppRoutes.login);
    } finally {
      isLoading.value = false;
    }
  }
}
