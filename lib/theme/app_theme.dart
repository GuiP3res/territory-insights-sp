import 'package:flutter/material.dart';

class AppTheme {
  static const ink = Color(0xFF102A43);
  static const teal = Color(0xFF00A896);
  static const mint = Color(0xFFE6FFFA);
  static const amber = Color(0xFFFFC857);
  static const bg = Color(0xFFF4F7F8);

  static ThemeData build({bool highContrast = false}) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: highContrast ? Colors.white : bg,
      colorScheme: ColorScheme.fromSeed(seedColor: teal),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.w800, color: ink),
        titleLarge: TextStyle(fontWeight: FontWeight.w800, color: ink),
        bodyLarge: TextStyle(color: ink),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
    );
  }
}
