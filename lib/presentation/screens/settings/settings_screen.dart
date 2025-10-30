// presentation/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/settings/settings_cubit.dart';
import '../../cubits/theme/theme_cubit.dart';
import 'widgets/setting_item.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width > 600;

    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
        ),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final cubit = context.read<SettingsCubit>();

            return ListView(
              padding: EdgeInsets.all(isTablet ? 32 : 16),
              children: [
                _sectionTitle('Account Settings'),
                ...state.account.map(
                  (item) => SettingItem(
                    label: item,
                    onTap: () => _showSnack(context, '$item tapped'),
                  ),
                ),

                const Divider(height: 32),

                _sectionTitle('Preferences'),

                // Language
                SettingItem(
                  label: 'Language',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.language,
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => _showLanguagePicker(context, cubit),
                ),

                // Theme
                SettingItem(
                  label: 'Theme',
                  trailing: Switch(
                    value:
                        context.watch<ThemeCubit>().state.mode ==
                        AppThemeMode.dark,
                    onChanged: (_) {
                      final current = context.read<ThemeCubit>().state.mode;
                      final next = current == AppThemeMode.dark
                          ? AppThemeMode.light
                          : AppThemeMode.dark;
                      context.read<ThemeCubit>().setTheme(next);
                    },
                  ),
                  onTap: () {
                    final current = context.read<ThemeCubit>().state.mode;
                    final next = current == AppThemeMode.dark
                        ? AppThemeMode.light
                        : AppThemeMode.dark;
                    context.read<ThemeCubit>().setTheme(next);
                  },
                ),

                // Time Zone
                SettingItem(
                  label: 'Time Zone',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          state.timeZone,
                          style: TextStyle(color: theme.colorScheme.primary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => _showTimeZonePicker(context, cubit),
                ),

                const Divider(height: 32),

                _sectionTitle('Support'),
                ...state.support.map(
                  (item) => SettingItem(
                    label: item,
                    onTap: () => _showSnack(context, '$item tapped'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showLanguagePicker(BuildContext context, SettingsCubit cubit) {
    final languages = ['English', 'Spanish', 'French', 'German', 'Arabic'];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Language'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (ctx, i) {
              final lang = languages[i];
              return ListTile(
                title: Text(lang),
                trailing: cubit.state.language == lang
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  cubit.setLanguage(lang);
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showTimeZonePicker(BuildContext context, SettingsCubit cubit) {
    final timeZones = [
      'UTC-08:00 Pacific Time',
      'UTC-05:00 Eastern Time',
      'UTC+00:00 GMT',
      'UTC+05:30 India',
      'UTC+09:00 Japan',
    ];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Time Zone'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: timeZones.length,
            itemBuilder: (ctx, i) {
              final tz = timeZones[i];
              return ListTile(
                title: Text(tz),
                trailing: cubit.state.timeZone == tz
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () {
                  cubit.setTimeZone(tz);
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
