import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(AppThemeMode.system)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('theme_mode');
    final mode = saved == 'dark'
        ? AppThemeMode.dark
        : saved == 'light'
            ? AppThemeMode.light
            : AppThemeMode.system;
    emit(ThemeState(mode));
  }

  Future<void> setTheme(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'theme_mode',
      mode == AppThemeMode.dark
          ? 'dark'
          : mode == AppThemeMode.light
              ? 'light'
              : 'system',
    );
    emit(ThemeState(mode));
  }
}