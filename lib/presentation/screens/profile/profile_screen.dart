// presentation/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/profile/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
                  const SizedBox(height: 16),
                  Text(state.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(state.role),
                  const SizedBox(height: 24),
                  _buildInfo('Employee ID', state.id),
                  _buildInfo('Department', state.dept),
                  _buildInfo('Email', state.email),
                  _buildInfo('Join Date', state.joinDate),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return ListTile(title: Text(label), subtitle: Text(value));
  }
}