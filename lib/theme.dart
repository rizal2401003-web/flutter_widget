import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const primary = Color(0xFF5B21B6);
  static const background = Color(0xFF4C1D95);
  static const card = Color(0xFF5B21B6);
  static const navigationBar = Color(0xFF3B147A);
  static const border = Colors.white24;
  static const mutedText = Colors.white70;
  static const catalogBackground = Color(0xFFF6F6F9);
}

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.navigationBar,
      indicatorColor: AppColors.border,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? Colors.white
              : AppColors.mutedText,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.bold
              : FontWeight.normal,
          color: states.contains(WidgetState.selected)
              ? Colors.white
              : AppColors.mutedText,
        ),
      ),
    ),
  );
}
