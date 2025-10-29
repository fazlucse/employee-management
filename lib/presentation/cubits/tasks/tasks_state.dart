part of 'tasks_cubit.dart';

class TasksState {
  final List<Task> tasks;
  const TasksState(this.tasks);
}

class Task {
  final String title;
  final String status;
  final String priority;
  const Task(this.title, this.status, this.priority);
}