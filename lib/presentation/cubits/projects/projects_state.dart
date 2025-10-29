// presentation/cubits/projects/projects_state.dart
part of 'projects_cubit.dart';

class ProjectItem {
  final String name;
  final int progress;
  final int tasks;
  final String deadline;
  final String status;

  const ProjectItem(this.name, this.progress, this.tasks, this.deadline, this.status);
}

class ProjectsState {
  final List<ProjectItem> projects;
  const ProjectsState(this.projects);

  factory ProjectsState.initial() => ProjectsState([
        const ProjectItem('Mobile App Redesign', 75, 12, 'Nov 15, 2025', 'active'),
        const ProjectItem('API Integration', 45, 8, 'Nov 30, 2025', 'active'),
        const ProjectItem('Dashboard Analytics', 90, 15, 'Nov 5, 2025', 'review'),
        const ProjectItem('User Authentication', 100, 10, 'Oct 20, 2025', 'completed'),
      ]);
}