import 'package:dio/dio.dart';
import '../models/task_model.dart';

class TasksRemoteDataSource {
  const TasksRemoteDataSource(this._dio);
  final Dio _dio;

  Future<List<TaskModel>> getAll() async {
    final response = await _dio.get<List<dynamic>>('/api/tasks');
    return response.data!.cast<Map<String, dynamic>>().map(TaskModel.fromJson).toList();
  }
}
