// presentation/screens/projects/projects_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/projects/projects_cubit.dart';
import 'widgets/project_tile.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectsCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Projects')),
        body: BlocBuilder<ProjectsCubit, ProjectsState>(
          builder: (context, state) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.projects.length,
              itemBuilder: (_, i) => ProjectTile(project: state.projects[i]),
            );
          },
        ),
      ),
    );
  }
}