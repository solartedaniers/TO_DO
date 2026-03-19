import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';
import '../../theme/app_colors.dart';

class TaskTile extends StatelessWidget {
  final TaskEntity task;
  final Function(bool?) onToggle;

  const TaskTile({super.key, required this.task, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.isCompleted,
            onChanged: onToggle,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                color: task.isCompleted ? Colors.grey : Colors.black87,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.timeBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              task.startTime,
              style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}