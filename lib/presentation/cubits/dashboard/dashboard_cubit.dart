import 'package:bloc/bloc.dart';
part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardState(activeScreen: 'home'));

  void changeScreen(String screen) {
    emit(state.copyWith(activeScreen: screen, showMoreMenu: false));
  }

  void toggleMoreMenu() => emit(state.copyWith(showMoreMenu: !state.showMoreMenu));
  void closeMoreMenu() => emit(state.copyWith(showMoreMenu: false));
}