import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/tasks/tasks_cubit.dart';
import 'widgets/task_tile.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasksCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Tasks')),
        body: BlocBuilder<TasksCubit, TasksState>(
          builder: (context, state) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.tasks.length,
              itemBuilder: (_, i) => TaskTile(task: state.tasks[i]),
            );
          },
        ),
      ),
    );
  }
}