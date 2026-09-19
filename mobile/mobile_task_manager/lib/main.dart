import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/core/storage/app_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AppPreferences(await SharedPreferences.getInstance()), permanent: true);
  runApp(const TaskflowApp());
}

class TaskflowApp extends StatelessWidget {
  const TaskflowApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: 'Taskflow',
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
        theme: AppTheme.light,
      );
}


