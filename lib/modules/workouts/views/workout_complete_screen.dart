import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_button.dart';
import '../controllers/workout_controller.dart';

class WorkoutCompleteScreen extends GetView<WorkoutController> {
  const WorkoutCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final workout = Get.arguments;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Trophy icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.gray800 : AppColors.gray100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  size: 56,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              )
                  .animate()
                  .scale(duration: AppConstants.animMedium, curve: Curves.elasticOut)
                  .fadeIn(),

              const SizedBox(height: AppConstants.spacingXxl),

              Text(
                'Workout Complete!',
                style: AppTypography.headlineLargeDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 200.ms).fadeIn(),

              const SizedBox(height: AppConstants.spacingMd),

              Text(
                'Great job! You crushed your workout today.',
                style: AppTypography.bodyLargeDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 300.ms).fadeIn(),

              const SizedBox(height: AppConstants.spacingXxl),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                    label: 'Duration',
                    value: '${controller.elapsedSeconds.value ~/ 60}m',
                    icon: Icons.timer_outlined,
                    isDark: isDark,
                  ),
                  _StatItem(
                    label: 'Calories',
                    value: '${workout?.caloriesBurned ?? 0}',
                    icon: Icons.local_fire_department_outlined,
                    isDark: isDark,
                  ),
                  _StatItem(
                    label: 'Exercises',
                    value: '${controller.currentExercises.length}',
                    icon: Icons.fitness_center_outlined,
                    isDark: isDark,
                  ),
                ],
              ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1, end: 0),

              const SizedBox(height: AppConstants.spacingXxl),

              AppButton(
                label: 'Back to Home',
                onPressed: () => Get.offAllNamed(AppRoutes.dashboard),
                suffixIcon: Icons.home_rounded,
              ).animate(delay: 500.ms).fadeIn(),

              const SizedBox(height: AppConstants.spacingMd),

              OutlinedButton(
                onPressed: () => Get.offNamed(AppRoutes.workouts),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMd),
                  ),
                ),
                child: Text(
                  'More Workouts',
                  style: AppTypography.labelLargeDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ).animate(delay: 550.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isDark ? AppColors.gray800 : AppColors.gray100,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Icon(icon,
              size: 24,
              color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
        ),
        const SizedBox(height: AppConstants.spacingSm),
        Text(
          value,
          style: AppTypography.titleLargeDark.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        Text(
          label,
          style: AppTypography.bodySmallDark.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
