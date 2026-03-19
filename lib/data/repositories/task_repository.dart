import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final SupabaseClient _supabase;

  TaskRepositoryImpl(this._supabase);

  @override
  Future<List<TaskEntity>> getTasks() async {
    final response = await _supabase
        .from('tasks')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List).map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<void> createTask(TaskEntity task, File? imageFile) async {
    String? fileUrl;

    // Si hay una imagen, la subimos al Bucket 'task_files'
    if (imageFile != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      await _supabase.storage.from('task_files').upload(fileName, imageFile);
      fileUrl = _supabase.storage.from('task_files').getPublicUrl(fileName);
    }

    final model = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      date: task.date,
      startTime: task.startTime,
      isCompleted: task.isCompleted,
      categoryId: task.categoryId,
      fileUrl: fileUrl,
    );

    await _supabase.from('tasks').insert(model.toJson());
  }

  @override
  Future<void> updateTaskStatus(String id, bool isCompleted) async {
    await _supabase.from('tasks').update({'is_completed': isCompleted}).eq('id', id);
  }

  @override
  Future<void> deleteTask(String id) async {
    await _supabase.from('tasks').delete().eq('id', id);
  }
}