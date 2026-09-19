enum TaskStatus { todo, inProgress, done }

class TaskModel {
  const TaskModel({required this.id, required this.title, this.description, required this.status});
  final int id;
  final String title;
  final String? description;
  final TaskStatus status;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String?,
        status: TaskStatus.values.byName((json['status'] as String).toLowerCase().replaceAll('_', '')),
      );
}
