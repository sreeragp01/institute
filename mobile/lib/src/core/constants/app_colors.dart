import 'package:flutter/material.dart';

/// SMEC Connect Design System - HSL Tokens & Color Palette
class AppColors {
  AppColors._();

  // Core Brand Palette (Clean Academic Light - Coursera/MasterClass Inspired)
  static const Color primaryNavy = Color(0xFF1E3A8A); // Deep Royal Navy
  static const Color accentGold = Color(0xFFD97706); // Warm Goldenrod Amber
  static const Color techBlue = Color(0xFF2563EB); // Vivid Royal Indigo
  static const Color primaryBlue = Color(0xFF1E3A8A); // Deep Navy
  static const Color cyberCyan = Color(0xFF0284C7); // Sky Tech Blue
  static const Color emeraldGreen = Color(0xFF16A34A); // Success Green
  static const Color amberGold = Color(0xFFD97706); // Warm Amber
  static const Color coralRed = Color(0xFFDC2626); // Alert Red
  static const Color electricPurple = Color(0xFF7C3AED); // Electric Purple

  // Surface & Light Backgrounds
  static const Color darkBackground = Color(0xFFF8FAFC); // Clean Platinum Light
  static const Color darkSurface = Color(0xFFFFFFFF); // Pure White Surface
  static const Color darkCardSurface = Color(0xFFFFFFFF); // Pure White Cards
  static const Color slateMuted = Color(0xFF64748B); // Slate Gray
  static const Color glassSurface = Color(0xFFFFFFFF); // Pure White Surface
  static const Color glassBorder = Color(0xFFE2E8F0); // Subtle Border
  static const Color glassBorderActive = Color(0xFF2563EB); // Glowing Blue Border

  // Text Colors (High Contrast Legibility)
  static const Color textPrimary = Color(0xFF0F172A); // Deep Slate Black
  static const Color textSecondary = Color(0xFF475569); // Slate Subtitle
  static const Color textMuted = Color(0xFF64748B); // Cool Muted Slate
  static const Color textDark = Color(0xFF0F172A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryNavy, techBlue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient aiGradient = LinearGradient(
    colors: [primaryNavy, cyberCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkMeshGradient = LinearGradient(
    colors: [
      Color(0xFFF8FAFC),
      Color(0xFFF1F5F9),
      Color(0xFFE2E8F0),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
