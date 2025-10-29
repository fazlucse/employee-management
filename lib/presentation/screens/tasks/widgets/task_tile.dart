import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../cubits/tasks/tasks_cubit.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == 'completed';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(task.title, style: TextStyle(decoration: isDone ? TextDecoration.lineThrough : null)),
        subtitle: Row(
          children: [
            _priorityChip(task.priority),
            const SizedBox(width: 8),
            _statusChip(task.status),
          ],
        ),
        trailing: isDone ? const Icon(Icons.check_circle, color: AppColors.success) : const Icon(Icons.radio_button_unchecked),
      ),
    );
  }

  Widget _priorityChip(String p) {
    Color color;
    switch (p) {
      case 'high': color = AppColors.danger; break;
      case 'medium': color = AppColors.warning; break;
      default: color = AppColors.gray400 as Color;
    }
    return Chip(label: Text(p.toUpperCase(), style: const TextStyle(fontSize: 10)), backgroundColor: color.withOpacity(0.1), padding: EdgeInsets.zero);
  }

  Widget _statusChip(String s) => Chip(
    label: Text(s.toUpperCase(), style: const TextStyle(fontSize: 10)),
    // backgroundColor: s == 'completed' ? AppColors?.success.withOpacity(0.1) : AppColors?.gray100,
    padding: EdgeInsets.zero,
  );
}