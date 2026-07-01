import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../widgets/app_button.dart';
import '../controllers/onboarding_controller.dart';

/// Goal setup screen — fitness goal + activity level
class GoalSetupScreen extends GetView<OnboardingController> {
  const GoalSetupScreen({super.key});

  static const _goals = [
    (AppConstants.goalWeightLoss, 'Lose Weight', Icons.trending_down_rounded,
        'Burn fat and get leaner'),
    (AppConstants.goalMuscleGain, 'Build Muscle', Icons.fitness_center_rounded,
        'Gain strength and size'),
    (AppConstants.goalMaintenance, 'Maintain Weight', Icons.balance_rounded,
        'Stay at current weight'),
    (AppConstants.goalGeneralFitness, 'General Fitness',
        Icons.directions_run_rounded, 'Improve overall health'),
  ];

  static final _activityLevels = [
    (AppConstants.activitySedentary, 'Sedentary', 'Little or no exercise'),
    (AppConstants.activityLightlyActive, 'Light', 'Exercise 1-3 days/week'),
    (AppConstants.activityModeratelyActive, 'Moderate', 'Exercise 3-5 days/week'),
    (AppConstants.activityVeryActive, 'Active', 'Exercise 6-7 days/week'),
    (AppConstants.activityExtraActive, 'Extra Active', 'Hard exercise daily'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Your Goals',
          style: AppTypography.titleMediumDark.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What\'s your goal?',
              style: AppTypography.headlineMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ).animate().fadeIn(),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Choose your primary fitness goal.',
              style: AppTypography.bodyMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ).animate(delay: 80.ms).fadeIn(),
            const SizedBox(height: AppConstants.spacingXl),

            // Goal cards
            Obx(() => Column(
                  children: _goals.asMap().entries.map((entry) {
                    final i = entry.key;
                    final goal = entry.value;
                    final isSelected =
                        controller.selectedGoal.value == goal.$1;
                    return GestureDetector(
                      onTap: () => controller.selectGoal(goal.$1),
                      child: AnimatedContainer(
                        duration: AppConstants.animFast,
                        margin: const EdgeInsets.only(
                            bottom: AppConstants.spacingMd),
                        padding: const EdgeInsets.all(AppConstants.spacingMd),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? AppColors.white : AppColors.black)
                              : (isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusLg),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              goal.$3,
                              size: 24,
                              color: isSelected
                                  ? (isDark ? AppColors.black : AppColors.white)
                                  : (isDark
                                      ? AppColors.darkIcon
                                      : AppColors.lightIcon),
                            ),
                            const SizedBox(width: AppConstants.spacingMd),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal.$2,
                                    style:
                                        AppTypography.titleSmallDark.copyWith(
                                      color: isSelected
                                          ? (isDark
                                              ? AppColors.black
                                              : AppColors.white)
                                          : (isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.lightTextPrimary),
                                    ),
                                  ),
                                  Text(
                                    goal.$4,
                                    style:
                                        AppTypography.bodySmallDark.copyWith(
                                      color: isSelected
                                          ? (isDark
                                              ? AppColors.gray600
                                              : AppColors.gray400)
                                          : (isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextSecondary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle_rounded,
                                size: 20,
                                color: isDark
                                    ? AppColors.black
                                    : AppColors.white,
                              ),
                          ],
                        ),
                      ),
                    )
                        .animate(
                            delay: Duration(milliseconds: 100 + i * 60))
                        .fadeIn()
                        .slideX(begin: 0.05, end: 0);
                  }).toList(),
                )),

            const SizedBox(height: AppConstants.spacingXl),

            Text(
              'Activity Level',
              style: AppTypography.titleMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ).animate(delay: 350.ms).fadeIn(),
            const SizedBox(height: AppConstants.spacingMd),

            Obx(() => Column(
                  children: _activityLevels.asMap().entries.map((entry) {
                    final i = entry.key;
                    final level = entry.value;
                    final isSelected =
                        controller.selectedActivityLevel.value == level.$1;
                    return GestureDetector(
                      onTap: () =>
                          controller.selectActivityLevel(level.$1),
                      child: AnimatedContainer(
                        duration: AppConstants.animFast,
                        margin: const EdgeInsets.only(
                            bottom: AppConstants.spacingSm),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingMd,
                          vertical: AppConstants.spacingMd,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? AppColors.white : AppColors.black)
                              : (isDark
                                  ? AppColors.darkSurface
                                  : AppColors.lightSurface),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMd),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    level.$2,
                                    style:
                                        AppTypography.labelMediumDark.copyWith(
                                      color: isSelected
                                          ? (isDark
                                              ? AppColors.black
                                              : AppColors.white)
                                          : (isDark
                                              ? AppColors.darkTextPrimary
                                              : AppColors.lightTextPrimary),
                                    ),
                                  ),
                                  Text(
                                    level.$3,
                                    style:
                                        AppTypography.bodySmallDark.copyWith(
                                      color: isSelected
                                          ? (isDark
                                              ? AppColors.gray600
                                              : AppColors.gray400)
                                          : (isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextSecondary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_rounded,
                                size: 18,
                                color: isDark
                                    ? AppColors.black
                                    : AppColors.white,
                              ),
                          ],
                        ),
                      ),
                    )
                        .animate(
                            delay: Duration(milliseconds: 400 + i * 50))
                        .fadeIn();
                  }).toList(),
                )),

            const SizedBox(height: AppConstants.spacingXxl),

            Obx(() => AppButton(
                  label: 'Complete Setup',
                  onPressed: controller.completeOnboarding,
                  isLoading: controller.isLoading.value,
                  suffixIcon: Icons.check_rounded,
                )).animate(delay: 600.ms).fadeIn(),

            const SizedBox(height: AppConstants.spacingXl),
          ],
        ),
      ),
    );
  }
}
