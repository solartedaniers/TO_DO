import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:task_pro_supabase/presentation/providers/task_provider.dart';
import 'package:task_pro_supabase/theme/app_colors.dart';

class ProgressCard extends ConsumerWidget {
  const ProgressCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksListProvider);

    return tasksAsync.when(
      data: (tasks) {
        // LÓGICA DEL CONTADOR
        final totalTasks = tasks.length;
        final completedTasks = tasks.where((t) => t.isCompleted).length;
        
        // Evitar división por cero si no hay tareas
        final double percentage = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            children: [
              CircularPercentIndicator(
                radius: 45.0,
                lineWidth: 8.0,
                percent: percentage, // Sube y baja automáticamente
                center: Text("${(percentage * 100).toInt()}%", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                progressColor: AppColors.primary,
                backgroundColor: AppColors.progressEmpty,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Weekly Tasks", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildCounter(completedTasks.toString(), Colors.green.shade50, AppColors.primary),
                      const SizedBox(width: 10),
                      _buildCounter((totalTasks - completedTasks).toString(), Colors.red.shade50, Colors.red),
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text("Error calculando progreso"),
    );
  }

  Widget _buildCounter(String count, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(count, style: TextStyle(color: text, fontWeight: FontWeight.bold)),
    );
  }
}