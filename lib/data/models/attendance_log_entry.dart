// lib/data/models/attendance_log_entry.dart
import 'package:equatable/equatable.dart';

class AttendanceLogEntry extends Equatable {
  final DateTime date; // System entry date
  final DateTime attendanceDate; // Actual attendance day
  final DateTime? inTime;
  final DateTime? outTime;
  final String name;
  final String designation;
  final String? inLocation;
  final String? outLocation;
  final String? officeId;
  final String? outOfficeId;
  // New fields
  final String? inRemarks;
  final String? outRemarks;
  final double? inLatitude;
  final double? inLongitude;
  final double? outLatitude;
  final double? outLongitude;
  final String? locationType;
  final String? inPlace;
  final String? outPlace;
  final bool isLeave;
  final bool isHoliday;
  final bool isOffDay;
  final bool supervisorApproved;
  final String? personId;
  final String? reason;

  const AttendanceLogEntry({
    required this.date,
    required this.attendanceDate,
    this.inTime,
    this.outTime,
    required this.name,
    required this.designation,
    this.inLocation,
    this.outLocation,
    this.officeId,
    this.outOfficeId,
    this.inRemarks,
    this.outRemarks,
    this.inLatitude,
    this.inLongitude,
    this.outLatitude,
    this.outLongitude,
    this.locationType,
    this.inPlace,
    this.outPlace,
    this.isLeave = false,
    this.isHoliday = false,
    this.isOffDay = false,
    this.supervisorApproved = false,
    this.personId,
    this.reason,
  });

  AttendanceLogEntry copyWith({
    DateTime? date,
    DateTime? attendanceDate,
    DateTime? inTime,
    DateTime? outTime,
    String? name,
    String? designation,
    String? inLocation,
    String? outLocation,
    String? officeId,
    String? outOfficeId,
    String? inRemarks,
    String? outRemarks,
    double? inLatitude,
    double? inLongitude,
    double? outLatitude,
    double? outLongitude,
    String? locationType,
    String? inPlace,
    String? outPlace,
    bool? isLeave,
    bool? isHoliday,
    bool? isOffDay,
    bool? supervisorApproved,
    String? personId,
    String? reason,
  }) {
    return AttendanceLogEntry(
      date: date ?? this.date,
      attendanceDate: attendanceDate ?? this.attendanceDate,
      inTime: inTime ?? this.inTime,
      outTime: outTime ?? this.outTime,
      name: name ?? this.name,
      designation: designation ?? this.designation,
      inLocation: inLocation ?? this.inLocation,
      outLocation: outLocation ?? this.outLocation,
      officeId: officeId ?? this.officeId,
      outOfficeId: outOfficeId ?? this.outOfficeId,
      inRemarks: inRemarks ?? this.inRemarks,
      outRemarks: outRemarks ?? this.outRemarks,
      inLatitude: inLatitude ?? this.inLatitude,
      inLongitude: inLongitude ?? this.inLongitude,
      outLatitude: outLatitude ?? this.outLatitude,
      outLongitude: outLongitude ?? this.outLongitude,
      locationType: locationType ?? this.locationType,
      inPlace: inPlace ?? this.inPlace,
      outPlace: outPlace ?? this.outPlace,
      isLeave: isLeave ?? this.isLeave,
      isHoliday: isHoliday ?? this.isHoliday,
      isOffDay: isOffDay ?? this.isOffDay,
      supervisorApproved: supervisorApproved ?? this.supervisorApproved,
      personId: personId ?? this.personId,
      reason: reason ?? this.reason,
    );
  }

  factory AttendanceLogEntry.fromJson(Map<String, dynamic> json) {
    return AttendanceLogEntry(
      date: DateTime.parse(json['date'] as String),
      attendanceDate: DateTime.parse(json['attendanceDate'] as String),
      inTime: json['inTime'] != null ? DateTime.parse(json['inTime'] as String) : null,
      outTime: json['outTime'] != null ? DateTime.parse(json['outTime'] as String) : null,
      name: json['name'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      inLocation: json['inLocation'] as String?,
      outLocation: json['outLocation'] as String?,
      officeId: json['officeId'] as String?,
      outOfficeId: json['outOfficeId'] as String?,
      inRemarks: json['inRemarks'] as String?,
      outRemarks: json['outRemarks'] as String?,
      inLatitude: (json['inLatitude'] as num?)?.toDouble(),
      inLongitude: (json['inLongitude'] as num?)?.toDouble(),
      outLatitude: (json['outLatitude'] as num?)?.toDouble(),
      outLongitude: (json['outLongitude'] as num?)?.toDouble(),
      locationType: json['locationType'] as String?,
      inPlace: json['inPlace'] as String?,
      outPlace: json['outPlace'] as String?,
      isLeave: json['isLeave'] as bool? ?? false,
      isHoliday: json['isHoliday'] as bool? ?? false,
      isOffDay: json['isOffDay'] as bool? ?? false,
      supervisorApproved: json['supervisorApproved'] as bool? ?? false,
      personId: json['personId'] as String?,
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'attendanceDate': attendanceDate.toIso8601String(),
      'inTime': inTime?.toIso8601String(),
      'outTime': outTime?.toIso8601String(),
      'name': name,
      'designation': designation,
      'inLocation': inLocation,
      'outLocation': outLocation,
      'officeId': officeId,
      'outOfficeId': outOfficeId,
      'inRemarks': inRemarks,
      'outRemarks': outRemarks,
      'inLatitude': inLatitude,
      'inLongitude': inLongitude,
      'outLatitude': outLatitude,
      'outLongitude': outLongitude,
      'locationType': locationType,
      'inPlace': inPlace,
      'outPlace': outPlace,
      'isLeave': isLeave,
      'isHoliday': isHoliday,
      'isOffDay': isOffDay,
      'supervisorApproved': supervisorApproved,
      'personId': personId,
      'reason': reason,
    };
  }

  @override
  List<Object?> get props => [
        date,
        attendanceDate,
        inTime,
        outTime,
        name,
        designation,
        inLocation,
        outLocation,
        officeId,
        outOfficeId,
        inRemarks,
        outRemarks,
        inLatitude,
        inLongitude,
        outLatitude,
        outLongitude,
        locationType,
        inPlace,
        outPlace,
        isLeave,
        isHoliday,
        isOffDay,
        supervisorApproved,
        personId,
        reason,
      ];
}