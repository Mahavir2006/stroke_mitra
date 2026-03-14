/// Stroke Mitra - Application Theme
///
/// Medical-grade, calm & reassuring design system matching the
/// original React app's HSL-based color palette.
/// Fonts: Inter (body) + Outfit (headings) via Google Fonts.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ─── Primary Colors — Deep Ocean Teal ───
  static const Color primary = Color(0xFF2E86B0);
  static const Color primaryLight = Color(0xFFE8F4FA);
  static const Color primaryDark = Color(0xFF0369A1);

  // ─── Secondary — Sage Green ───
  static const Color secondary = Color(0xFF4CB88C);

  // ─── Landing Page Color Palette ───
  static const Color blue50 = Color(0xFFEFF8FF);
  static const Color blue100 = Color(0xFFDBEFFE);
  static const Color blue400 = Color(0xFF38BDF8);
  static const Color blue500 = Color(0xFF0EA5E9);
  static const Color blue600 = Color(0xFF0284C7);
  static const Color blue700 = Color(0xFF0369A1);
  static const Color blue900 = Color(0xFF0C4A6E);

  static const Color teal400 = Color(0xFF2DD4BF);
  static const Color teal500 = Color(0xFF14B8A6);
  static const Color teal600 = Color(0xFF0D9488);

  static const Color orange400 = Color(0xFFFB923C);
  static const Color orange500 = Color(0xFFF97316);
  static const Color orange600 = Color(0xFFEA580C);

  static const Color green400 = Color(0xFF4ADE80);
  static const Color green500 = Color(0xFF22C55E);
  static const Color green600 = Color(0xFF16A34A);

  static const Color red500 = Color(0xFFEF4444);
  static const Color red600 = Color(0xFFDC2626);

  // ─── Slate Palette ───
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate950 = Color(0xFF020617);

  // ─── Backgrounds ───
  static const Color bgApp = Color(0xFFF5F7FA);
  static const Color bgCard = Colors.white;

  // ─── Status Colors ───
  static const Color statusSuccess = Color(0xFF4CB88C);
  static const Color statusWarning = Color(0xFFE6A846);
  static const Color statusError = Color(0xFFE05C5C);

  // ─── Gradient Definitions ───
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0C4A6E), Color(0xFF0369A1), Color(0xFF0D9488)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blue500, blue700],
  );

  static const LinearGradient ctaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0369A1), Color(0xFF0D9488)],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [slate900, Color(0xFF0C4A6E)],
  );

  // ─── Text Styles ───
  static TextStyle get headingXL => GoogleFonts.outfit(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        color: slate900,
        letterSpacing: -1.5,
        height: 1.08,
      );

  static TextStyle get headingLG => GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: slate900,
        letterSpacing: -1.2,
        height: 1.15,
      );

  static TextStyle get headingMD => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: slate900,
        letterSpacing: -0.8,
      );

  static TextStyle get headingSM => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: slate900,
        letterSpacing: -0.4,
      );

  static TextStyle get bodyLG => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: slate500,
        height: 1.7,
      );

  static TextStyle get bodyMD => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: slate500,
        height: 1.65,
      );

  static TextStyle get bodySM => GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: slate500,
        height: 1.6,
      );

  static TextStyle get labelTag => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: blue600,
      );

  // ─── Border Radius ───
  static const double radiusSM = 4.0;
  static const double radiusMD = 8.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;

  // ─── Spacing ───
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 40.0;
  static const double space2XL = 64.0;
  static const double space3XL = 96.0;

  // ─── ThemeData ───
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: bgApp,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: bgCard,
        error: statusError,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: headingXL,
        displayMedium: headingLG,
        headlineMedium: headingMD,
        titleLarge: headingSM,
        bodyLarge: bodyLG,
        bodyMedium: bodyMD,
        bodySmall: bodySM,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bgCard,
        foregroundColor: primary,
        elevation: 0,
        scrolledUnderElevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
      ),
      cardTheme: CardThemeData(
        color: bgCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLG),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.02)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          side: const BorderSide(color: primary, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: bgCard,
        selectedItemColor: primary,
        unselectedItemColor: slate400,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
