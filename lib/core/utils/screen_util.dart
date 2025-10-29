import 'package:flutter/material.dart';

class ScreenUtil {
  static late double width;
  static late double height;

  static void init(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
  }

  static double w(double val) => val * (width / 375);
  static double h(double val) => val * (height / 812);
}