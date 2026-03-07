import 'package:flutter/material.dart';

/// App color palette inspired by Bitcoin branding
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color bitcoinOrange = Color(0xFFF7931A);
  static const Color bitcoinOrangeLight = Color(0xFFFFB84D);
  static const Color bitcoinOrangeDark = Color(0xFFCC7700);

  // Background Colors
  static const Color darkBlue = Color(0xFF0F172A);
  static const Color darkBlueLight = Color(0xFF1E293B);
  static const Color gray = Color(0xFF1E293B);
  static const Color grayLight = Color(0xFF334155);
  static const Color grayDark = Color(0xFF0F172A);

  // Lightning Network
  static const Color lightningPurple = Color(0xFF9333EA);
  static const Color lightningPurpleLight = Color(0xFFA855F7);
  static const Color lightningPurpleDark = Color(0xFF7C3AED);

  // Accent Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textDark = Color(0xFF0F172A);

  // Gradient Definitions
  static const LinearGradient bitcoinGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bitcoinOrange, bitcoinOrangeDark],
  );

  static const LinearGradient lightningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightningPurpleLight, lightningPurpleDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkBlue, grayDark],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, successLight],
  );

  // Mission-specific colors
  static const List<Color> missionColors = [
    bitcoinOrange,
    lightningPurple,
    info,
    success,
    warning,
  ];

  /// Get a color for a mission based on its index
  static Color getMissionColor(int index) {
    return missionColors[index % missionColors.length];
  }
}
