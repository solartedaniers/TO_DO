class TaskEntity {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final String startTime;
  final bool isCompleted;
  final String? categoryId;
  final String? fileUrl;

  TaskEntity({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    required this.startTime,
    this.isCompleted = false,
    this.categoryId,
    this.fileUrl,
  });
}