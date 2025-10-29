// presentation/cubits/reports/reports_state.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ReportItem {
  final String title;
  final String date;
  final IconData icon;
  final Color color;

  const ReportItem(this.title, this.date, this.icon, this.color);
}

class ReportsState {
  final List<ReportItem> reports;
  const ReportsState(this.reports);

  factory ReportsState.initial() => ReportsState([
        ReportItem('Monthly Timesheet', 'October 2025', LucideIcons.clock, Colors.blue),
        ReportItem('Leave Balance Report', 'As of Oct 28', LucideIcons.calendar, Colors.green),
        ReportItem('Performance Review', 'Q3 2025', LucideIcons.trendingUp, Colors.purple),
        ReportItem('Task Summary', 'This Week', LucideIcons.checkCircle, Colors.orange),
      ]);
}