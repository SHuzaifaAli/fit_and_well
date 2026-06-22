import 'package:flutter/material.dart';

/// Monochromatic Color System for FitAI Coach
/// Primary palette: Deep Black → Pure White with strategic accent grays
class AppColors {
  AppColors._();

  // ─── Core Monochromatic Palette ───────────────────────────────────────────
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Grayscale Scale (Dark → Light)
  static const Color gray950 = Color(0xFF0A0A0A);
  static const Color gray900 = Color(0xFF111111);
  static const Color gray850 = Color(0xFF1A1A1A);
  static const Color gray800 = Color(0xFF222222);
  static const Color gray750 = Color(0xFF2A2A2A);
  static const Color gray700 = Color(0xFF333333);
  static const Color gray650 = Color(0xFF3D3D3D);
  static const Color gray600 = Color(0xFF444444);
  static const Color gray550 = Color(0xFF555555);
  static const Color gray500 = Color(0xFF666666);
  static const Color gray450 = Color(0xFF777777);
  static const Color gray400 = Color(0xFF888888);
  static const Color gray350 = Color(0xFF999999);
  static const Color gray300 = Color(0xFFAAAAAA);
  static const Color gray250 = Color(0xFFBBBBBB);
  static const Color gray200 = Color(0xFFCCCCCC);
  static const Color gray150 = Color(0xFFDDDDDD);
  static const Color gray100 = Color(0xFFEEEEEE);
  static const Color gray50 = Color(0xFFF5F5F5);
  static const Color gray25 = Color(0xFFFAFAFA);

  // ─── Semantic Colors ──────────────────────────────────────────────────────
  // Success (Monochromatic green-gray)
  static const Color success = Color(0xFF2D4A2D);
  static const Color successLight = Color(0xFF4A7A4A);
  static const Color successSurface = Color(0xFFE8F0E8);

  // Error (Monochromatic red-gray)
  static const Color error = Color(0xFF4A1A1A);
  static const Color errorLight = Color(0xFF8B3333);
  static const Color errorSurface = Color(0xFFF5E8E8);

  // Warning (Monochromatic amber-gray)
  static const Color warning = Color(0xFF4A3A1A);
  static const Color warningLight = Color(0xFF8B6633);
  static const Color warningSurface = Color(0xFFF5F0E8);

  // Info (Monochromatic blue-gray)
  static const Color info = Color(0xFF1A2A4A);
  static const Color infoLight = Color(0xFF334D8B);
  static const Color infoSurface = Color(0xFFE8ECF5);

  // ─── Dark Theme Colors ────────────────────────────────────────────────────
  static const Color darkBackground = gray950;
  static const Color darkSurface = gray900;
  static const Color darkSurfaceVariant = gray850;
  static const Color darkCard = gray800;
  static const Color darkCardElevated = gray750;
  static const Color darkBorder = gray700;
  static const Color darkBorderSubtle = gray650;
  static const Color darkDivider = gray600;
  static const Color darkTextPrimary = white;
  static const Color darkTextSecondary = gray300;
  static const Color darkTextTertiary = gray500;
  static const Color darkTextDisabled = gray600;
  static const Color darkIcon = gray200;
  static const Color darkIconSecondary = gray400;
  static const Color darkPrimary = white;
  static const Color darkPrimaryVariant = gray150;
  static const Color darkOnPrimary = black;
  static const Color darkAccent = gray200;
  static const Color darkOverlay = Color(0x80000000);
  static const Color darkShimmerBase = gray800;
  static const Color darkShimmerHighlight = gray700;

  // ─── Light Theme Colors ───────────────────────────────────────────────────
  static const Color lightBackground = white;
  static const Color lightSurface = gray25;
  static const Color lightSurfaceVariant = gray50;
  static const Color lightCard = white;
  static const Color lightCardElevated = gray25;
  static const Color lightBorder = gray150;
  static const Color lightBorderSubtle = gray100;
  static const Color lightDivider = gray100;
  static const Color lightTextPrimary = gray900;
  static const Color lightTextSecondary = gray600;
  static const Color lightTextTertiary = gray400;
  static const Color lightTextDisabled = gray300;
  static const Color lightIcon = gray700;
  static const Color lightIconSecondary = gray400;
  static const Color lightPrimary = black;
  static const Color lightPrimaryVariant = gray900;
  static const Color lightOnPrimary = white;
  static const Color lightAccent = gray700;
  static const Color lightOverlay = Color(0x40000000);
  static const Color lightShimmerBase = gray100;
  static const Color lightShimmerHighlight = gray50;

  // ─── Gradient Definitions ─────────────────────────────────────────────────
  static const LinearGradient darkHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gray900, gray950, black],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient lightHeroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, gray50, gray100],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient cardGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gray800, gray850],
  );

  static const LinearGradient cardGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, gray25],
  );

  static const LinearGradient progressGradientDark = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gray300, white],
  );

  static const LinearGradient progressGradientLight = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gray700, black],
  );

  // ─── Transparent Variants ─────────────────────────────────────────────────
  static Color blackWithOpacity(double opacity) =>
      black.withOpacity(opacity);
  static Color whiteWithOpacity(double opacity) =>
      white.withOpacity(opacity);
  static Color gray900WithOpacity(double opacity) =>
      gray900.withOpacity(opacity);
}
