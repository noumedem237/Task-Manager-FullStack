import '../../data/models/task_model.dart';

abstract interface class TasksRepository {
  Future<List<TaskModel>> getAll();
  Future<TaskModel> create(String title, String description, TaskStatus status);
  Future<TaskModel> update(int id, String title, String description, TaskStatus status);
  Future<void> delete(int id);
}
