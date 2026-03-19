import '../entities/task_entity.dart';
import 'dart:io';

abstract class TaskRepository {
  Future<List<TaskEntity>> getTasks();
  Future<void> createTask(TaskEntity task, File? imageFile);
  Future<void> updateTaskStatus(String id, bool isCompleted);
  Future<void> deleteTask(String id);
}