import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.unselected,
      secondary: AppColors.primaryDark,
      onSecondary: AppColors.unselected,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      error: AppColors.errorText,
      onError: AppColors.detail,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppTextStyles.family,
      splashFactory: NoSplash.splashFactory,
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.display,
        headlineMedium: AppTextStyles.title,
        titleLarge: AppTextStyles.heading,
        labelLarge: AppTextStyles.button,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.unselected,
        selectionColor: Color(0x66C60031),
      ),
    );
  }
}
