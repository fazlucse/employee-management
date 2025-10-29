import 'package:employee_management/presentation/screens/dashboard/widgets/more_menu_bottom_sheet.dart';
import 'package:employee_management/presentation/screens/reports/reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/utils/screen_util.dart';
import '../../cubits/navigation/navigation_cubit.dart';
import '../../cubits/dashboard/dashboard_cubit.dart';
import '../tasks/tasks_screen.dart';
import '../stats/stats_screen.dart';
import '../notifications/notifications_screen.dart';
import '../messages/messages_screen.dart';
import '../team/team_screen.dart';
import '../projects/projects_screen.dart';
import '../payroll/payroll_screen.dart';
import '../settings/settings_screen.dart';
import '../profile/profile_screen.dart';
import 'widgets/bottom_nav_item.dart';
import 'widgets/home_content.dart';
import 'widgets/more_menu_bottom_sheet.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              _buildContent(),
              _buildMoreMenu(),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        switch (state.activeScreen) {
          case 'home': return const HomeContent();
          case 'tasks': return const TasksScreen();
          case 'stats': return const StatsScreen();
          case 'notifications': return const NotificationsScreen();
          case 'reports': return const ReportsScreen();
          case 'messages': return const MessagesScreen();
          case 'team': return const TeamScreen();
          case 'projects': return const ProjectsScreen();
          case 'payroll': return const PayrollScreen();
          // case 'achievements': return const AchievementsScreen();
          case 'settings': return const SettingsScreen();
          case 'profile': return const ProfileScreen();
          default: return const SizedBox();
        }
      },
    );
  }

 Widget _buildMoreMenu() {
  return BlocBuilder<DashboardCubit, DashboardState>(
    builder: (context, state) {
      if (!state.showMoreMenu) return const SizedBox();
      Future.microtask(() {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => MoreMenuBottomSheet(
            cubit: context.read<DashboardCubit>(), // Pass cubit here
          ),
        ).then((_) => context.read<DashboardCubit>().closeMoreMenu());
      });

      return const SizedBox();
    },
  );
}

  Widget _moreItem(String label, IconData icon, String screen, BuildContext ctx) {
    return ListTile(
      leading: Icon(icon, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 15)),
      onTap: () {
        ctx.read<DashboardCubit>().changeScreen(screen);
        ctx.read<NavigationCubit>().select(NavTab.more);
      },
    );
  }

  Widget _buildBottomNav() {
    return BlocBuilder<NavigationCubit, NavTab>(builder: (context, nav) {
      final navCubit = context.read<NavigationCubit>();
      final dashCubit = context.read<DashboardCubit>();
      return Container(
        decoration:  BoxDecoration(border: Border(top: BorderSide(color: AppColors.gray))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomNavItem(icon: AppIcons.home, label: 'Home', active: nav == NavTab.home, onTap: () => _nav('home', NavTab.home, context)),
            BottomNavItem(icon: AppIcons.message, label: 'Chat', badge: 2, active: nav == NavTab.messages, onTap: () => _nav('messages', NavTab.messages, context)),
            BottomNavItem(icon: AppIcons.fileText, label: 'Reports', active: nav == NavTab.reports, onTap: () => _nav('reports', NavTab.reports, context)),
            BottomNavItem(icon: AppIcons.user, label: 'Profile', active: nav == NavTab.profile, onTap: () => _nav('profile', NavTab.profile, context)),
            BottomNavItem(icon: AppIcons.more, label: 'More', active: false, onTap: () => dashCubit.toggleMoreMenu()),
          ],
        ),
      );
    });
  }

  void _nav(String screen, NavTab tab, BuildContext ctx) {
    ctx.read<DashboardCubit>().changeScreen(screen);
    ctx.read<NavigationCubit>().select(tab);
  }
}