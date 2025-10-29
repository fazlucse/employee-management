// presentation/cubits/notifications/notifications_state.dart
part of 'notifications_cubit.dart';

class NotificationItem {
  final String title;
  final String time;
  final String type; // success, warning, info
  final bool isRead;

  const NotificationItem({
    required this.title,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) => NotificationItem(
        title: title,
        time: time,
        type: type,
        isRead: isRead ?? this.isRead,
      );
}

class NotificationsState {
  final List<NotificationItem> notifications;
  const NotificationsState(this.notifications);

  factory NotificationsState.initial() => NotificationsState([
        const NotificationItem(title: 'Leave request approved', time: '2 hours ago', type: 'success'),
        const NotificationItem(title: 'New task assigned: Update API', time: '5 hours ago', type: 'info'),
        const NotificationItem(title: 'Meeting reminder at 3 PM', time: '1 day ago', type: 'warning'),
        const NotificationItem(title: 'Timesheet due tomorrow', time: '2 days ago', type: 'info'),
      ]);
}