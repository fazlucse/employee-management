// presentation/screens/settings/widgets/setting_item.dart
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingItem({
    super.key,
    required this.label,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}