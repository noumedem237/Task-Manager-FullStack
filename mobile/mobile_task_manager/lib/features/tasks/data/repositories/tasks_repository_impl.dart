import '../../domain/repositories/tasks_repository.dart';
import '../datasources/tasks_remote_data_source.dart';
import '../models/task_model.dart';
class TasksRepositoryImpl implements TasksRepository {
  const TasksRepositoryImpl(this._remote);
  final TasksRemoteDataSource _remote;
  @override
  Future<List<TaskModel>> getAll() => _remote.getAll();
}
