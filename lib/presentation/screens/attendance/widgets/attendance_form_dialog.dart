// lib/presentation/screens/attendance/widgets/attendance_form_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../cubits/attendance/attendance_cubit.dart';

class AttendanceFormDialog extends StatefulWidget {
  const AttendanceFormDialog({super.key});

  @override
  State<AttendanceFormDialog> createState() => _AttendanceFormDialogState();
}

class _AttendanceFormDialogState extends State<AttendanceFormDialog> {
  bool _isClockedIn = false;
  String _location = 'Fetching location...';
  String _locationType = 'Home';
  String _customLocation = '';
  final _customController = TextEditingController();

  final List<String> _officeLocations = [
    'Head Office',
    'Branch A',
    'Branch B',
    'Client Site',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentState();
    _getLocation();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentState() async {
    final state = context.read<AttendanceCubit>().state;
    if (state is AttendanceLoaded) {
      setState(() => _isClockedIn = state.data.isClockedIn);
    }
  }

  Future<void> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _location = 'Location disabled');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _location = 'Permission denied');
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _location = 'Lat: ${position.latitude.toStringAsFixed(2)}, Lon: ${position.longitude.toStringAsFixed(2)}';
      });
    } catch (e) {
      setState(() => _location = 'Failed to get location');
    }
  }

  String _getSelectedLocation() {
    if (_locationType == 'Home') return 'Home';
    if (_locationType == 'Office') return _officeLocations.first;
    return _customLocation.isEmpty ? 'Other' : _customLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54, // Dim background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5), // 5px outer padding
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            contentPadding: const EdgeInsets.all(5),
            titlePadding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            actionsPadding: const EdgeInsets.all(5),

            // FULL WIDTH: Use full available width
            insetPadding: EdgeInsets.zero,
            content: SizedBox(
              width: double.maxFinite, // Takes full width
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      'Clock In/Out',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // Icon
                    Icon(
                      _isClockedIn ? LucideIcons.logOut : LucideIcons.logIn,
                      size: 60,
                      color: _isClockedIn ? Colors.redAccent : Colors.green,
                    ),
                    const SizedBox(height: 12),

                    // Message
                    Text(
                      _isClockedIn ? 'Ready to Clock Out?' : 'Ready to Clock In?',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Location Type
                    const Text('Location Type', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'Home', label: Text('Home'), icon: Icon(LucideIcons.home, size: 18)),
                        ButtonSegment(value: 'Office', label: Text('Office'), icon: Icon(LucideIcons.building, size: 18)),
                        ButtonSegment(value: 'Other', label: Text('Other'), icon: Icon(LucideIcons.mapPin, size: 18)),
                      ],
                      selected: {_locationType},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _locationType = newSelection.first;
                          if (_locationType != 'Other') _customController.clear();
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Office Dropdown
                    if (_locationType == 'Office') ...[
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Select Office',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        value: _officeLocations.first,
                        items: _officeLocations
                            .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                            .toList(),
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Custom Input
                    if (_locationType == 'Other') ...[
                      TextField(
                        controller: _customController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Location',
                          hintText: 'e.g., Client Meeting Room',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        onChanged: (val) => _customLocation = val,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // GPS Location
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.mapPin, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _location,
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isClockedIn ? Colors.redAccent : Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        final selectedLocation = _getSelectedLocation();
                        context.read<AttendanceCubit>().clockInOut(location: selectedLocation);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(_isClockedIn
                                ? 'Clocked Out from $selectedLocation'
                                : 'Clocked In at $selectedLocation'),
                          ),
                        );
                      },
                      child: Text(_isClockedIn ? 'Clock Out' : 'Clock In'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}