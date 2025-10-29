// presentation/cubits/messages/messages_state.dart
part of 'messages_cubit.dart';

class MessageItem {
  final String name;
  final String message;
  final String time;
  final bool unread;

  const MessageItem(this.name, this.message, this.time, this.unread);
}

class MessagesState {
  final List<MessageItem> messages;
  const MessagesState(this.messages);

  factory MessagesState.initial() => MessagesState([
        const MessageItem('Sarah Johnson', 'Can we reschedule the meeting?', '10 min ago', true),
        const MessageItem('Mike Chen', 'Great work on the project!', '1 hour ago', true),
        const MessageItem('HR Department', 'Benefits enrollment deadline', '3 hours ago', false),
        const MessageItem('Team Lead', 'Code review completed', '1 day ago', false),
      ]);
}