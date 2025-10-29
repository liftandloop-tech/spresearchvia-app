import 'package:flutter/material.dart';

/// Centralized color theme for the application
/// All colors used throughout the app are defined here
abstract class AppTheme {
  // Primary Colors
  static const Color primaryBlue = Color(0xff11416B);
  static const Color primaryBlueDark = Color(0xff163174);
  static const Color primaryGreen = Color(0xFF2C7F38);

  // Background Colors
  static const Color backgroundWhite = Colors.white;
  static const Color backgroundLightBlue = Color(0xffEFF6FF);

  // Text Colors
  static const Color textBlack = Colors.black;
  static const Color textWhite = Colors.white;
  static const Color textGrey = Color(0xff6B7280);
  static const Color textGreyLight = Color(0xff9CA3AF);

  // Border Colors
  static const Color borderGrey = Color(0xffE5E7EB);
  static const Color borderBlue = primaryBlue;

  // Status Colors
  static const Color success = Color(0xFF2C7F38);
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xff11416B);

  // Shadow Colors
  static Color shadowLight = Colors.black.withValues(alpha: 0.05);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.1);
  static Color shadowDark = Colors.black.withValues(alpha: 0.2);

  // Button Colors
  static const Color buttonGreen = primaryGreen;
  static const Color buttonBlue = primaryBlue;
  static Color buttonDisabled = Colors.grey.shade400;

  // Additional UI Colors
  static const Color iconGrey = Color(0xff9CA3AF);
  static const Color iconRed = Color(0xFFDC2626);
  static const Color dividerGrey = Color(0xffE5E7EB);
}
