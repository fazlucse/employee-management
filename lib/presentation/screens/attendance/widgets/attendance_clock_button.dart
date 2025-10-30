import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AttendanceClockButton extends StatelessWidget {
  final bool isClockedIn;
  final VoidCallback onTap;
  final DateTime? lastClockTime;

  const AttendanceClockButton({
    super.key,
    required this.isClockedIn,
    required this.onTap,
    this.lastClockTime,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Card(
        key: ValueKey(isClockedIn),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isClockedIn ? LucideIcons.logOut : LucideIcons.logIn,
                  size: 48,
                  color: isClockedIn ? Colors.redAccent : Colors.green,
                ),
                const SizedBox(height: 12),
                Text(
                  isClockedIn ? 'Clock Out' : 'Clock In',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isClockedIn ? Colors.redAccent : Colors.green,
                      ),
                ),
                if (lastClockTime != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Last: ${_formatTime(lastClockTime!)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}