import 'package:flutter/material.dart';
import 'package:mood_swings_app/theme/app_colors.dart';
import 'package:mood_swings_app/theme/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static final TextTheme _textTheme = TextTheme(
    headlineLarge: AppTextStyles.heading,
    titleMedium: AppTextStyles.subhead,
    bodyMedium: AppTextStyles.body,
    bodySmall: AppTextStyles.caption,
  );

  static ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: _textTheme,
    cardTheme: CardThemeData(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.subhead.copyWith(
        color: Colors.black87,
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
    ),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: _textTheme,
    cardTheme: CardThemeData(
      elevation: 2,
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.surfaceDark,
      elevation: 8,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyles.subhead.copyWith(
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
  );
}
