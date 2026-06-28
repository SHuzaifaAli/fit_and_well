import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../widgets/app_button.dart';
import '../controllers/workout_controller.dart';

class ActiveWorkoutScreen extends GetView<WorkoutController> {
  const ActiveWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        final confirm = await _showExitDialog();
        return confirm ?? false;
      },
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.darkBackground : AppColors.lightBackground,
        body: Obx(() {
          final workout = controller.activeWorkout.value;
          if (workout == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: Column(
              children: [
                // ── Top Bar ──────────────────────────────────────────────
                _buildTopBar(isDark, workout),

                // ── Progress Bar ─────────────────────────────────────────
                _buildProgressBar(isDark),

                Expanded(
                  child: controller.isResting.value
                      ? _buildRestScreen(isDark)
                      : _buildExerciseScreen(isDark),
                ),

                // ── Bottom Controls ──────────────────────────────────────
                _buildBottomControls(isDark),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTopBar(bool isDark, workout) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.close_rounded,
                color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
            onPressed: () async {
              final confirm = await _showExitDialog();
              if (confirm == true) controller.cancelWorkout();
            },
          ),
          Expanded(
            child: Text(
              workout.title,
              style: AppTypography.titleMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.gray800 : AppColors.gray100,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: Obx(() => Text(
                  controller.formattedElapsedTime,
                  style: AppTypography.labelMediumDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(bool isDark) {
    return Obx(() => LinearProgressIndicator(
          value: controller.workoutProgress,
          backgroundColor:
              isDark ? AppColors.gray800 : AppColors.gray200,
          valueColor: AlwaysStoppedAnimation<Color>(
            isDark ? AppColors.white : AppColors.black,
          ),
          minHeight: 3,
        ));
  }

  Widget _buildExerciseScreen(bool isDark) {
    final exercise = controller.currentExercise;
    if (exercise == null) return const SizedBox.shrink();

    final workout = controller.activeWorkout.value!;
    final current = controller.currentExerciseIndex.value + 1;
    final total = workout.exercises.length;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        children: [
          Text(
            'Exercise $current of $total',
            style: AppTypography.bodyMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ).animate().fadeIn(),

          const SizedBox(height: AppConstants.spacingXl),

          // Exercise illustration
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.gray800 : AppColors.gray100,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusXl),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center_rounded,
                    size: 80,
                    color: isDark ? AppColors.gray500 : AppColors.gray400,
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  if (exercise.muscleGroup != null)
                    Text(
                      exercise.muscleGroup!,
                      style: AppTypography.bodyMediumDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                    ),
                ],
              ),
            ).animate(key: ValueKey(exercise.id)).fadeIn(),
          ),

          const SizedBox(height: AppConstants.spacingXl),

          Text(
            exercise.name,
            style: AppTypography.headlineSmallDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ).animate(key: ValueKey('name_${exercise.id}')).fadeIn(),

          const SizedBox(height: AppConstants.spacingMd),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SetRepChip(
                  label: '${exercise.sets} Sets',
                  isDark: isDark),
              const SizedBox(width: AppConstants.spacingMd),
              _SetRepChip(
                  label: '${exercise.reps} Reps',
                  isDark: isDark),
            ],
          ).animate(key: ValueKey('chips_${exercise.id}')).fadeIn(),

          if (exercise.instructions != null) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              exercise.instructions!,
              style: AppTypography.bodySmallDark.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          const SizedBox(height: AppConstants.spacingXl),
        ],
      ),
    );
  }

  Widget _buildRestScreen(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Rest Time',
            style: AppTypography.headlineMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXl),
          Obx(() => Text(
                '${controller.restSecondsRemaining.value}',
                style: AppTypography.displayLargeDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  fontSize: 80,
                  fontWeight: FontWeight.w800,
                ),
              )),
          const SizedBox(height: AppConstants.spacingXl),
          Text(
            'Next up:',
            style: AppTypography.bodyMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Obx(() {
            final nextIdx = controller.currentExerciseIndex.value + 1;
            final workout = controller.activeWorkout.value;
            if (workout == null || nextIdx >= workout.exercises.length) {
              return Text(
                'Final exercise!',
                style: AppTypography.titleMediumDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              );
            }
            return Text(
              workout.exercises[nextIdx].name,
              style: AppTypography.titleMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            );
          }),
          const SizedBox(height: AppConstants.spacingXxl),
          OutlinedButton(
            onPressed: controller.skipRest,
            child: const Text('Skip Rest'),
          ),
        ],
      ).animate().fadeIn(),
    );
  }

  Widget _buildBottomControls(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Obx(() {
        if (controller.isResting.value) return const SizedBox.shrink();

        final workout = controller.activeWorkout.value;
        final isLast = workout != null &&
            controller.currentExerciseIndex.value >=
                workout.exercises.length - 1;

        return AppButton(
          label: isLast ? 'Complete Workout 🎉' : 'Next Exercise',
          onPressed: controller.nextExercise,
          suffixIcon: isLast ? null : Icons.arrow_forward_rounded,
        );
      }),
    );
  }

  Future<bool?> _showExitDialog() {
    return Get.dialog<bool>(
      AlertDialog(
        title: const Text('Exit Workout?'),
        content: const Text(
            'Your progress will be lost. Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}

class _SetRepChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SetRepChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLg,
          vertical: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray800 : AppColors.gray100,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: Text(
        label,
        style: AppTypography.titleMediumDark.copyWith(
          color: isDark
              ? AppColors.darkTextPrimary
              : AppColors.lightTextPrimary,
        ),
      ),
    );
  }
}
