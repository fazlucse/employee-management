// presentation/screens/dashboard/widgets/quick_action_card.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class QuickActionCard extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  const QuickActionCard({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
  });

  IconData get _icon {
    return icon ??
        switch (label) {
          'Clock In/Out' => LucideIcons.clock,
          'Apply Leave' => LucideIcons.calendar,
          'Movement Register' => LucideIcons.mapPin,
          'View Tasks' => LucideIcons.checkSquare,
          _ => LucideIcons.playCircle,
        };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center, // ← VERTICAL CENTER
          crossAxisAlignment: CrossAxisAlignment.center, // ← HORIZONTAL CENTER
          children: [
            // Rounded Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  _icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}