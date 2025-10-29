// presentation/screens/team/widgets/team_member_tile.dart
import 'package:flutter/material.dart';

import '../../../cubits/team/team_cubit.dart';

class TeamMemberTile extends StatelessWidget {
  final TeamMember member;

  const TeamMemberTile({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final statusColor = switch (member.status) {
      'online' => Colors.green,
      'away' => Colors.orange,
      _ => Colors.grey,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(child: Text(member.name.split(' ').map((n) => n[0]).join())),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(radius: 6, backgroundColor: statusColor),
            ),
          ],
        ),
        title: Text(member.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.role),
            Text(member.dept, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}