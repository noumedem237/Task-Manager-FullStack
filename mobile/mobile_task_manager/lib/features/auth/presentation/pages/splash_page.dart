import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/core/app_screen_scale.dart';
import '../../../../app/routes/app_pages.dart';
import '../../domain/repositories/auth_repository.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final session = await Get.find<AuthRepository>().hasSession();
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (mounted) Get.offAllNamed(session ? AppRoutes.tasks : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (_, c) {
          final scale = AppScreenScale.fromConstraints(c);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: const Color(0xFF009C9A),
                  size: scale.v(76),
                ),
                SizedBox(height: scale.v(14)),
                Text(
                  'Taskflow',
                  style: TextStyle(
                    fontSize: scale.v(32),
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF009C9A),
                  ),
                ),
                SizedBox(height: scale.v(42)),
                SizedBox(
                  width: scale.v(28),
                  height: scale.v(28),
                  child: const CircularProgressIndicator(strokeWidth: 3),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
