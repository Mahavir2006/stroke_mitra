import 'package:flutter/material.dart';

class AppTheme {
  // Medical Grade Palette Translated From index.css and landing.css
  static const Color primary = Color(0xFF2E86B0); // Deep Ocean Teal
  static const Color primaryLight = Color(0xFFEBF7FC);
  static const Color secondary = Color(0xFF4CB88C); // Sage Green
  static const Color bgApp = Color(0xFFF5F7FA); // Off-white cool
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF29333D); // Dark Slate
  static const Color textMuted = Color(0xFF6B7A8A); // Soft Grey
  
  // Landing Page Tokens
  static const Color lpBlue500 = Color(0xFF0EA5E9);
  static const Color lpBlue700 = Color(0xFF0369A1);
  static const Color lpTeal400 = Color(0xFF2DD4BF);
  static const Color lpOrange400 = Color(0xFFFB923C);
  static const Color lpGreen400 = Color(0xFF4ADE80);
  static const Color lpSlate800 = Color(0xFF1E293B);
  static const Color lpSlate500 = Color(0xFF64748B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgApp,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        background: bgApp,
        surface: bgCard,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w800, color: lpSlate800),
        displayMedium: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700, color: lpSlate800),
        bodyLarge: TextStyle(color: textMain),
        bodyMedium: TextStyle(color: textMuted),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
      cardTheme: CardTheme(
        color: bgCard,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
