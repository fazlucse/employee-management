// lib/cubits/attendance/attendance_cubit.dart (FULLY UPDATED)
import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../../data/models/attendance_data.dart';
import '../../../data/models/attendance_log_entry.dart';
import '../../../data/models/office.dart';


part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  late final Timer _clockTimer;
  late final Timer _gpsTimer;
  StreamSubscription<Position>? _positionStream;

  AttendanceCubit() : super(const AttendanceLoading()) {
    _init();
  }

  Future<void> _init() async {
    final offices = await _loadOfficesFromAssets();

    emit(AttendanceLoaded(
      data: AttendanceData(isClockedIn: false),
      offices: offices,
      gpsLocation: 'Fetching location...',
      currentTime: _formatTime(DateTime.now()),
      uiVersion: 0,
    ));

    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tickClock());
    _gpsTimer = Timer.periodic(const Duration(seconds: 30), (_) => fetchLocationOnce());
    fetchLocationOnce();
  }

  Future<List<Office>> _loadOfficesFromAssets() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/offices.json');
      final List<dynamic> list = json.decode(jsonString);
      return list.map((e) => Office.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [
        Office(id: '1', name: 'Head Office', latitude: -6.1751, longitude: 106.8271),
        Office(id: '2', name: 'Branch A', latitude: -6.2000, longitude: 106.8000),
        Office(id: '3', name: 'Branch B', latitude: -6.2500, longitude: 106.8500),
        Office(id: '4', name: 'Client Site', latitude: -6.3000, longitude: 106.9000),
      ];
    }
  }

  void _bumpVersion() {
    if (state is AttendanceLoaded) {
      final s = state as AttendanceLoaded;
      emit(s.copyWith(uiVersion: s.uiVersion + 1));
    }
  }

  // SETTERS
  void setLocationType(String type) {
    final s = state as AttendanceLoaded;
    emit(s.copyWith(
      locationType: type,
      selectedOffice: (type == 'Home' || type == 'Other') ? null : s.selectedOffice,
      customLocation: (type == 'Other') ? s.customLocation : '',
    ));
    _bumpVersion();
  }

  void selectOffice(Office? office) {
    emit((state as AttendanceLoaded).copyWith(selectedOffice: office));
    _bumpVersion();
  }

  void setCustomLocation(String location) {
    emit((state as AttendanceLoaded).copyWith(customLocation: location));
    _bumpVersion();
  }

  void setRemarks(String remarks) {
    emit((state as AttendanceLoaded).copyWith(remarks: remarks));
    _bumpVersion();
  }

  // GETTERS
  String get locationType => (state as AttendanceLoaded).locationType;
  Office? get selectedOffice => (state as AttendanceLoaded).selectedOffice;
  String get customLocation => (state as AttendanceLoaded).customLocation;
  String get remarks => (state as AttendanceLoaded).remarks;
  bool get isWatchingLocation => (state as AttendanceLoaded).isWatchingLocation;

  // CLOCK
  void _tickClock() {
    if (state is AttendanceLoaded) {
      final s = state as AttendanceLoaded;
      emit(s.copyWith(
        currentTime: _formatTime(DateTime.now()),
        uiVersion: s.uiVersion + 1,
      ));
    }
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final second = dt.second.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute:$second $ampm';
  }

  // LOCATION FETCH (ONE-SHOT)
  Future<void> fetchLocationOnce() async {
    final s = state as AttendanceLoaded;

    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      emit(s.copyWith(gpsLocation: 'Location services disabled', uiVersion: s.uiVersion + 1));
      return;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      emit(s.copyWith(gpsLocation: 'Permission denied.', uiVersion: s.uiVersion + 1));
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final formatted = 'Lat: ${pos.latitude.toStringAsFixed(4)}, Lon: ${pos.longitude.toStringAsFixed(4)}';
      emit(s.copyWith(
        gpsLocation: formatted,
        currentLatitude: pos.latitude,
        currentLongitude: pos.longitude,
        uiVersion: s.uiVersion + 1,
      ));
    } catch (e) {
      emit(s.copyWith(gpsLocation: 'Failed: $e', uiVersion: s.uiVersion + 1));
    }
  }

  // LIVE TRACKING
  void startLiveTracking() async {
    final s = state as AttendanceLoaded;
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) return;

    await _positionStream?.cancel();
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
    ).listen((pos) {
      final formatted = 'Lat: ${pos.latitude.toStringAsFixed(4)}, Lon: ${pos.longitude.toStringAsFixed(4)}';
      emit(s.copyWith(
        gpsLocation: formatted,
        currentLatitude: pos.latitude,
        currentLongitude: pos.longitude,
        isWatchingLocation: true,
        uiVersion: s.uiVersion + 1,
      ));
    });
  }

  void stopLiveTracking() async {
    await _positionStream?.cancel();
    _positionStream = null;
    final s = state as AttendanceLoaded;
    emit(s.copyWith(isWatchingLocation: false, uiVersion: s.uiVersion + 1));
  }

  // CLOCK IN/OUT - FULLY USES NEW LOG FIELDS
  Future<void> clockInOut() async {
    final s = state as AttendanceLoaded;
    final now = DateTime.now();
    final log = List<AttendanceLogEntry>.from(s.data.log);
    final location = _selectedLocationString();

    final entry = AttendanceLogEntry(
      date: now,
      attendanceDate: DateTime(now.year, now.month, now.day), // Actual day
      inTime: s.data.isClockedIn ? null : now,
      outTime: s.data.isClockedIn ? now : null,
      name: 'John Doe',
      designation: 'Software Engineer',
      inLocation: s.data.isClockedIn ? null : location,
      outLocation: s.data.isClockedIn ? location : null,
      officeId: s.data.isClockedIn ? null : selectedOffice?.id,
      outOfficeId: s.data.isClockedIn ? selectedOffice?.id : null,
      inRemarks: s.data.isClockedIn ? null : (remarks.isNotEmpty ? remarks : null),
      outRemarks: s.data.isClockedIn ? (remarks.isNotEmpty ? remarks : null) : null,
      inLatitude: s.data.isClockedIn ? null : s.currentLatitude,
      inLongitude: s.data.isClockedIn ? null : s.currentLongitude,
      outLatitude: s.data.isClockedIn ? s.currentLatitude : null,
      outLongitude: s.data.isClockedIn ? s.currentLongitude : null,
      locationType: locationType,
      inPlace: s.data.isClockedIn ? null : _selectedPlace(),
      outPlace: s.data.isClockedIn ? _selectedPlace() : null,
      isLeave: false,
      isHoliday: false,
      isOffDay: false,
      supervisorApproved: false,
      personId: 'user123', // Replace with real ID
      reason: null,
    );

    if (!s.data.isClockedIn) {
      log.insert(0, entry);
    } else if (log.isNotEmpty) {
      log[0] = log[0].copyWith(
        outTime: now,
        outLocation: location,
        outOfficeId: selectedOffice?.id,
        outRemarks: remarks.isNotEmpty ? remarks : log[0].outRemarks,
        outLatitude: s.currentLatitude,
        outLongitude: s.currentLongitude,
        outPlace: _selectedPlace(),
      );
    }

    final updated = s.data.copyWith(
      isClockedIn: !s.data.isClockedIn,
      lastClockTime: now,
      log: log,
    );

    emit(s.copyWith(
      data: updated,
      currentTime: _formatTime(now),
      remarks: '', // Clear after use
      uiVersion: s.uiVersion + 1,
    ));
  }

  String _selectedLocationString() {
    if (locationType == 'Home') return 'Home';
    if (locationType == 'Office' || locationType == 'Factory') {
      return selectedOffice?.name ?? '$locationType (none)';
    }
    return customLocation.isNotEmpty ? customLocation : 'Other';
  }

  String _selectedPlace() {
    if (locationType == 'Office' || locationType == 'Factory') {
      return selectedOffice?.name ?? '';
    }
    return customLocation;
  }

  @override
  Future<void> close() async {
    await _positionStream?.cancel();
    _clockTimer.cancel();
    _gpsTimer.cancel();
    return super.close();
  }
}