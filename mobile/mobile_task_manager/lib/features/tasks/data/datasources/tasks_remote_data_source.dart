import 'package:dio/dio.dart';
import '../models/task_model.dart';

class TasksRemoteDataSource {
  const TasksRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<TaskModel>> getAll() async {
    final response = await _dio.get<List<dynamic>>('/tasks');
    return (response.data ?? const [])
        .whereType<Map>()
        .map((json) => TaskModel.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }

  Future<TaskModel> create(
    String title,
    String description,
    TaskStatus status,
  ) async => _save('/tasks', 'post', title, description, status);

  Future<TaskModel> update(
    int id,
    String title,
    String description,
    TaskStatus status,
  ) async => _save('/tasks/$id', 'put', title, description, status);

  Future<TaskModel> _save(
    String path,
    String method,
    String title,
    String description,
    TaskStatus status,
  ) async {
    final response = await _dio.request<Map<String, dynamic>>(
      path,
      options: Options(method: method),
      data: {
        'title': title,
        'description': description,
        'status': status == TaskStatus.done
            ? 'DONE'
            : status == TaskStatus.inProgress
            ? 'IN_PROGRESS'
            : 'TODO',
      },
    );
    final data = response.data;
    if (data == null) {
      throw StateError('La réponse de la tâche est vide.');
    }
    return TaskModel.fromJson(data);
  }

  Future<void> delete(int id) async {
    await _dio.delete<void>('/tasks/$id');
  }
}
