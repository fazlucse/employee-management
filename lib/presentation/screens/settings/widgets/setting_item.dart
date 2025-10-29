// presentation/screens/settings/widgets/setting_item.dart
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String label;

  const SettingItem({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}