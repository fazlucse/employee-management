// presentation/cubits/settings/settings_state.dart
part of 'settings_cubit.dart';

class SettingsState {
  final List<String> account;
  final List<String> preferences;
  final List<String> support;

  const SettingsState(this.account, this.preferences, this.support);

  factory SettingsState.initial() => const SettingsState(
        ['Edit Profile', 'Change Password', 'Notification Preferences'],
        ['Language', 'Theme', 'Time Zone'],
        ['Help Center', 'Contact Support', 'About'],
      );
}