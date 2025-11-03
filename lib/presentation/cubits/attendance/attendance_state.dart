// lib/cubits/attendance/attendance_state.dart (UPDATED)
part of 'attendance_cubit.dart';

sealed class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

class AttendanceLoaded extends AttendanceState {
  final AttendanceData data;
  final List<Office> offices;
  final String gpsLocation;
  final String currentTime;
  final String locationType;
  final Office? selectedOffice;
  final String customLocation;
  final String remarks; // Shared remarks (in/out)
  final bool isWatchingLocation;
  final int uiVersion;

  // GPS coords for clock-in/out
  final double? currentLatitude;
  final double? currentLongitude;

  const AttendanceLoaded({
    required this.data,
    required this.offices,
    required this.gpsLocation,
    required this.currentTime,
    this.locationType = 'Home',
    this.selectedOffice,
    this.customLocation = '',
    this.remarks = '',
    this.isWatchingLocation = false,
    this.uiVersion = 0,
    this.currentLatitude,
    this.currentLongitude,
  });

  @override
  List<Object?> get props => [
        data,
        offices,
        gpsLocation,
        currentTime,
        locationType,
        selectedOffice,
        customLocation,
        remarks,
        isWatchingLocation,
        uiVersion,
        currentLatitude,
        currentLongitude,
      ];

  AttendanceLoaded copyWith({
    AttendanceData? data,
    List<Office>? offices,
    String? gpsLocation,
    String? currentTime,
    String? locationType,
    Office? selectedOffice,
    String? customLocation,
    String? remarks,
    bool? isWatchingLocation,
    int? uiVersion,
    double? currentLatitude,
    double? currentLongitude,
  }) {
    return AttendanceLoaded(
      data: data ?? this.data,
      offices: offices ?? this.offices,
      gpsLocation: gpsLocation ?? this.gpsLocation,
      currentTime: currentTime ?? this.currentTime,
      locationType: locationType ?? this.locationType,
      selectedOffice: selectedOffice ?? this.selectedOffice,
      customLocation: customLocation ?? this.customLocation,
      remarks: remarks ?? this.remarks,
      isWatchingLocation: isWatchingLocation ?? this.isWatchingLocation,
      uiVersion: uiVersion ?? this.uiVersion,
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
    );
  }
}

class AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError(this.message);
  @override
  List<Object?> get props => [message];
}