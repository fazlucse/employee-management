// presentation/cubits/notifications/notifications_cubit.dart
import 'package:bloc/bloc.dart';
part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsState.initial());

  void markAsRead(int index) {
    final updated = state.notifications.map((n) => n).toList();
    updated[index] = updated[index].copyWith(isRead: true);
    emit(NotificationsState(updated));
  }
}