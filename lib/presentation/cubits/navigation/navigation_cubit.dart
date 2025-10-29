import 'package:bloc/bloc.dart';
part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavTab> {
  NavigationCubit() : super(NavTab.home);

  void select(NavTab tab) => emit(tab);
}