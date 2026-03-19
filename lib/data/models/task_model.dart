import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    required super.id,
    required super.title,
    super.description,
    required super.date,
    required super.startTime,
    super.isCompleted,
    super.categoryId,
    super.fileUrl,
  });

  // Convertir JSON de Supabase a Modelo
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['task_date']),
      startTime: json['start_time'],
      isCompleted: json['is_completed'] ?? false,
      categoryId: json['category_id'],
      fileUrl: json['file_url'],
    );
  }

  // Convertir Modelo a JSON para guardar en Supabase
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'task_date': date.toIso8601String().split('T')[0], // Solo fecha YYYY-MM-DD
      'start_time': startTime,
      'is_completed': isCompleted,
      'category_id': categoryId,
      'file_url': fileUrl,
    };
  }
}