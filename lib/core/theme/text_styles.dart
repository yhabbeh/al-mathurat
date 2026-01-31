import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  static const TextStyle header = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    fontFamily: 'Inter', // Placeholder if not available
  );

  static const TextStyle subHeader = TextStyle(
    fontSize: 18,
    color: AppColors.primaryText,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle arabicTitle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
    height: 1.2,
  );

  static const TextStyle arabicSubtitle = TextStyle(
    fontSize: 20,
    color: Color(0xFF6B7280), // Grayish
    height: 1.4,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
