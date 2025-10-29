// presentation/screens/stats/stats_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/stats/stats_cubit.dart';
import 'widgets/stat_card.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatsCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Statistics')),
        body: BlocBuilder<StatsCubit, StatsState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('This Week', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: StatCard(title: 'Working Hours', value: '${state.workingHoursThisWeek}/40', color: Colors.blue)),
                      const SizedBox(width: 12),
                      Expanded(child: StatCard(title: 'Tasks Completed', value: '${state.tasksCompleted}/15', color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Monthly Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 2.2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: [
                      StatCard(title: 'Total Hours', value: state.totalHoursMonth.toString(), color: Colors.purple),
                      StatCard(title: 'Tasks Done', value: state.tasksDoneMonth.toString(), color: Colors.orange),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}