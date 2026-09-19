import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/core/app_screen_scale.dart';
import '../../../../app/routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool showPassword = false;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (_, constraints) {
          final scale = AppScreenScale.fromConstraints(constraints);
          final controller = Get.find<AuthController>();
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(scale.v(24)),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: scale.v(460)),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '✓  Taskflow',
                        style: TextStyle(
                          fontSize: scale.v(30),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF009C9A),
                        ),
                      ),
                      SizedBox(height: scale.v(38)),
                      Text(
                        'Créez votre espace',
                        style: TextStyle(
                          fontSize: scale.v(28),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: scale.v(8)),
                      const Text(
                        'Commencez à organiser vos tâches en quelques secondes.',
                      ),
                      Obx(() => controller.errorMessage.value.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.only(top: scale.v(18)),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0E6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  controller.errorMessage.value,
                                  style: const TextStyle(color: Color(0xFFA64800)),
                                ),
                              ),
                            )),
                      SizedBox(height: scale.v(26)),
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Adresse e-mail',
                        ),
                        validator: (v) =>
                            RegExp(
                              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                            ).hasMatch(v ?? '')
                            ? null
                            : 'Saisissez une adresse e-mail valide',
                      ),
                      SizedBox(height: scale.v(14)),
                      TextFormField(
                        controller: password,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () =>
                                setState(() => showPassword = !showPassword),
                          ),
                        ),
                        validator: (v) => (v?.length ?? 0) >= 8
                            ? null
                            : '8 caractères minimum',
                      ),
                      SizedBox(height: scale.v(22)),
                      Obx(
                        () => FilledButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    controller.register(
                                      email.text.trim(),
                                      password.text,
                                    );
                                  }
                                },
                          style: FilledButton.styleFrom(
                            minimumSize: Size.fromHeight(scale.v(52)),
                          ),
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Créer mon compte'),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.offNamed(AppRoutes.login),
                        child: const Text(
                          'Vous avez déjà un compte ? Se connecter',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
