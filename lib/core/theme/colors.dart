import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryText = Color(0xFF364153);
  static const Color orangeAction = Color(
    0xFFF59E0B,
  ); // Approximate from "Start your journey" button
  static const Color purpleIcon = Color(0xFF8B5CF6); // Approximate purple
  static const Color cardSurface = Colors.white;

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5F3FF), Color(0xFFFAF5FF), Color(0xFFFDF2F8)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF3F4F6), // Placeholder
      Color(0xFFFFFFFF),
    ],
  );
}
