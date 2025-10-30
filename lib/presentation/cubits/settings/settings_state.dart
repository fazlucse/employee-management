// presentation/cubits/settings/settings_state.dart
part of 'settings_cubit.dart';

class SettingsState {
  final List<String> account;
  final List<String> preferences;
  final List<String> support;

  // Dynamic settings
  final String language;
  final bool isDarkMode;
  final String timeZone;

  const SettingsState({
    required this.account,
    required this.preferences,
    required this.support,
    required this.language,
    required this.isDarkMode,
    required this.timeZone,
  });

  factory SettingsState.initial() => const SettingsState(
        account: ['Edit Profile', 'Change Password', 'Notification Preferences'],
        preferences: ['Language', 'Theme', 'Time Zone'],
        support: ['Help Center', 'Contact Support', 'About'],
        language: 'English',
        isDarkMode: false,
        timeZone: 'UTC+00:00 GMT',
      );

  SettingsState copyWith({
    List<String>? account,
    List<String>? preferences,
    List<String>? support,
    String? language,
    bool? isDarkMode,
    String? timeZone,
  }) {
    return SettingsState(
      account: account ?? this.account,
      preferences: preferences ?? this.preferences,
      support: support ?? this.support,
      language: language ?? this.language,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      timeZone: timeZone ?? this.timeZone,
    );
  }
}