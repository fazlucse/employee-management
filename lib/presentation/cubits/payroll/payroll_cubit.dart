// presentation/cubits/payroll/payroll_cubit.dart
import 'package:bloc/bloc.dart';
part 'payroll_state.dart';

class PayrollCubit extends Cubit<PayrollState> {
  PayrollCubit() : super(PayrollState.initial());
}