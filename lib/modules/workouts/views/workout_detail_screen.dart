import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_button.dart';
import '../controllers/workout_controller.dart';

class WorkoutDetailScreen extends GetView<WorkoutController> {
  const WorkoutDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final workout = Get.arguments ?? controller.selectedWorkout.value;

    if (workout == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor:
                isDark ? AppColors.darkBackground : AppColors.lightBackground,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.gray800.withOpacity(0.8)
                      : AppColors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 16,
                  color: isDark ? AppColors.white : AppColors.black,
                ),
              ),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: isDark ? AppColors.gray800 : AppColors.gray200,
                child: Icon(
                  Icons.fitness_center_rounded,
                  size: 80,
                  color: isDark ? AppColors.gray600 : AppColors.gray400,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingXl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title & Tags ───────────────────────────────────────
                  Text(
                    workout.title,
                    style: AppTypography.headlineSmallDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ).animate().fadeIn(),

                  const SizedBox(height: AppConstants.spacingMd),

                  // ── Stats Row ──────────────────────────────────────────
                  Row(
                    children: [
                      _StatChip(
                          icon: Icons.speed_rounded,
                          label: workout.difficulty,
                          isDark: isDark),
                      const SizedBox(width: AppConstants.spacingSm),
                      _StatChip(
                          icon: Icons.timer_outlined,
                          label: '${workout.durationMinutes} min',
                          isDark: isDark),
                      const SizedBox(width: AppConstants.spacingSm),
                      _StatChip(
                          icon: Icons.local_fire_department_outlined,
                          label: '${workout.caloriesBurned} kcal',
                          isDark: isDark),
                    ],
                  ).animate(delay: 50.ms).fadeIn(),

                  if (workout.description != null) ...[
                    const SizedBox(height: AppConstants.spacingXl),
                    Text(
                      'About',
                      style: AppTypography.titleMediumDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    Text(
                      workout.description!,
                      style: AppTypography.bodyMediumDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],

                  const SizedBox(height: AppConstants.spacingXl),

                  // ── Exercise List ──────────────────────────────────────
                  Text(
                    'Exercises (${workout.exercises.length})',
                    style: AppTypography.titleMediumDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMd),

                  ...workout.exercises.asMap().entries.map((entry) {
                    final i = entry.key;
                    final ex = entry.value;
                    return _ExerciseListItem(
                      index: i + 1,
                      exercise: ex,
                      isDark: isDark,
                    )
                        .animate(
                            delay: Duration(milliseconds: 100 + (i as int) * 50))
                        .fadeIn()
                        .slideY(begin: 0.05, end: 0);
                  }),

                  const SizedBox(height: AppConstants.spacingXxl),

                  // ── Start Button ───────────────────────────────────────
                  AppButton(
                    label: 'Start Workout',
                    onPressed: () {
                      controller.startWorkout(workout);
                      Get.toNamed(AppRoutes.activeWorkout);
                    },
                    prefixIcon: Icons.play_arrow_rounded,
                  ).animate(delay: 300.ms).fadeIn(),

                  const SizedBox(height: AppConstants.spacingXl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _StatChip(
      {required this.icon, required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray800 : AppColors.gray100,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 14,
              color: isDark ? AppColors.gray400 : AppColors.gray600),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.labelSmallDark.copyWith(
              color:
                  isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseListItem extends StatelessWidget {
  final int index;
  final exercise;
  final bool isDark;

  const _ExerciseListItem(
      {required this.index, required this.exercise, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark ? AppColors.gray700 : AppColors.gray200,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$index',
                style: AppTypography.labelMediumDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: AppTypography.titleSmallDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                if (exercise.muscleGroup != null)
                  Text(
                    exercise.muscleGroup!,
                    style: AppTypography.bodySmallDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${exercise.sets} × ${exercise.reps}',
                style: AppTypography.labelMediumDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                'Rest ${exercise.restTimeSeconds}s',
                style: AppTypography.bodySmallDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
