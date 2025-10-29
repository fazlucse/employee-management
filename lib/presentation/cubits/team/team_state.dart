// presentation/cubits/team/team_state.dart
part of 'team_cubit.dart';

class TeamMember {
  final String name;
  final String role;
  final String status; // online, away, offline
  final String dept;

  const TeamMember(this.name, this.role, this.status, this.dept);
}

class TeamState {
  final List<TeamMember> members;
  const TeamState(this.members);

  factory TeamState.initial() => TeamState([
        const TeamMember('Sarah Johnson', 'Project Manager', 'online', 'Engineering'),
        const TeamMember('Mike Chen', 'Senior Developer', 'online', 'Engineering'),
        const TeamMember('Emma Williams', 'UX Designer', 'away', 'Design'),
        const TeamMember('James Brown', 'Backend Developer', 'offline', 'Engineering'),
        const TeamMember('Lisa Anderson', 'QA Engineer', 'online', 'Quality'),
      ]);
}