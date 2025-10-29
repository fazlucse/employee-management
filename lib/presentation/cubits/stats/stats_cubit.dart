// presentation/cubits/stats/stats_cubit.dart
import 'package:bloc/bloc.dart';
part 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  StatsCubit() : super(StatsState.initial());

  void refresh() => emit(StatsState.initial()); // Simulate refresh
}