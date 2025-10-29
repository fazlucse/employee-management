// presentation/screens/messages/widgets/message_tile.dart
import 'package:flutter/material.dart';

import '../../../cubits/messages/messages_cubit.dart';

class MessageTile extends StatelessWidget {
  final MessageItem message;

  const MessageTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(message.name.split(' ').map((n) => n[0]).join())),
      title: Text(message.name, style: TextStyle(fontWeight: message.unread ? FontWeight.bold : FontWeight.normal)),
      subtitle: Text(message.message),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(message.time, style: const TextStyle(fontSize: 12)),
          if (message.unread) const Text('New', style: TextStyle(color: Colors.blue, fontSize: 10)),
        ],
      ),
    );
  }
}