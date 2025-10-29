import 'package:bloc/bloc.dart';
part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(TasksState(_initialTasks));

  static final _initialTasks = [
    Task('Complete project documentation', 'pending', 'high'),
    Task('Review code changes', 'pending', 'medium'),
    Task('Team meeting at 3 PM', 'pending', 'low'),
    Task('Update dashboard design', 'completed', 'high'),
  ];
}