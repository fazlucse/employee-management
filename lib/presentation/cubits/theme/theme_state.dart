part of 'theme_cubit.dart';

enum AppThemeMode { light, dark, system }

class ThemeState {
  final AppThemeMode mode;
  const ThemeState(this.mode);
}