import 'package:get/get.dart';
import '../../data/models/task_model.dart';
import '../../domain/usecases/get_tasks_use_case.dart';
import '../../domain/repositories/tasks_repository.dart';

class TasksController extends GetxController {
  TasksController(this._getTasks, this._repository);

  final GetTasksUseCase _getTasks;
  final TasksRepository _repository;
  final tasks = <TaskModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final error = ''.obs;

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      tasks.assignAll(await _getTasks());
    } catch (caught) {
      error.value = caught.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> create(
    String title,
    String description,
    TaskStatus status,
  ) async =>
      _save(() => _repository.create(title, description, status), add: true);

  Future<bool> updateTask(
    TaskModel old,
    String title,
    String description,
    TaskStatus status,
  ) async => _save(
    () => _repository.update(old.id, title, description, status),
    old: old,
  );

  Future<bool> delete(int id) async {
    error.value = '';
    isSaving.value = true;
    try {
      await _repository.delete(id);
      tasks.removeWhere((task) => task.id == id);
      return true;
    } catch (caught) {
      error.value = caught.toString();
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> toggleCompletion(TaskModel task) => updateTask(
        task,
        task.title,
        task.description ?? '',
        task.status == TaskStatus.done ? TaskStatus.todo : TaskStatus.done,
      );

  Future<bool> _save(
    Future<TaskModel> Function() action, {
    bool add = false,
    TaskModel? old,
  }) async {
    error.value = '';
    isSaving.value = true;
    try {
      final task = await action();
      if (add) {
        tasks.insert(0, task);
      } else {
        final index = tasks.indexWhere((item) => item.id == old!.id);
        if (index >= 0) tasks[index] = task;
      }
      return true;
    } catch (caught) {
      error.value = caught.toString();
      return false;
    } finally {
      isSaving.value = false;
    }
  }
}
