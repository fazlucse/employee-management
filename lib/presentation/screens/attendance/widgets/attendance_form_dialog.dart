import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
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
          padding: EdgeInsets.all(8.w),
            child: Material(
              elevation: 24,
              borderRadius: BorderRadius.circular(15.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 450.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface(context).withOpacity(0.96),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: AppColors.gray200(context).withOpacity(0.6),
                        width: 1,
                      ),
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
                final isIn = (state is AttendanceLoaded) && state.data.isClockedIn;
                return SliverPersistentHeader(
                  pinned: true,
                  delegate: _FixedHeaderDelegate(height: 70.h, isClockedIn: isIn),
                );
              },
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
                child: Column(
                  children: [
                    BlocBuilder<AttendanceCubit, AttendanceState>(
                      builder: (context, state) {
                        if (state is! AttendanceLoaded) {
                          return CircularProgressIndicator(color: AppColors.primary(context));
                        }
                        final isIn = state.data.isClockedIn;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isIn
                                  ? [AppColors.danger.withOpacity(0.1), AppColors.danger.withOpacity(0.05)]
                                  : [AppColors.success.withOpacity(0.1), AppColors.success.withOpacity(0.05)],
                            ),
                            borderRadius: BorderRadius.circular(24.r),
                            border: Border.all(
                              color: isIn ? AppColors.danger.withOpacity(0.3) : AppColors.success.withOpacity(0.3),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (isIn ? AppColors.danger : AppColors.success).withOpacity(0.1),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: const LiveClock(),
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    _Section('Location Type', const _LocationTypeGrid()),
                    SizedBox(height: 20.h),
                    _Section('Selection', const _LocationInput()),
                    SizedBox(height: 20.h),
                    _Section('Notes', const _RemarksInput()),
                    SizedBox(height: 20.h),
                    const _GPSPanel(),
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        const Expanded(child: _CancelButton()),
                        SizedBox(width: 16.w),
                        const Expanded(child: _ClockButton()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        Positioned(
          top: 10.h,
          right: 16.w,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.gray100(context),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)],
              ),
              child: Icon(LucideIcons.x, size: 24.sp, color: AppColors.textSecondary(context)),
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────── FIXED HEADER DELEGATE ────────────────────────
class _FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final bool isClockedIn;
  const _FixedHeaderDelegate({required this.height, required this.isClockedIn});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.gray100(context), AppColors.surface(context)]),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 80.w, 16.h),
      child: Text(
        'Add Attendance',
        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColors.text(context)),
      ),
    );
  }

  @override double get maxExtent => height;
  @override double get minExtent => height;
  @override bool shouldRebuild(covariant _FixedHeaderDelegate old) => old.isClockedIn != isClockedIn;
}

// ──────────────────────── CANCEL & CLOCK BUTTONS (DEFINED EARLY) ────────────────────────
class _CancelButton extends StatelessWidget {
  const _CancelButton();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text('Cancel', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary(context))),
    );
  }
}

class _ClockButton extends StatelessWidget {
  const _ClockButton();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceCubit, AttendanceState>(
      builder: (context, state) {
        if (state is! AttendanceLoaded) return const SizedBox.shrink();
        final isIn = state.data.isClockedIn;
        final buttonColor = isIn ? AppColors.danger : AppColors.success;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            elevation: 8,
            shadowColor: buttonColor.withOpacity(0.3),
          ),
          onPressed: () {
            context.read<AttendanceCubit>().clockInOut();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(isIn ? 'Clocked Out [Checkmark]' : 'Clocked In [Checkmark]', style: const TextStyle(color: Colors.white)),
                backgroundColor: buttonColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            );
          },
          child: Text(isIn ? 'Clock Out' : 'Clock In',
              style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.white)),
        );
      },
    );
  }
}

// ──────────────────────── REUSABLE SECTION ────────────────────────
class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section(this.title, this.child);
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.text(context))),
          SizedBox(height: 8.h),
          child,
        ],
      );
}

// ──────────────────────── LIVE CLOCK ────────────────────────
class LiveClock extends StatefulWidget {
  const LiveClock({super.key});
  @override State<LiveClock> createState() => _LiveClockState();
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
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minutes = now.minute.toString().padLeft(2, '0');
    final formatted = '$hour:$minutes';
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    final dayName = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][now.weekday - 1];
    final monthName = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][now.month - 1];
    final formattedDate = '$dayName ${now.day.toString().padLeft(2, '0')} $monthName ${now.year}';

    if (_time != formatted || _ampm != ampm || _date != formattedDate) {
      setState(() => {_time = formatted, _ampm = ampm, _date = formattedDate});
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIn = context.select<AttendanceCubit, bool>(
      (c) => c.state is AttendanceLoaded && (c.state as AttendanceLoaded).data.isClockedIn,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(LucideIcons.clock, size: 36.sp, color: isIn ? AppColors.danger : AppColors.success),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$_time $_ampm',
                  style: TextStyle(
                      fontFamily: 'RobotoMono',
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text(context),
                      height: 1.0)),
              SizedBox(height: 2.h),
              Text(_date,
                  style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary(context), height: 1.0)),
            ],
          ),
        ),
      ],
    );
  }
}

