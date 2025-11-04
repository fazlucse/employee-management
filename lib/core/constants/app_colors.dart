import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Grays
  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = Color(0xFF2563EB);
  static const Color lightGray100 = Color(0xFFF1F5F9);
  static const Color lightGray200 = Color(0xFFE2E8F0);
  static const Color lightGray300 = Color(0xFFCBD5E1);
  static const Color lightGray400 = Color(0xFF94A3B8);
  static const Color lightGray500 = Color(0xFF64748B);
  static const Color lightGray600 = Color(0xFF475569);
  static const Color lightGray700 = Color(0xFF334155);

  // Dark Theme Grays
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkPrimary = Color(0xFF3B82F6);
  static const Color darkGray100 = Color(0xFF1E293B);
  static const Color darkGray200 = Color(0xFF273449);
  static const Color darkGray300 = Color(0xFF2F3C59);
  static const Color darkGray400 = Color(0xFF94A3B8);
  static const Color darkGray500 = Color(0xFF64748B);
  static const Color darkGray600 = Color(0xFF475569);
  static const Color darkGray700 = Color(0xFF334155);

  // Shared Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color blue = Color(0xFF3B82F6);
  static const Color green = Color(0xFF10B981);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color orange = Color(0xFFF97316);
  static const Color gray = Color(0xFF1E293B);

  // Theme-aware getters
  static Color bg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkBg : lightBg;

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkSurface : lightSurface;

  static Color primary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkPrimary : lightPrimary;

  static Color gray100(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkGray100 : lightGray100;

  static Color gray200(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkGray200 : lightGray200;

  static Color gray300(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkGray300 : lightGray300;

  static Color gray400(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkGray400 : lightGray400;

  static Color gray500(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkGray500 : lightGray500;

  static Color gray600(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkGray600 : lightGray600;

  static Color gray700(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkGray700 : lightGray700;
      static Color text(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.lightGray700;

static Color textSecondary(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? Colors.white70 : AppColors.lightGray500;
}
