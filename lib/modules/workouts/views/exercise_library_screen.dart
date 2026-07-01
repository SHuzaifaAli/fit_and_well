import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../controllers/workout_controller.dart';

class ExerciseLibraryScreen extends GetView<WorkoutController> {
  const ExerciseLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Exercise Library',
          style: AppTypography.titleLargeDark.copyWith(
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
            Obx(() {
              if (controller.allWorkouts.isEmpty) {
                return Center(
                  child: Text(
                    'No exercises available',
                    style: AppTypography.bodyMediumDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                );
              }

              return Column(
                children: controller.allWorkouts
                    .expand((w) => w.exercises)
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                  final i = entry.key;
                  final exercise = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(
                        bottom: AppConstants.spacingMd),
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMd),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style:
                              AppTypography.titleSmallDark.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        if (exercise.muscleGroup != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            exercise.muscleGroup!,
                            style: AppTypography.bodySmallDark
                                .copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                        if (exercise.instructions != null) ...[
                          const SizedBox(
                              height: AppConstants.spacingSm),
                          Text(
                            exercise.instructions!,
                            style: AppTypography.bodySmallDark
                                .copyWith(
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                      .animate(delay: Duration(
                          milliseconds: 100 + i * 50))
                      .fadeIn()
                      .slideY(begin: 0.05, end: 0);
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
