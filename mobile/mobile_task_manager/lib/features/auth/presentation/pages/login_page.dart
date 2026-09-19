import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/core/app_screen_scale.dart';
import '../../../../app/routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = AppScreenScale.fromConstraints(
      BoxConstraints.tight(MediaQuery.sizeOf(context)),
    );
    final controller = Get.find<AuthController>();
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(scale.v(24)),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: scale.v(430)),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '✓  Taskflow',
                      style: TextStyle(
                        fontSize: scale.v(30),
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF009C9A),
                      ),
                    ),
                    SizedBox(height: scale.v(52)),
                    const Text(
                      'BIENVENUE À NOUVEAU',
                      style: TextStyle(
                        color: Color(0xFF009C9A),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                      ),
                    ),
                    SizedBox(height: scale.v(10)),
                    Text(
                      'Connectez-vous à votre espace',
                      style: TextStyle(
                        fontSize: scale.v(27),
                        height: 1.12,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF183837),
                      ),
                    ),
                    SizedBox(height: scale.v(10)),
                    const Text(
                      'Ravi de vous revoir. Vos tâches vous attendent.',
                      style: TextStyle(color: Color(0xFF648080)),
                    ),
                    Obx(() => controller.errorMessage.value.isEmpty
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: EdgeInsets.only(top: scale.v(18)),
                            child: _ErrorNotice(message: controller.errorMessage.value),
                          )),
                    SizedBox(height: scale.v(28)),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Adresse e-mail',
                        hintText: 'vous@exemple.com',
                      ),
                      validator: _emailError,
                    ),
                    SizedBox(height: scale.v(16)),
                    TextFormField(
                      controller: _password,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: 'Votre mot de passe',
                        suffixIcon: TextButton(
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                          child: Text(_showPassword ? 'Masquer' : 'Afficher'),
                        ),
                      ),
                      validator: _passwordError,
                    ),
                    SizedBox(height: scale.v(22)),
                    Obx(
                      () => FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7A00),
                          minimumSize: Size.fromHeight(scale.v(52)),
                        ),
                        onPressed: controller.isLoading.value ? null : _submit,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Se connecter  →'),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.offNamed(AppRoutes.register),
                      child: const Text(
                        'Pas encore de compte ? Créer un compte',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate())
      Get.find<AuthController>().login(_email.text.trim(), _password.text);
  }

  String? _emailError(String? value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value ?? '')
      ? null
      : 'Saisissez une adresse e-mail valide.';
  String? _passwordError(String? value) => (value?.length ?? 0) >= 8
      ? null
      : 'Le mot de passe doit contenir au moins 8 caractères.';
}

class _ErrorNotice extends StatelessWidget {
  const _ErrorNotice({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0E6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(message, style: const TextStyle(color: Color(0xFFA64800))),
      );
}
