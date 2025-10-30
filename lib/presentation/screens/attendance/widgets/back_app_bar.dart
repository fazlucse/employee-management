// lib/presentation/screens/dashboard/widgets/back_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../cubits/dashboard/dashboard_cubit.dart';
import '../../../cubits/navigation/navigation_cubit.dart';
import '../../../cubits/notifications/notifications_cubit.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Optional: screen to go back to when pressing the back button.
  /// If null → defaults to `'home'`.
  final String? goBackTo;

  const BackAppBar({super.key, this.goBackTo});

  @override
  Widget build(BuildContext context) {
    final currentScreen = context.select<DashboardCubit, String>(
      (cubit) => cubit.state.activeScreen,
    );
    final isHome = currentScreen == 'home';

    // Determine where the back button should navigate
    final backScreen = goBackTo ?? 'home';
    final backTab = _screenToNavTab(backScreen);

    return AppBar(
     title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          _getTitle(currentScreen),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      centerTitle: false,
      titleSpacing: 0.0,
      leading: isHome
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                context.read<DashboardCubit>().changeScreen(backScreen);
                if (backTab != null) {
                  context.read<NavigationCubit>().select(backTab);
                }
              },
            ),

      actions: [
        // Notifications + Badge
        BlocSelector<NotificationsCubit, NotificationsState, int>(
          selector: (state) => state.notifications.length,
          builder: (context, count) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(LucideIcons.bell),
                  onPressed: () {
                    context.read<DashboardCubit>().changeScreen('notifications');
                  },
                ),
                if (count > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        count > 99 ? '99+' : '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),

        // Profile
        IconButton(
          icon: const Icon(LucideIcons.user),
          onPressed: () {
            context.read<DashboardCubit>().changeScreen('profile');
            context.read<NavigationCubit>().select(NavTab.profile);
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  String _getTitle(String screen) {
    return switch (screen) {
      'home' => 'Dashboard',
      'tasks' => 'Tasks',
      'stats' => 'Stats',
      'notifications' => 'Notifications',
      'reports' => 'Reports',
      'messages' => 'Messages',
      'team' => 'Team',
      'projects' => 'Projects',
      'payroll' => 'Payroll',
      'attendance' => 'Attendance',
      'settings' => 'Settings',
      'profile' => 'Profile',
      _ => 'Menu',
    };
  }

  /// Map screen name → NavTab (only if it matches a bottom tab)
  NavTab? _screenToNavTab(String screen) {
    return switch (screen) {
      'home' => NavTab.home,
      'messages' => NavTab.messages,
      'reports' => NavTab.reports,
      'profile' => NavTab.profile,
      _ => null, // no bottom nav highlight for others
    };
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}