// presentation/screens/messages/messages_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/messages/messages_cubit.dart';
import 'widgets/message_tile.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessagesCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Messages')),
        body: BlocBuilder<MessagesCubit, MessagesState>(
          builder: (context, state) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.messages.length,
              itemBuilder: (_, i) => MessageTile(message: state.messages[i]),
            );
          },
        ),
      ),
    );
  }
}