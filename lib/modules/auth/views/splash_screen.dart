import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/auth_controller.dart';

/// Splash screen shown while checking auth state
class SplashScreen extends GetView<AuthController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? AppColors.white : AppColors.black,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusXl),
              ),
              child: Icon(
                Icons.fitness_center_rounded,
                size: 40,
                color: isDark ? AppColors.black : AppColors.white,
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: const Duration(milliseconds: 400)),

            const SizedBox(height: AppConstants.spacingXl),

            // App Name
            Text(
              AppConstants.appName,
              style: AppTypography.headlineLargeDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                letterSpacing: -1,
              ),
            )
                .animate(delay: const Duration(milliseconds: 200))
                .fadeIn(duration: const Duration(milliseconds: 500))
                .slideY(
                  begin: 0.3,
                  end: 0,
                  duration: const Duration(milliseconds: 500),
                ),

            const SizedBox(height: AppConstants.spacingSm),

            Text(
              'Your AI Fitness Coach',
              style: AppTypography.bodyMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            )
                .animate(delay: const Duration(milliseconds: 400))
                .fadeIn(duration: const Duration(milliseconds: 500)),

            const SizedBox(height: AppConstants.spacingXxl * 2),

            // Loading indicator
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppColors.gray400 : AppColors.gray500,
                ),
              ),
            )
                .animate(delay: const Duration(milliseconds: 600))
                .fadeIn(duration: const Duration(milliseconds: 400)),
          ],
        ),
      ),
    );
  }
}
