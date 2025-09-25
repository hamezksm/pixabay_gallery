import 'package:flutter/material.dart';

// App Color Palette
class AppColors {
  // Primary Colors
  static const Color primaryLight = Color(0xFF6366F1); // Indigo
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryContainer = Color(0xFFEEF2FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF312E81);

  // Secondary Colors
  static const Color secondaryLight = Color(0xFF8B5CF6); // Purple
  static const Color secondaryDark = Color(0xFF7C3AED);
  static const Color secondaryContainer = Color(0xFFF3E8FF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF581C87);

  // Tertiary Colors
  static const Color tertiaryLight = Color(0xFF06B6D4); // Cyan
  static const Color tertiaryDark = Color(0xFF0891B2);
  static const Color tertiaryContainer = Color(0xFFE0F7FA);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF164E63);

  // Error Colors
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF991B1B);

  // Success Colors
  static const Color successLight = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static const Color successContainer = Color(0xFFD1FAE5);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color onSuccessContainer = Color(0xFF064E3B);

  // Warning Colors
  static const Color warningLight = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFD97706);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color onWarning = Color(0xFFFFFFFF);
  static const Color onWarningContainer = Color(0xFF92400E);

  // Neutral Colors - Light Theme
  static const Color backgroundLight = Color(0xFFFFFBFE);
  static const Color surfaceLight = Color(0xFFFFFBFE);
  static const Color surfaceVariantLight = Color(0xFFE7E0EC);
  static const Color outlineLight = Color(0xFF79747E);
  static const Color onBackgroundLight = Color(0xFF1C1B1F);
  static const Color onSurfaceLight = Color(0xFF1C1B1F);
  static const Color onSurfaceVariantLight = Color(0xFF49454F);

  // Neutral Colors - Dark Theme
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceVariantDark = Color(0xFF2C2C2C);
  static const Color outlineDark = Color(0xFF938F94);
  static const Color onBackgroundDark = Color(0xFFE6E1E5);
  static const Color onSurfaceDark = Color(0xFFE6E1E5);
  static const Color onSurfaceVariantDark = Color(0xFFCAC4D0);

  // Gradient Colors
  static const List<Color> primaryGradient = [primaryLight, secondaryLight];
  static const List<Color> backgroundGradient = [
    Color(0xFFF8FAFC),
    Color(0xFFF1F5F9),
  ];
  static const List<Color> darkBackgroundGradient = [
    Color(0xFF0F172A),
    Color(0xFF1E293B),
  ];

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x4D000000);

  // Overlay Colors
  static const Color overlayLight = Color(0x66000000);
  static const Color overlayDark = Color(0x80000000);

  // Card Colors
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2C2C2C);

  // Input Colors
  static const Color inputFillLight = Color(0xFFF8F9FA);
  static const Color inputFillDark = Color(0xFF2C2C2C);
  static const Color inputBorderLight = Color(0xFFE5E7EB);
  static const Color inputBorderDark = Color(0xFF4B5563);

  // Divider Colors
  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);

  // Hover Effects
  static const Color hoverLight = Color(0x0D000000);
  static const Color hoverDark = Color(0x1AFFFFFF);

  // Focus Colors
  static const Color focusLight = primaryLight;
  static const Color focusDark = primaryDark;

  // Disabled Colors
  static const Color disabledLight = Color(0x61000000);
  static const Color disabledDark = Color(0x61FFFFFF);
}

// Extension for easier color access
extension AppColorsExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get primaryColor =>
      isDarkMode ? AppColors.primaryDark : AppColors.primaryLight;
  Color get backgroundColor =>
      isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
  Color get surfaceColor =>
      isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight;
  Color get onSurfaceColor =>
      isDarkMode ? AppColors.onSurfaceDark : AppColors.onSurfaceLight;
  Color get cardColor => isDarkMode ? AppColors.cardDark : AppColors.cardLight;
  Color get shadowColor =>
      isDarkMode ? AppColors.shadowDark : AppColors.shadowLight;
}
