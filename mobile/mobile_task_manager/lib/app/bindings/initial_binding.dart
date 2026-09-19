import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_use_case.dart';
import '../../features/auth/domain/usecases/register_use_case.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/tasks/data/datasources/tasks_remote_data_source.dart';
import '../../features/tasks/data/repositories/tasks_repository_impl.dart';
import '../../features/tasks/domain/repositories/tasks_repository.dart';
import '../../features/tasks/domain/usecases/get_tasks_use_case.dart';
import '../../features/tasks/presentation/controllers/tasks_controller.dart';
import '../core/network/dio_client.dart';
import '../core/storage/secure_token_storage.dart';
import '../core/storage/app_preferences.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SecureTokenStorage(const FlutterSecureStorage()), permanent: true);
    Get.put(DioClient(Get.find()), permanent: true);
    Get.put(TasksRemoteDataSource(Get.find<DioClient>().dio), permanent: true);
    Get.put<AuthRepository>(AuthRepositoryImpl(AuthRemoteDataSource(Get.find<DioClient>().dio), Get.find()), permanent: true);
    Get.put(AuthController(Get.find(), LoginUseCase(Get.find()), RegisterUseCase(Get.find())), permanent: true);
    Get.put<TasksRepository>(TasksRepositoryImpl(TasksRemoteDataSource(Get.find<DioClient>().dio), Get.find<AppPreferences>()), permanent: true);
    Get.put(TasksController(GetTasksUseCase(Get.find()), Get.find()), permanent: true);
  }
}
