import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../data/models/attendance_data.dart';
import '../../../data/models/attendance_log_entry.dart';
import '../../cubits/attendance/attendance_cubit.dart';
import 'widgets/back_app_bar.dart';
import 'widgets/attendance_form_dialog.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceCubit(attendanceStream: _mockRealTimeStream()),
      child: const _AttendanceListView(),
    );
  }

  Stream<AttendanceData> _mockRealTimeStream() async* {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    while (true) {
      yield AttendanceData(
        log: [
          AttendanceLogEntry(
            date: today,
            inTime: today.add(const Duration(hours: 10, minutes: 1)),
            outTime: today.add(const Duration(hours: 18, minutes: 30)),
            name: 'John Doe',
            designation: 'Software Engineer',
            inLocation: 'Head Office',
            outLocation: 'Head Office',
          ),
          AttendanceLogEntry(
            date: today.subtract(const Duration(days: 1)),
            inTime: today.subtract(const Duration(days: 1)).add(const Duration(hours: 9, minutes: 45)),
            outTime: today.subtract(const Duration(days: 1)).add(const Duration(hours: 18, minutes: 15)),
            name: 'John Doe',
            designation: 'Software Engineer',
            inLocation: 'Remote',
            outLocation: 'Remote',
          ),
        ],
      );
      await Future.delayed(const Duration(seconds: 30));
    }
  }
}

class _AttendanceListView extends StatelessWidget {
  const _AttendanceListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(goBackTo: 'home'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAttendanceForm(context),
        child: const Icon(LucideIcons.clock),
        tooltip: 'Clock In/Out',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Attendance History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: BlocSelector<AttendanceCubit, AttendanceState, List<AttendanceLogEntry>>(
                selector: (state) => state is AttendanceLoaded ? state.data.log : [],
                builder: (context, log) {
                  if (log.isEmpty) {
                    return const Center(
                      child: Text('No records yet', style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return ListView.separated(
                    itemCount: log.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _AttendanceLogCard(entry: log[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttendanceForm(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AttendanceFormDialog(),
    );
  }
}

// Reusable Log Card
class _AttendanceLogCard extends StatelessWidget {
  final AttendanceLogEntry entry;
  const _AttendanceLogCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('MMM dd, yyyy');
    final timeFmt = DateFormat('hh:mm a');

    final inTime = entry.inTime != null ? timeFmt.format(entry.inTime!) : '--:--';
    final outTime = entry.outTime != null ? timeFmt.format(entry.outTime!) : '--:--';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dateFmt.format(entry.date), style: const TextStyle(fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(entry.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(entry.designation, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(LucideIcons.logIn, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(inTime, style: const TextStyle(fontWeight: FontWeight.w500)),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('|', style: TextStyle(color: Colors.grey))),
                const Icon(LucideIcons.logOut, size: 16, color: Colors.red),
                const SizedBox(width: 4),
                Text(outTime, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (entry.inLocation != null) ...[
                  const Icon(LucideIcons.mapPin, size: 14, color: Colors.blue),
                  const SizedBox(width: 4),
                  Text(entry.inLocation!, style: const TextStyle(fontSize: 13)),
                ],
                const Spacer(),
                if (entry.outLocation != null) ...[
                  Text(entry.outLocation!, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 4),
                  const Icon(LucideIcons.mapPin, size: 14, color: Colors.blue),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}