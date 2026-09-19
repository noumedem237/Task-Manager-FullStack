import 'package:get/get.dart';
import '../../data/models/task_model.dart';
import '../../domain/usecases/get_tasks_use_case.dart';
class TasksController extends GetxController {
  TasksController(this._getTasks); final GetTasksUseCase _getTasks;
  final tasks = <TaskModel>[].obs; final isLoading = false.obs;
  @override void onReady() { super.onReady(); load(); }
  Future<void> load() async { isLoading.value = true; try { tasks.assignAll(await _getTasks()); } catch (error) { Get.snackbar('Erreur', error.toString()); } finally { isLoading.value = false; } }
}
