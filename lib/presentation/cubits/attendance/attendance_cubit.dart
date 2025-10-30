import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/attendance_data.dart';
import '../../../data/models/attendance_log_entry.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final Stream<AttendanceData> _attendanceStream;
  late final StreamSubscription<AttendanceData> _subscription;

  AttendanceCubit({required Stream<AttendanceData> attendanceStream})
      : _attendanceStream = attendanceStream,
        super(const AttendanceLoading()) {
    _subscription = _attendanceStream.listen(
      (data) => emit(AttendanceLoaded(data)),
      onError: (error) => emit(AttendanceError(error.toString())),
    );
  }

Future<void> clockInOut({String? location}) async {
  if (state is! AttendanceLoaded) return;
  final current = (state as AttendanceLoaded).data;
  final now = DateTime.now();
  final updatedLog = List<AttendanceLogEntry>.from(current.log);

  if (!current.isClockedIn) {
    // Clock In
    updatedLog.insert(0, AttendanceLogEntry(
      date: now,
      inTime: now,
      name: 'John Doe',
      designation: 'Software Engineer',
      inLocation: location ?? 'Unknown',
    ));
  } else {
    // Clock Out
    if (updatedLog.isNotEmpty && updatedLog[0].outTime == null) {
      updatedLog[0] = updatedLog[0].copyWith(
        outTime: now,
        outLocation: location ?? 'Unknown',
      );
    }
  }

  emit(AttendanceLoaded(current.copyWith(
    isClockedIn: !current.isClockedIn,
    lastClockTime: now,
    log: updatedLog,
  )));
}
  
  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}