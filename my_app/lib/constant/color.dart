import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4A628A);
  static const Color secondary = Color(0xFF7AB2D3);
  static const Color accent = Color(0xFFB9E5E8);
  static const Color background = Color(0xFFDFF2EB);

  // Additional colors
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFEAEAEA);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF3D5277)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, Color(0xFF5D9AC5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
