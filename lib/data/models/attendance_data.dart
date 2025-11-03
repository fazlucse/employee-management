// lib/data/models/attendance_data.dart
import 'package:equatable/equatable.dart';
import 'attendance_log_entry.dart';

class AttendanceData extends Equatable {
  final DateTime? arrivedToday;
  final int lateCount;
  final int earlyCount;
  final int onLeaveCount;
  final Duration workTimeToday;
  final bool isClockedIn;
  final DateTime? lastClockTime;
  final List<AttendanceLogEntry> log;

  const AttendanceData({
    this.arrivedToday,
    this.lateCount = 0,
    this.earlyCount = 0,
    this.onLeaveCount = 0,
    this.workTimeToday = Duration.zero,
    this.isClockedIn = false,
    this.lastClockTime,
    this.log = const [],
  });

  String get arrivedTodayText => arrivedToday != null
      ? _formatTime(arrivedToday!)
      : '--:--';

  String get workTimeText =>
      '${workTimeToday.inHours}h ${workTimeToday.inMinutes.remainder(60)}m';

  String get lateEarlyText => '$lateCount Late / $earlyCount Early';

  AttendanceData copyWith({
    DateTime? arrivedToday,
    int? lateCount,
    int? earlyCount,
    int? onLeaveCount,
    Duration? workTimeToday,
    bool? isClockedIn,
    DateTime? lastClockTime,
    List<AttendanceLogEntry>? log,
  }) {
    return AttendanceData(
      arrivedToday: arrivedToday ?? this.arrivedToday,
      lateCount: lateCount ?? this.lateCount,
      earlyCount: earlyCount ?? this.earlyCount,
      onLeaveCount: onLeaveCount ?? this.onLeaveCount,
      workTimeToday: workTimeToday ?? this.workTimeToday,
      isClockedIn: isClockedIn ?? this.isClockedIn,
      lastClockTime: lastClockTime ?? this.lastClockTime,
      log: log ?? this.log,
    );
  }

  @override
  List<Object?> get props => [
        arrivedToday,
        lateCount,
        earlyCount,
        onLeaveCount,
        workTimeToday,
        isClockedIn,
        lastClockTime,
        log,
      ];

  static String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}