// ──────────────────────── LOCATION TYPE GRID ────────────────────────
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
            final w = (constraints.maxWidth - 12.w) / 2;
            return Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: ['Home', 'Office', 'Factory', 'Other']
                  .map((l) => SizedBox(
                      width: w,
                      child: _LocationButton(
                          label: l, isSelected: selected == l, onTap: () => cubit.setLocationType(l))))
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
  const _LocationButton({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary(context) : AppColors.gray100(context),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
                color: isSelected ? AppColors.primary(context) : AppColors.gray300(context)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: isSelected ? 12 : 6)
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<String>(
                  value: label,
                  groupValue: isSelected ? label : null,
                  onChanged: (_) => onTap(),
                  activeColor: Colors.white),
              SizedBox(width: 8.w),
              Text(label,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.text(context))),
            ],
          ),
        ),
      );
}

// ──────────────────────── REMARKS INPUT ────────────────────────
class _RemarksInput extends StatelessWidget {
  const _RemarksInput();
  @override
  Widget build(BuildContext context) => BlocSelector<AttendanceCubit, AttendanceState, String>(
        selector: (s) => s is AttendanceLoaded ? s.remarks : '',
        builder: (context, remarks) {
          final cubit = context.read<AttendanceCubit>();
          return TextField(
            controller: TextEditingController(text: remarks)
              ..selection = TextSelection.fromPosition(TextPosition(offset: remarks.length)),
            onChanged: cubit.setRemarks,
            maxLines: 3,
            style: TextStyle(fontSize: 14.sp, color: AppColors.text(context)),
            decoration: InputDecoration(
              hintText: 'Optional notes',
              hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary(context)),
              filled: true,
              fillColor: AppColors.gray100(context),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.gray300(context))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.primary(context), width: 2)),
              contentPadding: EdgeInsets.all(16.w),
            ),
          );
        },
      );
}

// ──────────────────────── LOCATION INPUT ────────────────────────
class _LocationInput extends StatelessWidget {
  const _LocationInput();
  @override
  Widget build(BuildContext context) => BlocSelector<AttendanceCubit, AttendanceState, (String, List<Office>, Office?)>(
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
              dropdownColor: AppColors.surface(context),
              style: TextStyle(color: AppColors.text(context)),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.gray100(context),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              ),
              items: offices
                  .map((o) => DropdownMenuItem(
                      value: o, child: Text(o.name, style: TextStyle(color: AppColors.text(context)))))
                  .toList(),
              onChanged: cubit.selectOffice,
            );
          } else if (type == 'Other') {
            return TextField(
              controller: TextEditingController(text: cubit.customLocation)
                ..selection = TextSelection.fromPosition(TextPosition(offset: cubit.customLocation.length)),
              onChanged: cubit.setCustomLocation,
              style: TextStyle(color: AppColors.text(context)),
              decoration: InputDecoration(
                hintText: 'Custom location',
                hintStyle: TextStyle(color: AppColors.textSecondary(context)),
                filled: true,
                fillColor: AppColors.gray100(context),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      );
}

// ──────────────────────── GPS PANEL ────────────────────────
class _GPSPanel extends StatelessWidget {
  const _GPSPanel();
  @override
  Widget build(BuildContext context) => BlocBuilder<AttendanceCubit, AttendanceState>(
        builder: (context, state) {
          final gps = state is AttendanceLoaded ? state.gpsLocation : 'Loading...';
          final denied = gps.contains('denied');
          final watching = state is AttendanceLoaded && state.isWatchingLocation;
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.gray100(context),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.gray200(context)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
            ),
            child: Row(
              children: [
                Icon(LucideIcons.mapPin, size: 28.sp, color: watching ? AppColors.success : AppColors.blue),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GPS',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: AppColors.text(context))),
                      Text(gps,
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: denied ? AppColors.danger : AppColors.textSecondary(context))),
                      if (watching) Text('Live', style: TextStyle(fontSize: 11.sp, color: AppColors.success)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: 'track',
                      backgroundColor: watching ? AppColors.success : AppColors.blue,
                      onPressed: () => watching
                          ? context.read<AttendanceCubit>().stopLiveTracking()
                          : context.read<AttendanceCubit>().startLiveTracking(),
                      child: Icon(watching ? Icons.location_on : Icons.location_searching, size: 18.sp, color: Colors.white),
                    ),
                    SizedBox(height: 8.h),
                    FloatingActionButton.small(
                      heroTag: 'refresh',
                      backgroundColor: AppColors.gray400(context),
                      onPressed: () => context.read<AttendanceCubit>().fetchLocationOnce(),
                      child: Icon(Icons.refresh, size: 18.sp, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
}