// presentation/screens/notifications/widgets/notification_tile.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../cubits/notifications/notifications_cubit.dart';
class NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationTile({super.key, required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final icon = switch (notification.type) {
      'success' => LucideIcons.checkCircle,
      'warning' => LucideIcons.alertCircle,
      _ => LucideIcons.info,
    };
    final color = switch (notification.type) {
      'success' => Colors.green,
      'warning' => Colors.orange,
      _ => Colors.blue,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.transparent : Theme.of(context).colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: notification.isRead ? Colors.transparent : color.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(notification.title, style: TextStyle(fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600)),
        subtitle: Text(notification.time, style: const TextStyle(fontSize: 12)),
        onTap: onTap,
      ),
    );
  }
}