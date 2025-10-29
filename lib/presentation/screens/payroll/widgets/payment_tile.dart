// presentation/screens/payroll/widgets/payment_tile.dart
import 'package:flutter/material.dart';

import '../../../cubits/payroll/payroll_cubit.dart';

class PaymentTile extends StatelessWidget {
  final PaymentItem payment;

  const PaymentTile({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(payment.month),
        subtitle: const Text('Net Salary'),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(payment.amount, style: const TextStyle(fontWeight: FontWeight.bold)),
            Chip(
              label: Text(payment.status),
              backgroundColor: payment.status == 'paid' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            ),
          ],
        ),
      ),
    );
  }
}