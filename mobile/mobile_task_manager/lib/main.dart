import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskflowApp());
}

class TaskflowApp extends StatelessWidget {
  const TaskflowApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: 'Taskflow',
        debugShowCheckedModeBanner: false,
        // initialBinding: InitialBinding(),
        initialRoute: AppRoutes.login,
        // getPages: AppPages.pages,
        theme: AppTheme.light,
      );
}
