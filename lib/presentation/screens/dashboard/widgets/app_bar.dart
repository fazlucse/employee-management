// presentation/widgets/dashboard_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../cubits/dashboard/dashboard_cubit.dart';
import '../../../cubits/notifications/notifications_cubit.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  static const Map<String, String> _screenTitles = {
    'home': 'Home',
    'tasks': 'Tasks',
    'stats': 'Stats',
    'notifications': 'Notifications',
    'reports': 'Reports',
    'messages': 'Chat',
    'team': 'Team',
    'projects': 'Projects',
    'payroll': 'Payroll',
    'settings': 'Settings',
    'profile': 'Profile',
  };

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
      elevation: 0,
      title: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          final title = _screenTitles[state.activeScreen] ?? 'Dashboard';
          return Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ) ??
                TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
            overflow: TextOverflow.ellipsis,
          );
        },
      ),
      actions: const [
        _NotificationButton(),
        _UserProfileButton(), // NEW: User icon on the right
        //  _MoreMenuButton(),
      ],
      iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      centerTitle: false,
    );
  }
}

// Notification Button with Badge
class _NotificationButton extends StatelessWidget {
  const _NotificationButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final unreadCount = state.notifications.where((n) => !n.isRead).length;

        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(AppIcons.bell),
                color: theme.colorScheme.onSurface,
                onPressed: () {
                  context.read<DashboardCubit>().changeScreen('notifications');
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: _buildBadge(unreadCount, theme),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBadge(int count, ThemeData theme) {
    final text = count > 99 ? '99+' : '$count';

    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.error,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: theme.colorScheme.onError,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// More Menu Button
class _MoreMenuButton extends StatelessWidget {
  const _MoreMenuButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: IconButton(
        icon: const Icon(AppIcons.moreVertical),
        color: theme.colorScheme.onSurface,
        onPressed: () => context.read<DashboardCubit>().toggleMoreMenu(),
      ),
    );
  }
}

// NEW: User Profile Button (Rightmost) - Dynamic Photo or Initials
class _UserProfileButton extends StatelessWidget {
  const _UserProfileButton();

  // Simulate user data - replace with real auth/user cubit later
  static final _mockUser = {
    'name': 'John Doe',
    'photoUrl': null, // Set to a URL string to test photo
    // 'photoUrl': 'https://i.pravatar.cc/150?img=3',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = _mockUser['name'] ?? 'User';
    final photoUrl = _mockUser['photoUrl'] as String?;

    // Extract initials
    final initials = userName
        .split(' ')
        .where((s) => s.isNotEmpty)
        .map((s) => s[0].toUpperCase())
        .take(2)
        .join();

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          context.read<DashboardCubit>().changeScreen('profile');
        },
        child: CircleAvatar(
          radius: 16,
          backgroundColor: photoUrl == null
              ? theme.colorScheme.primary.withAlpha((0.8 * 255).round()) // Fixed
              : Colors.transparent,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
          child: photoUrl == null
              ? Text(
                  initials,
                  style: TextStyle(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}