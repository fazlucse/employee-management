// presentation/screens/projects/widgets/project_tile.dart
import 'package:flutter/material.dart';

import '../../../cubits/projects/projects_cubit.dart';

class ProjectTile extends StatelessWidget {
  final ProjectItem project;

  const ProjectTile({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (project.status) {
      'completed' => Colors.green,
      'review' => Colors.orange,
      _ => Colors.blue,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(project.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                Chip(label: Text(project.status), backgroundColor: statusColor.withOpacity(0.1)),
              ],
            ),
            Text('Due: ${project.deadline}', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('${project.tasks} tasks'),
                const Spacer(),
                Text('${project.progress}%'),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: project.progress / 100, color: statusColor),
          ],
        ),
      ),
    );
  }
}