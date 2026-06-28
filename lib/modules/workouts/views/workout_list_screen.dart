import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/shimmer_widget.dart';
import '../controllers/workout_controller.dart';

class WorkoutListScreen extends GetView<WorkoutController> {
  const WorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Workouts',
          style: AppTypography.titleLargeDark.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Difficulty Filter ──────────────────────────────────────────
          _buildDifficultyFilter(isDark),

          // ── Workout List ───────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (controller.isLoadingWorkouts.value) {
                return _buildShimmerList();
              }

              if (controller.filteredWorkouts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fitness_center_outlined,
                          size: 64,
                          color: isDark
                              ? AppColors.darkTextTertiary
                              : AppColors.lightTextTertiary),
                      const SizedBox(height: AppConstants.spacingMd),
                      Text(
                        'No workouts found',
                        style: AppTypography.bodyLargeDark.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.loadWorkouts(refresh: true),
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.spacingXl),
                  itemCount: controller.filteredWorkouts.length,
                  itemBuilder: (context, index) {
                    final workout = controller.filteredWorkouts[index];
                    return _WorkoutCard(
                      workout: workout,
                      isDark: isDark,
                      onTap: () {
                        controller.loadWorkoutDetail(workout.id);
                        Get.toNamed(AppRoutes.workoutDetail,
                            arguments: workout);
                      },
                    )
                        .animate(delay: Duration(milliseconds: index * 60))
                        .fadeIn()
                        .slideY(begin: 0.1, end: 0);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyFilter(bool isDark) {
    final filters = ['all', 'beginner', 'intermediate', 'advanced'];

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingXl, vertical: 8),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          return Obx(() {
            final isSelected = controller.selectedDifficulty.value == filter;
            return GestureDetector(
              onTap: () => controller.filterByDifficulty(filter),
              child: AnimatedContainer(
                duration: AppConstants.animFast,
                margin: const EdgeInsets.only(right: AppConstants.spacingSm),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.white : AppColors.black)
                      : Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusFull),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                  ),
                ),
                child: Text(
                  filter[0].toUpperCase() + filter.substring(1),
                  style: AppTypography.labelMediumDark.copyWith(
                    color: isSelected
                        ? (isDark ? AppColors.black : AppColors.white)
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
        child: ShimmerWidget(
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final workout;
  final bool isDark;
  final VoidCallback onTap;

  const _WorkoutCard({
    required this.workout,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            // Workout image / icon placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: isDark ? AppColors.gray700 : AppColors.gray200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusLg),
                  bottomLeft: Radius.circular(AppConstants.radiusLg),
                ),
              ),
              child: Icon(
                Icons.fitness_center_rounded,
                size: 36,
                color: isDark ? AppColors.gray500 : AppColors.gray400,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.title,
                      style: AppTypography.titleSmallDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _Tag(
                          label: workout.difficulty,
                          isDark: isDark,
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.timer_outlined,
                            size: 12,
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary),
                        const SizedBox(width: 2),
                        Text(
                          '${workout.durationMinutes} min',
                          style: AppTypography.bodySmallDark.copyWith(
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.local_fire_department_outlined,
                            size: 12,
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary),
                        const SizedBox(width: 2),
                        Text(
                          '~${workout.caloriesBurned} kcal',
                          style: AppTypography.bodySmallDark.copyWith(
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary,
                          ),
                        ),
                        if (workout.exercises.isNotEmpty) ...[
                          const SizedBox(width: AppConstants.spacingMd),
                          Icon(Icons.list_outlined,
                              size: 12,
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary),
                          const SizedBox(width: 2),
                          Text(
                            '${workout.exercises.length} exercises',
                            style: AppTypography.bodySmallDark.copyWith(
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightTextTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final bool isDark;

  const _Tag({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray700 : AppColors.gray200,
        borderRadius: BorderRadius.circular(AppConstants.radiusXs),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmallDark.copyWith(
          color: isDark ? AppColors.gray300 : AppColors.gray600,
        ),
      ),
    );
  }
}
