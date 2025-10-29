// presentation/cubits/reports/reports_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsState.initial());
}