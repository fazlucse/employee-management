// presentation/screens/reports/reports_screen.dart
import 'package:employee_management/presentation/reports/reports_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../reports/reports_state.dart';
import 'widgets/report_tile.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Reports')),
        body: BlocBuilder<ReportsCubit, ReportsState>(
          builder: (context, state) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.reports.length,
              itemBuilder: (_, i) => ReportTile(report: state.reports[i]),
            );
          },
        ),
      ),
    );
  }
}