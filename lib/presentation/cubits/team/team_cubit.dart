// presentation/cubits/team/team_cubit.dart
import 'package:bloc/bloc.dart';
part 'team_state.dart';

class TeamCubit extends Cubit<TeamState> {
  TeamCubit() : super(TeamState.initial());
}