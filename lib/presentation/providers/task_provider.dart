import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/supabase/supabase_client.dart';
import '../../data/repositories/task_repository.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/entities/task_entity.dart';

// 1. Provider del Repositorio
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl(SupabaseConfig.client);
});

// 2. StateNotifier para manejar la lista de tareas en la UI
final tasksListProvider = AsyncNotifierProvider<TasksListNotifier, List<TaskEntity>>(() {
  return TasksListNotifier();
});

class TasksListNotifier extends AsyncNotifier<List<TaskEntity>> {
  @override
  Future<List<TaskEntity>> build() async {
    return ref.watch(taskRepositoryProvider).getTasks();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(taskRepositoryProvider).getTasks());
  }
}
