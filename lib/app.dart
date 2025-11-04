// app.dart
import 'package:employee_management/injections/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'presentation/cubits/theme/theme_cubit.dart';
import 'presentation/cubits/navigation/navigation_cubit.dart';
import 'presentation/screens/dashboard/dashboard_screen.dart';
import 'core/constants/app_colors.dart';

class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return AnimatedTheme(
            data: _getCurrentTheme(themeState.mode),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: ScreenUtilInit(
              designSize: const Size(390, 844), // base size (for example: iPhone 12)
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Company Dashboard',
                  theme: _lightTheme(),
                  darkTheme: _darkTheme(),
                  themeMode: _getThemeMode(themeState.mode),
                  home: BlocProvider(
                    create: (_) => NavigationCubit(),
                    child: const DashboardScreen(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  ThemeData _getCurrentTheme(AppThemeMode mode) {
    final isDark = mode == AppThemeMode.dark ||
        (mode == AppThemeMode.system && WidgetsBinding.instance.window.platformBrightness == Brightness.dark);
    return isDark ? _darkTheme() : _lightTheme();
  }

  ThemeData _lightTheme() => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBg,
        cardColor: AppColors.lightSurface,
        primaryColor: AppColors.lightPrimary,
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: AppColors.lightPrimary,
          surface: AppColors.lightSurface,
          background: AppColors.lightBg,
        ),
      );

  ThemeData _darkTheme() => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBg,
        cardColor: AppColors.darkSurface,
        primaryColor: AppColors.darkPrimary,
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.darkPrimary,
          surface: AppColors.darkSurface,
          background: AppColors.darkBg,
        ),
      );

  ThemeMode _getThemeMode(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
  }
}
