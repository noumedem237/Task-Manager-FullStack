import '../../data/models/task_model.dart';
abstract interface class TasksRepository { Future<List<TaskModel>> getAll(); }
