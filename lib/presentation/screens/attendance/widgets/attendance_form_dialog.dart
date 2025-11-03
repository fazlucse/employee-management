import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../data/models/office.dart';
import '../../../cubits/attendance/attendance_cubit.dart';

class AttendanceFormDialog extends StatelessWidget {
  const AttendanceFormDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              elevation: 24,
              borderRadius: BorderRadius.circular(28),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.96),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: Colors.white60, width: 1),
                    ),
                    child: const _DialogContent(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogContent extends StatelessWidget {
  const _DialogContent();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            BlocBuilder<AttendanceCubit, AttendanceState>(
              builder: (context, state) {
                final isIn =
                    (state is AttendanceLoaded) && state.data.isClockedIn;
                return SliverAppBar(
  pinned: true,
  floating: true,
  snap: true,
  expandedHeight: 120,
  collapsedHeight: 70,  // ← Explicit collapsed height (title + padding)
  backgroundColor: Colors.white,
  elevation: 1,
  automaticallyImplyLeading: false,
  flexibleSpace: LayoutBuilder(
    builder: (context, constraints) {
      final isCollapsed = constraints.maxHeight <= 80;  // Detect collapsed state
      return FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        titlePadding: EdgeInsets.fromLTRB(24, 0, 80, isCollapsed ? 12 : 16),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isIn ? LucideIcons.logOut : LucideIcons.logIn,
                  size: 18,
                  color: isIn ? Colors.red.shade600 : Colors.green.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add Attendance',
                  style: TextStyle(
                    fontSize: isCollapsed ? 20 : 22,  // ← Smaller font when collapsed
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
            AnimatedOpacity(  // ← Fade out subtitle smoothly
              duration: const Duration(milliseconds: 150),
              opacity: isCollapsed ? 0.0 : 1.0,
              child: Text(
                'Clock in/out precisely',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.grey.shade50, Colors.white]),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 4))],
          ),
        ),
      );
    },
  ),
);
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                child: Column(
                  children: [
                    BlocBuilder<AttendanceCubit, AttendanceState>(
                      builder: (context, state) {
                        if (state is! AttendanceLoaded)
                          return const CircularProgressIndicator();
                        final isIn = state.data.isClockedIn;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isIn
                                  ? [Colors.red.shade50, Colors.red.shade100]
                                  : [
                                      Colors.green.shade50,
                                      Colors.green.shade100,
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isIn
                                  ? Colors.red.shade200
                                  : Colors.green.shade200,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (isIn ? Colors.red : Colors.green)
                                    .withOpacity(0.2),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: const LiveClock(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    _Section('Location Type', const _LocationTypeGrid()),
                    const SizedBox(height: 20),
                    _Section('Selection', const _LocationInput()),
                    const SizedBox(height: 20),
                    _Section('Notes', const _RemarksInput()),
                    const SizedBox(height: 20),
                    const _GPSPanel(),
                    const SizedBox(height: 32),
                    Row(
                      children: const [
                        Expanded(child: _CancelButton()),
                        SizedBox(width: 16),
                        Expanded(child: _ClockButton()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 16,
          right: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(blurRadius: 8)],
              ),
              child: Icon(LucideIcons.x, size: 24, color: Colors.grey.shade700),
            ),
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section(this.title, this.child);
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
      const SizedBox(height: 8),
      child,
    ],
  );
}

class LiveClock extends StatefulWidget {
  const LiveClock({super.key});
  @override
  State<LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  late Timer _timer;
  String _time = '', _ampm = '', _date = '';

  @override
  void initState() {
    super.initState();
    _update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _update());
  }

  void _update() {
    final now = DateTime.now();
    final hour = now.hour > 12
        ? now.hour - 12
        : (now.hour == 0 ? 12 : now.hour);
    final formatted =
        '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    final date =
        '${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][now.weekday - 1]} ${now.day.toString().padLeft(2, '0')} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][now.month - 1]} ${now.year}';
    if (_time != formatted || _ampm != ampm || _date != date)
      setState(() => {_time = formatted, _ampm = ampm, _date = date});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIn = context.select<AttendanceCubit, bool>(
      (c) =>
          c.state is AttendanceLoaded &&
          (c.state as AttendanceLoaded).data.isClockedIn,
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.clock,
              size: 32,
              color: isIn ? Colors.red.shade600 : Colors.green.shade600,
            ),
            const SizedBox(width: 12),
            Expanded(
              // ← Added Expanded to prevent overflow in tight spaces
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _time,
                    style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 40,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        _ampm,
                        style: TextStyle(
                          fontSize: 16,
                          color: isIn
                              ? Colors.red.shade600
                              : Colors.green.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _date,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LocationTypeGrid extends StatelessWidget {
  const _LocationTypeGrid();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        final cubit = context.read<AttendanceCubit>();
        final selected = cubit.locationType;
        return LayoutBuilder(
          builder: (context, constraints) {
            final w = (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ['Home', 'Office', 'Factory', 'Other']
                  .map(
                    (l) => SizedBox(
                      width: w,
                      child: _LocationButton(
                        label: l,
                        isSelected: selected == l,
                        onTap: () => cubit.setLocationType(l),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        );
      },
    );
  }
}

class _LocationButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _LocationButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 56, // ← Reduced height from 64 to 56
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: isSelected ? 12 : 6),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio<String>(
            value: label,
            groupValue: isSelected ? label : null,
            onChanged: (_) => onTap(),
            activeColor: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    ),
  );
}

class _RemarksInput extends StatelessWidget {
  const _RemarksInput();
  @override
  Widget build(BuildContext context) =>
      BlocSelector<AttendanceCubit, AttendanceState, String>(
        selector: (s) => s is AttendanceLoaded ? s.remarks : '',
        builder: (context, remarks) {
          final cubit = context.read<AttendanceCubit>();
          return TextField(
            controller: TextEditingController(text: remarks)
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: remarks.length),
              ),
            onChanged: cubit.setRemarks,
            maxLines: 3,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Optional notes',
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF6C5CE7),
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          );
        },
      );
}

class _LocationInput extends StatelessWidget {
  const _LocationInput();
  @override
  Widget build(BuildContext context) =>
      BlocSelector<
        AttendanceCubit,
        AttendanceState,
        (String, List<Office>, Office?)
      >(
        selector: (s) {
          if (s is! AttendanceLoaded) return ('Home', [], null);
          final c = context.read<AttendanceCubit>();
          return (c.locationType, s.offices, c.selectedOffice);
        },
        builder: (context, data) {
          final (type, offices, selected) = data;
          final cubit = context.read<AttendanceCubit>();
          if (type == 'Office' || type == 'Factory') {
            return DropdownButtonFormField<Office>(
              value: selected,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              items: offices
                  .map((o) => DropdownMenuItem(value: o, child: Text(o.name)))
                  .toList(),
              onChanged: cubit.selectOffice,
            );
          } else if (type == 'Other') {
            return TextField(
              controller: TextEditingController(text: cubit.customLocation)
                ..selection = TextSelection.fromPosition(
                  TextPosition(offset: cubit.customLocation.length),
                ),
              onChanged: cubit.setCustomLocation,
              decoration: InputDecoration(
                hintText: 'Custom location',
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      );
}

class _GPSPanel extends StatelessWidget {
  const _GPSPanel();
  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<AttendanceCubit, AttendanceState>(
    builder: (context, state) {
      final gps = state is AttendanceLoaded ? state.gpsLocation : 'Loading...';
      final denied = gps.contains('denied');
      final watching = state is AttendanceLoaded && state.isWatchingLocation;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(blurRadius: 8)],
        ),
        child: Row(
          children: [
            Icon(
              LucideIcons.mapPin,
              size: 28,
              color: watching ? Colors.green : Colors.blue,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('GPS', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    gps,
                    style: TextStyle(
                      fontSize: 13,
                      color: denied ? Colors.red : Colors.black87,
                    ),
                  ),
                  if (watching)
                    Text(
                      'Live',
                      style: TextStyle(fontSize: 11, color: Colors.green),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'track',
                  backgroundColor: watching ? Colors.green : Colors.blue,
                  onPressed: () => watching
                      ? context.read<AttendanceCubit>().stopLiveTracking()
                      : context.read<AttendanceCubit>().startLiveTracking(),
                  child: Icon(
                    watching ? Icons.location_on : Icons.location_searching,
                    size: 18,
                  ),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'refresh',
                  backgroundColor: Colors.grey,
                  onPressed: () =>
                      context.read<AttendanceCubit>().fetchLocationOnce(),
                  child: const Icon(Icons.refresh, size: 18),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

class _CancelButton extends StatelessWidget {
  const _CancelButton();
  @override
  Widget build(BuildContext context) => TextButton(
    onPressed: () => Navigator.pop(context),
    child: Text(
      'Cancel',
      style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
    ),
  );
}

class _ClockButton extends StatelessWidget {
  const _ClockButton();
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, state) {
          if (state is! AttendanceLoaded) return const SizedBox.shrink();
          final isIn = state.data.isClockedIn;
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isIn
                  ? Colors.red.shade500
                  : Colors.green.shade500,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
            ),
            onPressed: () {
              context.read<AttendanceCubit>().clockInOut();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isIn ? 'Clocked Out ✓' : 'Clocked In ✓'),
                  backgroundColor: isIn ? Colors.red : Colors.green,
                ),
              );
            },
            child: Text(
              isIn ? 'Clock Out' : 'Clock In',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        },
      );
}
