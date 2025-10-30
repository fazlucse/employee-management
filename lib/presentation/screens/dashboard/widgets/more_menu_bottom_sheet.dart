// presentation/screens/dashboard/widgets/more_menu_bottom_sheet.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../cubits/dashboard/dashboard_cubit.dart';

class MoreMenuBottomSheet extends StatelessWidget {
  final DashboardCubit cubit;

  const MoreMenuBottomSheet({super.key, required this.cubit});

  Widget _moreItem(String label, IconData icon, String screen, BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
      title: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        cubit.changeScreen(screen);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // === HEADER ROW: Handle + Title + Close Button ===
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8), // Right padding reduced
              child: Row(
                children: [
                  // Handle Bar (Left-aligned under title)
                  // Container(
                  //   width: 40,
                  //   height: 5,
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).dividerColor,
                  //     borderRadius: BorderRadius.circular(3),
                  //   ),
                  // ),
                  // const Spacer(),

                  // Centered Title
                  Expanded(
                    child: Text(
                      'More Options',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Close Button – Right Side, Flush
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red.shade600,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.x,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // === Scrollable Menu Items ===
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _moreItem('Tasks', LucideIcons.checkSquare, 'tasks', context),
                    _moreItem('Statistics', LucideIcons.barChart2, 'stats', context),
                    _moreItem('Notifications', LucideIcons.bell, 'notifications', context),
                    _moreItem('Team', LucideIcons.users, 'team', context),
                    _moreItem('Projects', LucideIcons.briefcase, 'projects', context),
                    _moreItem('Payroll', LucideIcons.dollarSign, 'payroll', context),
                    _moreItem('Achievements', LucideIcons.award, 'achievements', context),
                    _moreItem('Settings', LucideIcons.settings, 'settings', context),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}