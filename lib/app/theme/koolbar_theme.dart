import 'package:flutter/material.dart';
import 'package:koolbar_demo/design_system/colors.dart';

/// Shared colors and component styling for the dark ride-booking experience.

abstract final class KoolbarTheme {
  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: KoolbarColors.primary,
      brightness: Brightness.dark,
      surface: KoolbarColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme.copyWith(
        primary: KoolbarColors.primary,
        secondary: KoolbarColors.cyan,
        surface: KoolbarColors.surface,
        onSurface: KoolbarColors.textPrimary,
      ),
      scaffoldBackgroundColor: KoolbarColors.background,
      dividerColor: KoolbarColors.border,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: KoolbarColors.textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
        ),
        titleLarge: TextStyle(
          color: KoolbarColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: KoolbarColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: KoolbarColors.textPrimary),
        bodyMedium: TextStyle(color: KoolbarColors.textSecondary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: KoolbarColors.surface,
        hintStyle: const TextStyle(color: KoolbarColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: KoolbarColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: KoolbarColors.border),
        ),
      ),
    );
  }
}
