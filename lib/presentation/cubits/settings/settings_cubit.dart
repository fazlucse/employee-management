// presentation/cubits/settings/settings_cubit.dart
import 'package:bloc/bloc.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState.initial());
}