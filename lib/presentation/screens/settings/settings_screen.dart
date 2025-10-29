// presentation/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/settings/settings_cubit.dart';
import 'widgets/setting_item.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Account Settings', style: TextStyle(fontWeight: FontWeight.bold)),
                ...state.account.map((s) => SettingItem(label: s)),
                const Divider(),
                const Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
                ...state.preferences.map((s) => SettingItem(label: s)),
                const Divider(),
                const Text('Support', style: TextStyle(fontWeight: FontWeight.bold)),
                ...state.support.map((s) => SettingItem(label: s)),
              ],
            );
          },
        ),
      ),
    );
  }
}