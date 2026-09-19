import 'package:flutter/material.dart';
abstract final class AppTheme {
  static const teal = Color(0xFF009C9A); static const orange = Color(0xFFFF7A00);
  static final light = ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: teal, primary: teal, secondary: orange), scaffoldBackgroundColor: Colors.white, inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()));
}
