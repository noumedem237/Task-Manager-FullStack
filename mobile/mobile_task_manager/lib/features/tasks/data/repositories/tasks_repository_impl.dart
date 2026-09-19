import '../../domain/repositories/tasks_repository.dart';
import '../../../../app/core/storage/app_preferences.dart';
import '../datasources/tasks_remote_data_source.dart';
import '../models/task_model.dart';

class TasksRepositoryImpl implements TasksRepository {
  const TasksRepositoryImpl(this._remote, this._preferences);
  final TasksRemoteDataSource _remote;
  final AppPreferences _preferences;

  @override
  Future<List<TaskModel>> getAll() async {
    try {
      final tasks = await _remote.getAll();
      await _cache(tasks);
      return tasks;
    } catch (_) {
      final cached = _preferences.cachedTasks.map(TaskModel.fromJson).toList();
      if (cached.isNotEmpty) return cached;
      rethrow;
    }
  }

  @override
  Future<TaskModel> create(
    String title,
    String description,
    TaskStatus status,
  ) async {
    final task = await _remote.create(title, description, status);
    await _updateCache((tasks) => [task, ...tasks]);
    return task;
  }

  @override
  Future<TaskModel> update(
    int id,
    String title,
    String description,
    TaskStatus status,
  ) async {
    final task = await _remote.update(id, title, description, status);
    await _updateCache(
      (tasks) => tasks.map((item) => item.id == id ? task : item).toList(),
    );
    return task;
  }

  @override
  Future<void> delete(int id) async {
    await _remote.delete(id);
    await _updateCache(
      (tasks) => tasks.where((task) => task.id != id).toList(),
    );
  }

  Future<void> _cache(List<TaskModel> tasks) =>
      _preferences.saveTasks(tasks.map((task) => task.toJson()).toList());

  Future<void> _updateCache(
    List<TaskModel> Function(List<TaskModel>) transform,
  ) async {
    final cached = _preferences.cachedTasks.map(TaskModel.fromJson).toList();
    await _cache(transform(cached));
  }
}
