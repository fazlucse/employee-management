// presentation/screens/payroll/payroll_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubits/payroll/payroll_cubit.dart';
import 'widgets/payment_tile.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PayrollCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Payroll')),
        body: BlocBuilder<PayrollCubit, PayrollState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Current Month Salary', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('\$${state.currentSalary}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          const Divider(),
                          _buildRow('Basic', state.basic),
                          _buildRow('Bonus', state.bonus),
                          _buildRow('Tax', state.tax),
                          _buildRow('Insurance', state.insurance),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Payment History', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...state.history.map((p) => PaymentTile(payment: p)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(String label, double value) {
    final color = value < 0 ? Colors.red : null;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('\$${value.abs()}', style: TextStyle(color: color)),
        ],
      ),
    );
  }
}