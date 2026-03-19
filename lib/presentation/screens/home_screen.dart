import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Cambia 'task_pro_supabase' por el nombre de tu proyecto si es distinto
import 'package:task_pro_supabase/theme/app_colors.dart';
import 'package:task_pro_supabase/presentation/providers/task_provider.dart';
import 'package:task_pro_supabase/presentation/widgets/progress_card.dart';
import 'package:task_pro_supabase/presentation/widgets/task_tile.dart';
import 'package:task_pro_supabase/presentation/screens/add_task_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksListProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const ProgressCard(),
              const SizedBox(height: 30),
              
              // TÍTULO DINÁMICO (Muestra X de Y tareas)
              tasksAsync.when(
                data: (tasks) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Today Tasks',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${tasks.where((t) => t.isCompleted).length} of ${tasks.length}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                loading: () => const Text('Today Tasks', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                error: (_, __) => const Text('Today Tasks'),
              ),
              
              const SizedBox(height: 12),

              // BARRITA DE PROGRESO DINÁMICA (Sigue a la "bola")
              tasksAsync.when(
                data: (tasks) {
                  final total = tasks.length;
                  final completed = tasks.where((t) => t.isCompleted).length;
                  final double progress = total > 0 ? completed / total : 0.0;
                  
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress, // Valor real de 0.0 a 1.0
                      minHeight: 10,
                      backgroundColor: AppColors.progressEmpty,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const SizedBox(),
              ),

              const SizedBox(height: 25),
              
              Expanded(
                child: tasksAsync.when(
                  data: (tasks) => ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskTile(
                        task: task,
                        onToggle: (val) {
                          ref.read(taskRepositoryProvider).updateTaskStatus(
                                task.id,
                                val ?? false,
                              );
                          ref.read(tasksListProvider.notifier).refresh();
                        },
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, st) => Center(child: Text('Error: $e')),
                ),
              ),
            ],
          ),
        ),
      ),

      // NUEVA BARRA DE NAVEGACIÓN IGUAL A LA IMAGEN
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.home_rounded, color: AppColors.primary, size: 32),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.description_outlined, color: Colors.grey, size: 28),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.donut_large_rounded, color: Colors.grey, size: 28),
                onPressed: () {},
              ),
              // BOTÓN MÁS CUADRADO Y A LA DERECHA
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddTaskScreen()),
                  );
                },
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}