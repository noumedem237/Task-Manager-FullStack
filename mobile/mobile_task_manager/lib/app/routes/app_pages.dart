import 'package:get/get.dart';
// import '../../features/auth/presentation/pages/login_page.dart';
// import '../../features/auth/presentation/pages/register_page.dart';
// import '../../features/tasks/presentation/pages/tasks_page.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const tasks = '/tasks';
}

abstract final class AppPages {
  static final pages = [
    // GetPage(name: AppRoutes.login, page: LoginPage.new),
    // GetPage(name: AppRoutes.register, page: RegisterPage.new),
    // GetPage(name: AppRoutes.tasks, page: TasksPage.new),
  ];
}
