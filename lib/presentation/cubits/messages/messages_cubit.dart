// presentation/cubits/messages/messages_cubit.dart
import 'package:bloc/bloc.dart';
part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesState.initial());
}