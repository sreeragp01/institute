import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography Scale: Outfit (Headings & Metrics) + Inter (Body, Forms, Tables)
class AppTypography {
  AppTypography._();

  static TextStyle displayHeader({Color color = AppColors.textPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle header1({Color color = AppColors.textPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.25,
        color: color,
      );

  static TextStyle header2({Color color = AppColors.textPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: color,
      );

  static TextStyle subtitle({Color color = AppColors.textPrimary}) =>
      GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
        color: color,
      );

  static TextStyle bodyLarge({Color color = AppColors.textSecondary}) =>
      GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.15,
        color: color,
      );

  static TextStyle bodyStandard({Color color = AppColors.textSecondary}) =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.2,
        color: color,
      );

  static TextStyle caption({Color color = AppColors.textMuted}) =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.4,
        color: color,
      );

  static TextStyle microTag({Color color = AppColors.textMuted}) =>
      GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.5,
        color: color,
      );
}
