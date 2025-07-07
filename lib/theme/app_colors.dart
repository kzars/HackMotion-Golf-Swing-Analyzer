import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF8B5CF6);

  // Chart Colors
  static const Color chartPrimary = Color(0xFF6366F1);
  static const Color chartSecondary = Color(0xFFFF6B6B);
  static const Color chartSecondaryDark = Color(0xFFFF5252);

  // Text Colors
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;

  // Border & Divider Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color disabled = Color(0xFFE5E7EB);

  // Status Colors
  static const Color error = Colors.red;
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient chartPrimaryGradient = LinearGradient(
    colors: [chartPrimary, primaryDark],
  );

  static const LinearGradient chartSecondaryGradient = LinearGradient(
    colors: [chartSecondary, chartSecondaryDark],
  );

  // Shadow Colors
  static Color shadowLight = Colors.black.withValues(alpha: 0.08);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.1);

  // Chart Area Colors (with alpha)
  static Color chartPrimaryArea = primary.withValues(alpha: 0.1);
  static Color chartPrimaryAreaLight = primaryDark.withValues(alpha: 0.05);
  static Color interactiveHighlight = primary.withValues(alpha: 0.1);
}
