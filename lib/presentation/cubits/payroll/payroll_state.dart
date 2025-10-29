// presentation/cubits/payroll/payroll_state.dart
part of 'payroll_cubit.dart';

class PaymentItem {
  final String month;
  final String amount;
  final String status;

  const PaymentItem(this.month, this.amount, this.status);
}

class PayrollState {
  final double currentSalary;
  final double basic;
  final double bonus;
  final double tax;
  final double insurance;
  final List<PaymentItem> history;

  const PayrollState({
    required this.currentSalary,
    required this.basic,
    required this.bonus,
    required this.tax,
    required this.insurance,
    required this.history,
  });

  factory PayrollState.initial() => PayrollState(
        currentSalary: 5250.00,
        basic: 4500,
        bonus: 750,
        tax: -450,
        insurance: -300,
        history: const [
          PaymentItem('September 2025', '\$5,100', 'paid'),
          PaymentItem('August 2025', '\$5,200', 'paid'),
          PaymentItem('July 2025', '\$4,900', 'paid'),
        ],
      );
}