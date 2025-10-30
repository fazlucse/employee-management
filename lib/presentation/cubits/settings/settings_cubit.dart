// presentation/cubits/settings/settings_cubit.dart
import 'package:bloc/bloc.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState.initial());
  void setLanguage(String language) {
    emit(state.copyWith(language: language));
  }

  void toggleTheme() {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void setTimeZone(String timeZone) {
    emit(state.copyWith(timeZone: timeZone));
  }
}