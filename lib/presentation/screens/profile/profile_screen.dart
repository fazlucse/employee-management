// presentation/screens/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/profile/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;
            final padding = isTablet ? 32.0 : 16.0;
            final avatarRadius = isTablet ? 70.0 : 50.0;
            final titleFontSize = isTablet ? 28.0 : 22.0;
            final subtitleFontSize = isTablet ? 18.0 : 16.0;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: avatarRadius,
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.person,
                        size: avatarRadius,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name & Role
                    BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            Text(
                              state.name,
                              style: TextStyle(
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              state.role,
                              style: TextStyle(
                                fontSize: subtitleFontSize,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Info Cards
                    _buildInfoCard(
                      context,
                      'Employee ID',
                      context.read<ProfileCubit>().state.id,
                      isTablet,
                    ),
                    _buildInfoCard(
                      context,
                      'Department',
                      context.read<ProfileCubit>().state.dept,
                      isTablet,
                    ),
                    _buildInfoCard(
                      context,
                      'Email',
                      context.read<ProfileCubit>().state.email,
                      isTablet,
                    ),
                    _buildInfoCard(
                      context,
                      'Join Date',
                      context.read<ProfileCubit>().state.joinDate,
                      isTablet,
                    ),

                    const SizedBox(height: 40),

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // TODO: Add logout logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out')),
                          );
                        },
                        icon: const Icon(Icons.logout, size: 20),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.error,
                          foregroundColor: theme.colorScheme.onError,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String label, String value, bool isTablet) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: isTablet ? 8 : 4),
        leading: Icon(
          _getIconForLabel(label),
          color: theme.colorScheme.primary,
          size: isTablet ? 28 : 24,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 16 : 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    return switch (label) {
      'Employee ID' => Icons.badge,
      'Department' => Icons.business,
      'Email' => Icons.email,
      'Join Date' => Icons.calendar_today,
      _ => Icons.info,
    };
  }
}