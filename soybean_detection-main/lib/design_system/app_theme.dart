import 'package:flutter/material.dart';
import 'package:soybean_detection/utils/color_extensions.dart';

class AppColors {
  // Brand colors
  static const Color primary = Color(0xFF2E8B57); // Forest Green
  static const Color secondary = Color(0xFFFFC107); // Amber
  static const Color tertiary = Color(0xFF6B8E23); // Olive Drab

  // Neutrals
  static const Color background = Color(0xFFF9FAF7);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF0F4F0);

  // Text colors
  static const Color textDark = Color(0xFF1E2819);
  static const Color textMedium = Color(0xFF4D5A46);
  static const Color textLight = Color(0xFF78846D);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF42A5F5);
}

class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppShadows {
  static final List<BoxShadow> sm = [
    BoxShadow(
      color: Colors.black.withOpacitySafe(0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static final List<BoxShadow> md = [
    BoxShadow(
      color: Colors.black.withOpacitySafe(0.07),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> lg = [
    BoxShadow(
      color: Colors.black.withOpacitySafe(0.1),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'Outfit',
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        // Fix deprecated background/onBackground
        surface: AppColors.background,
        // background: AppColors.background, - removed
        surfaceTint: AppColors.background,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: AppColors.textDark,
        // onBackground: AppColors.textDark, - removed
        onSurface: AppColors.textDark,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    return baseTheme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        color: AppColors.cardBackground,
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.md,
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 57,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 45,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 36,
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 32,
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 28,
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 24,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 22,
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Outfit',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
