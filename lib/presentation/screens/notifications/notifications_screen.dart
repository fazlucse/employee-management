// presentation/screens/notifications/notifications_screen.dart
import 'package:employee_management/presentation/cubits/notifications/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/notification_tile.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.notifications.length,
              itemBuilder: (_, i) => NotificationTile(
                notification: state.notifications[i],
                onTap: () => context.read<NotificationsCubit>().markAsRead(i),
              ),
            );
          },
        ),
      ),
    );
  }
}