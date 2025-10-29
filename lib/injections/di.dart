import 'package:employee_management/presentation/reports/reports_cubit.dart';
import 'package:get_it/get_it.dart';
import '../presentation/cubits/navigation/navigation_cubit.dart';
import '../presentation/cubits/dashboard/dashboard_cubit.dart';
import '../presentation/cubits/tasks/tasks_cubit.dart';
import '../presentation/cubits/stats/stats_cubit.dart';
import '../presentation/cubits/notifications/notifications_cubit.dart';
import '../presentation/cubits/messages/messages_cubit.dart';
import '../presentation/cubits/team/team_cubit.dart';
import '../presentation/cubits/projects/projects_cubit.dart';
import '../presentation/cubits/payroll/payroll_cubit.dart';
import '../presentation/cubits/settings/settings_cubit.dart';
import '../presentation/cubits/profile/profile_cubit.dart';
import '../presentation/cubits/theme/theme_cubit.dart';

final getIt = GetIt.instance;

void init() {
  getIt.registerFactory(() => NavigationCubit());
  getIt.registerFactory(() => DashboardCubit());
  getIt.registerFactory(() => TasksCubit());
  getIt.registerFactory(() => StatsCubit());
  getIt.registerFactory(() => NotificationsCubit());
  getIt.registerFactory(() => ReportsCubit());
  getIt.registerFactory(() => MessagesCubit());
  getIt.registerFactory(() => TeamCubit());
  getIt.registerFactory(() => ProjectsCubit());
  getIt.registerFactory(() => PayrollCubit());
  // getIt.registerFactory(() => AchievementsCubit());
  getIt.registerFactory(() => SettingsCubit());
  getIt.registerFactory(() => ProfileCubit());
  getIt.registerLazySingleton(() => ThemeCubit());
}