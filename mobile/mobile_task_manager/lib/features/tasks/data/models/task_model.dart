enum TaskStatus { todo, inProgress, done }

class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
  });
  final int id;
  final String title;
  final String? description;
  final TaskStatus status;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: (json['id'] as num).toInt(),
    title: json['title'] as String? ?? '',
    description: json['description'] as String?,
    status: switch (json['status']) {
      'IN_PROGRESS' => TaskStatus.inProgress,
      'DONE' => TaskStatus.done,
      _ => TaskStatus.todo,
    },
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status == TaskStatus.done
        ? 'DONE'
        : status == TaskStatus.inProgress
        ? 'IN_PROGRESS'
        : 'TODO',
  };
}
