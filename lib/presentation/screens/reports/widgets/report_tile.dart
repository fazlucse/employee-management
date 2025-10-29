// presentation/screens/reports/widgets/report_tile.dart
import 'package:employee_management/presentation/reports/reports_cubit.dart';
import 'package:flutter/material.dart';

import '../../../reports/reports_state.dart';

class ReportTile extends StatelessWidget {
  final ReportItem report;
  const ReportTile({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: report.color.withOpacity(0.1), child: Icon(report.icon, color: report.color)),
        title: Text(report.title),
        subtitle: Text(report.date),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}