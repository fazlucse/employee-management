// presentation/screens/team/team_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/team/team_cubit.dart';
import 'widgets/team_member_tile.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TeamCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Team Directory')),
        body: BlocBuilder<TeamCubit, TeamState>(
          builder: (context, state) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.members.length,
              itemBuilder: (_, i) => TeamMemberTile(member: state.members[i]),
            );
          },
        ),
      ),
    );
  }
}