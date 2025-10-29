import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFF06B6D4), // Cyan-400
    scaffoldBackgroundColor: const Color(0xFFF9FAFB), // Gray-50
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF06B6D4),
      secondary: Color(0xFF3B82F6),
      surface: Colors.white,
      background: Color(0xFFF9FAFB),
      error: Color(0xFFEF4444),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    // cardTheme: CardTheme(
    //   elevation: 2,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(12),
    //   ),
    // ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF06B6D4),
    scaffoldBackgroundColor: const Color(0xFF111827),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF06B6D4),
      secondary: Color(0xFF3B82F6),
      surface: Color(0xFF1F2937),
      background: Color(0xFF111827),
      error: Color(0xFFEF4444),
    ),
  );
}