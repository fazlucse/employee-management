part of 'dashboard_cubit.dart';

class DashboardState {
  final String activeScreen;
  final bool showMoreMenu;

  const DashboardState({
    required this.activeScreen,
    this.showMoreMenu = false,
  });

  DashboardState copyWith({String? activeScreen, bool? showMoreMenu}) {
    return DashboardState(
      activeScreen: activeScreen ?? this.activeScreen,
      showMoreMenu: showMoreMenu ?? this.showMoreMenu,
    );
  }
}