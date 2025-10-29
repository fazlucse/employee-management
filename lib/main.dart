import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'injections/di.dart' as di;

void main() {
  di.init();
  runApp(const DashboardApp());
}