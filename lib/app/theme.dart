import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_radius.dart';
import '../core/theme/app_text_styles.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: AppColors.background,

  textTheme: TextTheme(
    headlineLarge: AppTextStyles.title,
    headlineMedium: AppTextStyles.heading,
    bodyLarge: AppTextStyles.body,
    bodyMedium: AppTextStyles.body,
  ),

  appBarTheme: const AppBarTheme(
    centerTitle: false,
    elevation: 0,
    backgroundColor: Colors.transparent,
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
  ),

  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
  ),
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: AppColors.darkBackground,
);
