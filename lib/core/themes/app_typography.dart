import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography System for FitAI Coach
/// Uses Inter font family for clean, modern SaaS aesthetic
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  // ─── Font Sizes ───────────────────────────────────────────────────────────
  static const double fontSize2xs = 10.0;
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeMd = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSize2xl = 24.0;
  static const double fontSize3xl = 28.0;
  static const double fontSize4xl = 32.0;
  static const double fontSize5xl = 40.0;
  static const double fontSize6xl = 48.0;

  // ─── Font Weights ─────────────────────────────────────────────────────────
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;

  // ─── Line Heights ─────────────────────────────────────────────────────────
  static const double lineHeightTight = 1.2;
  static const double lineHeightSnug = 1.35;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.65;
  static const double lineHeightLoose = 2.0;

  // ─── Letter Spacing ───────────────────────────────────────────────────────
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;
  static const double letterSpacingWider = 1.0;
  static const double letterSpacingWidest = 1.5;

  // ─── Text Styles (Dark Theme) ─────────────────────────────────────────────
  static TextStyle displayLargeDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize6xl,
    fontWeight: weightExtraBold,
    color: AppColors.darkTextPrimary,
    letterSpacing: letterSpacingTight,
    height: lineHeightTight,
  );

  static TextStyle displayMediumDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize5xl,
    fontWeight: weightBold,
    color: AppColors.darkTextPrimary,
    letterSpacing: letterSpacingTight,
    height: lineHeightTight,
  );

  static TextStyle displaySmallDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize4xl,
    fontWeight: weightBold,
    color: AppColors.darkTextPrimary,
    letterSpacing: letterSpacingTight,
    height: lineHeightSnug,
  );

  static TextStyle headlineLargeDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize3xl,
    fontWeight: weightBold,
    color: AppColors.darkTextPrimary,
    letterSpacing: letterSpacingNormal,
    height: lineHeightSnug,
  );

  static TextStyle headlineMediumDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize2xl,
    fontWeight: weightSemiBold,
    color: AppColors.darkTextPrimary,
    letterSpacing: letterSpacingNormal,
    height: lineHeightSnug,
  );

  static TextStyle headlineSmallDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXl,
    fontWeight: weightSemiBold,
    color: AppColors.darkTextPrimary,
    letterSpacing: letterSpacingNormal,
    height: lineHeightNormal,
  );

  static TextStyle titleLargeDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeLg,
    fontWeight: weightSemiBold,
    color: AppColors.darkTextPrimary,
    letterSpacing: letterSpacingNormal,
    height: lineHeightNormal,
  );

  static TextStyle titleMediumDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeMd,
    fontWeight: weightSemiBold,
    color: AppColors.darkTextPrimary,
    letterSpacing: letterSpacingNormal,
    height: lineHeightNormal,
  );

  static TextStyle titleSmallDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: weightMedium,
    color: AppColors.darkTextPrimary,
    letterSpacing: letterSpacingNormal,
    height: lineHeightNormal,
  );

  static TextStyle bodyLargeDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeMd,
    fontWeight: weightRegular,
    color: AppColors.darkTextSecondary,
    letterSpacing: letterSpacingNormal,
    height: lineHeightRelaxed,
  );

  static TextStyle bodyMediumDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: weightRegular,
    color: AppColors.darkTextSecondary,
    letterSpacing: letterSpacingNormal,
    height: lineHeightRelaxed,
  );

  static TextStyle bodySmallDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight: weightRegular,
    color: AppColors.darkTextTertiary,
    letterSpacing: letterSpacingNormal,
    height: lineHeightRelaxed,
  );

  static TextStyle labelLargeDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeSm,
    fontWeight: weightMedium,
    color: AppColors.darkTextPrimary,
    letterSpacing: letterSpacingWide,
    height: lineHeightNormal,
  );

  static TextStyle labelMediumDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizeXs,
    fontWeight: weightMedium,
    color: AppColors.darkTextSecondary,
    letterSpacing: letterSpacingWide,
    height: lineHeightNormal,
  );

  static TextStyle labelSmallDark = const TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize2xs,
    fontWeight: weightMedium,
    color: AppColors.darkTextTertiary,
    letterSpacing: letterSpacingWider,
    height: lineHeightNormal,
  );

  // ─── Text Styles (Light Theme) ────────────────────────────────────────────
  static TextStyle displayLargeLight = displayLargeDark.copyWith(
    color: AppColors.lightTextPrimary,
  );
  static TextStyle displayMediumLight = displayMediumDark.copyWith(
    color: AppColors.lightTextPrimary,
  );
  static TextStyle displaySmallLight = displaySmallDark.copyWith(
    color: AppColors.lightTextPrimary,
  );
  static TextStyle headlineLargeLight = headlineLargeDark.copyWith(
    color: AppColors.lightTextPrimary,
  );
  static TextStyle headlineMediumLight = headlineMediumDark.copyWith(
    color: AppColors.lightTextPrimary,
  );
  static TextStyle headlineSmallLight = headlineSmallDark.copyWith(
    color: AppColors.lightTextPrimary,
  );
  static TextStyle titleLargeLight = titleLargeDark.copyWith(
    color: AppColors.lightTextPrimary,
  );
  static TextStyle titleMediumLight = titleMediumDark.copyWith(
    color: AppColors.lightTextPrimary,
  );
  static TextStyle titleSmallLight = titleSmallDark.copyWith(
    color: AppColors.lightTextPrimary,
  );
  static TextStyle bodyLargeLight = bodyLargeDark.copyWith(
    color: AppColors.lightTextSecondary,
  );
  static TextStyle bodyMediumLight = bodyMediumDark.copyWith(
    color: AppColors.lightTextSecondary,
  );
  static TextStyle bodySmallLight = bodySmallDark.copyWith(
    color: AppColors.lightTextTertiary,
  );
  static TextStyle labelLargeLight = labelLargeDark.copyWith(
    color: AppColors.lightTextPrimary,
  );
  static TextStyle labelMediumLight = labelMediumDark.copyWith(
    color: AppColors.lightTextSecondary,
  );
  static TextStyle labelSmallLight = labelSmallDark.copyWith(
    color: AppColors.lightTextTertiary,
  );

  // ─── Text Theme Builders ──────────────────────────────────────────────────
  static TextTheme darkTextTheme = TextTheme(
    displayLarge: displayLargeDark,
    displayMedium: displayMediumDark,
    displaySmall: displaySmallDark,
    headlineLarge: headlineLargeDark,
    headlineMedium: headlineMediumDark,
    headlineSmall: headlineSmallDark,
    titleLarge: titleLargeDark,
    titleMedium: titleMediumDark,
    titleSmall: titleSmallDark,
    bodyLarge: bodyLargeDark,
    bodyMedium: bodyMediumDark,
    bodySmall: bodySmallDark,
    labelLarge: labelLargeDark,
    labelMedium: labelMediumDark,
    labelSmall: labelSmallDark,
  );

  static TextTheme lightTextTheme = TextTheme(
    displayLarge: displayLargeLight,
    displayMedium: displayMediumLight,
    displaySmall: displaySmallLight,
    headlineLarge: headlineLargeLight,
    headlineMedium: headlineMediumLight,
    headlineSmall: headlineSmallLight,
    titleLarge: titleLargeLight,
    titleMedium: titleMediumLight,
    titleSmall: titleSmallLight,
    bodyLarge: bodyLargeLight,
    bodyMedium: bodyMediumLight,
    bodySmall: bodySmallLight,
    labelLarge: labelLargeLight,
    labelMedium: labelMediumLight,
    labelSmall: labelSmallLight,
  );
}
