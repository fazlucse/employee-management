// lib/data/models/attendance_log_entry.dart
import 'package:equatable/equatable.dart';

class AttendanceLogEntry extends Equatable {
  final DateTime date;
  final DateTime? inTime;
  final DateTime? outTime;
  final String name;
  final String designation;
  final String? inLocation;
  final String? outLocation;

  const AttendanceLogEntry({
    required this.date,
    this.inTime,
    this.outTime,
    required this.name,
    required this.designation,
    this.inLocation,
    this.outLocation,
  });

  // ADD COPY WITH METHOD
  AttendanceLogEntry copyWith({
    DateTime? date,
    DateTime? inTime,
    DateTime? outTime,
    String? name,
    String? designation,
    String? inLocation,
    String? outLocation,
  }) {
    return AttendanceLogEntry(
      date: date ?? this.date,
      inTime: inTime ?? this.inTime,
      outTime: outTime ?? this.outTime,
      name: name ?? this.name,
      designation: designation ?? this.designation,
      inLocation: inLocation ?? this.inLocation,
      outLocation: outLocation ?? this.outLocation,
    );
  }

  @override
  List<Object?> get props => [
        date,
        inTime,
        outTime,
        name,
        designation,
        inLocation,
        outLocation,
      ];
}