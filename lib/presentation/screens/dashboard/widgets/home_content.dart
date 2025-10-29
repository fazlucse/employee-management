// presentation/screens/dashboard/widgets/home_content.dart
import 'package:employee_management/presentation/screens/dashboard/widgets/quick_action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/utils/screen_util.dart';
import '../../../cubits/dashboard/dashboard_cubit.dart';
import '../../stats/widgets/stat_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context),
          const SizedBox(height: 20),

          // Stats Row
          _buildStatsRow(context),
          const SizedBox(height: 24),

          // Quick Actions
          const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildQuickActions(context),
          const SizedBox(height: 24),

          // Recent Activity
          const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildRecentActivity(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Spacer(),
            Stack(
              children: [
                const Icon(LucideIcons.bell, size: 24),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text('Welcome Back!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        Text(
          'John Doe - Software Developer',
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        Text(
          'Monday, October 28, 2025',
          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
  children: const [
    Expanded(
      child: StatCard(
        value: '22',
        title: 'Total Hours',
        color: Colors.blue,
      ),
    ),
    SizedBox(width: 12),
    Expanded(
      child: StatCard(
        value: '3',
        title: 'Hours Today',
        color: Colors.green,
      ),
    ),
    SizedBox(width: 12),
    Expanded(
      child: StatCard(
        value: '7',
        title: 'Pending Tasks',
        color: Colors.orange,
      ),
    ),
  ],
);
  }

Widget _buildQuickActions(BuildContext context) {
  final actions = [
    {
      'label': 'Clock In/Out',
      'icon': LucideIcons.clock,
      'onTap': () {},
    },
    {
      'label': 'Apply Leave',
      'icon': LucideIcons.calendar,
      'onTap': () {},
    },
    {
      'label': 'Movement Register',
      'icon': LucideIcons.mapPin,
      'onTap': () {},
    },
    {
      'label': 'View Tasks',
      'icon': LucideIcons.checkSquare,
      'onTap': () => context.read<DashboardCubit>().changeScreen('tasks'),
    },
  ];

  return LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;
      final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

      int crossAxisCount;
      double childAspectRatio;
      double spacing;

      if (screenWidth >= 1200) {
        crossAxisCount = 6;
        childAspectRatio = 1.8;
        spacing = 12;
      } else if (screenWidth >= 900) {
        crossAxisCount = 4;
        childAspectRatio = 1.9;
        spacing = 10;
      } else if (screenWidth >= 600) {
        crossAxisCount = isPortrait ? 2 : 4;
        childAspectRatio = isPortrait ? 1.7 : 2.1;
        spacing = 10;
      } else {
        crossAxisCount = 2;
        childAspectRatio = 1.7; // Safe for small screens
        spacing = 8;
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: spacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return QuickActionCard(
            label: action['label'] as String,
            icon: action['icon'] as IconData,
            onTap: action['onTap'] as VoidCallback,
          );
        },
      );
    },
  );
}
  Widget _buildRecentActivity(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(LucideIcons.clock, color: Theme.of(context).colorScheme.primary),
        title: const Text('Clocked in at 9:00 AM'),
        subtitle: const Text('Today'),
        trailing: const Icon(LucideIcons.chevronRight),
        onTap: () {},
      ),
    );
  }
}