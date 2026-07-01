import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';

class AiMealPlanScreen extends StatelessWidget {
  const AiMealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('AI Meal Plan',
            style: AppTypography.titleLargeDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu_rounded,
                size: 48,
                color: isDark ? AppColors.gray600 : AppColors.gray400),
            const SizedBox(height: AppConstants.spacingMd),
            Text('Personalized meal plan coming soon',
                style: AppTypography.bodyMediumDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                )),
          ],
        ),
      ),
    );
  }
}
