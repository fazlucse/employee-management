// presentation/cubits/stats/stats_state.dart
part of 'stats_cubit.dart';

class StatsState {
  final int workingHoursThisWeek;
  final int tasksCompleted;
  final int totalHoursMonth;
  final int tasksDoneMonth;

  const StatsState({
    required this.workingHoursThisWeek,
    required this.tasksCompleted,
    required this.totalHoursMonth,
    required this.tasksDoneMonth,
  });

  factory StatsState.initial() => const StatsState(
        workingHoursThisWeek: 22,
        tasksCompleted: 12,
        totalHoursMonth: 86,
        tasksDoneMonth: 45,
      );
}