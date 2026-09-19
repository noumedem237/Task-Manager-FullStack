import '../../data/models/task_model.dart';
import '../repositories/tasks_repository.dart';
class GetTasksUseCase { const GetTasksUseCase(this._repository); final TasksRepository _repository; Future<List<TaskModel>> call() => _repository.getAll(); }
