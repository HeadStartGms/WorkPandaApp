import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Pure Professional B&W Palette
  static const Color black = Color(0xFF000000);
  static const Color pitchBlack = Color(0xFF111111);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF9F9F9);
  static const Color silver = Color(0xFFE5E5E5);
  static const Color charcoal = Color(0xFF2D2D2D);
  static const Color slate = Color(0xFF6B6B6B);
}

class AppTextStyles {
  AppTextStyles._();

  static final TextStyle displayLarge = GoogleFonts.outfit(
    fontSize: 40,
    fontWeight: FontWeight.w900,
    color: AppColors.black,
    height: 1.1,
    letterSpacing: -1.0,
  );

  static final TextStyle headingLarge = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.black,
  );

  static final TextStyle headingMedium = GoogleFonts.outfit(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  static final TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.6,
  );

  static final TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.charcoal,
  );

  static final TextStyle labelBold = GoogleFonts.outfit(
    fontSize: 12,
    fontWeight: FontWeight.w900,
    color: AppColors.black,
    letterSpacing: 2.0,
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.black,
      onPrimary: AppColors.white,
      secondary: AppColors.charcoal,
      surface: AppColors.white,
    ),
    fontFamily: GoogleFonts.outfit().fontFamily,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.black),
      titleTextStyle:
          TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.silver,
      thickness: 1,
    ),
  );
}
