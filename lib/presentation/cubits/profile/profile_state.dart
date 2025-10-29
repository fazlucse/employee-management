// presentation/cubits/profile/profile_state.dart
part of 'profile_cubit.dart';

class ProfileState {
  final String name;
  final String role;
  final String id;
  final String dept;
  final String email;
  final String joinDate;

  const ProfileState(this.name, this.role, this.id, this.dept, this.email, this.joinDate);

  factory ProfileState.initial() => const ProfileState(
        'John Doe',
        'Software Developer',
        'EMP-2025',
        'Engineering',
        'john.doe@company.com',
        'Jan 15, 2023',
      );
}