import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../modules/nutrition/controllers/nutrition_controller.dart';
import '../../../modules/workouts/controllers/workout_controller.dart';
import '../../../routes/app_routes.dart';
import '../controllers/dashboard_controller.dart';

class HomeScreen extends GetView<DashboardController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshAll,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.spacingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Greeting ─────────────────────────────────────────────
                _buildGreeting(isDark),
                const SizedBox(height: AppConstants.spacingXxl),

                // ── Today's Summary ───────────────────────────────────────
                _buildTodaySummary(isDark),
                const SizedBox(height: AppConstants.spacingXxl),

                // ── Quick Actions ─────────────────────────────────────────
                _buildQuickActions(isDark),
                const SizedBox(height: AppConstants.spacingXxl),

                // ── Recommended Workouts ──────────────────────────────────
                _buildRecommendedWorkouts(isDark),
                const SizedBox(height: AppConstants.spacingXxl),

                // ── AI Coach Banner ───────────────────────────────────────
                _buildAiCoachBanner(isDark),
                const SizedBox(height: AppConstants.spacingXl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${controller.greeting},',
              style: AppTypography.bodyLargeDark.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            Text(
              controller.userName,
              style: AppTypography.headlineMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ],
        ).animate().fadeIn(),
        GestureDetector(
          onTap: () => Get.toNamed(AppRoutes.profile),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.gray700 : AppColors.gray200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: isDark ? AppColors.gray300 : AppColors.gray600,
            ),
          ),
        ).animate().fadeIn(delay: 100.ms),
      ],
    );
  }

  Widget _buildTodaySummary(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Summary",
          style: AppTypography.titleMediumDark.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: GetBuilder<NutritionController>(
                builder: (nc) => _SummaryCard(
                  icon: Icons.local_fire_department_outlined,
                  label: 'Calories',
                  value:
                      '${nc.totalCalories.toStringAsFixed(0)}',
                  subtitle:
                      'of ${nc.dailyCalorieGoal.toStringAsFixed(0)} kcal',
                  progress: nc.calorieProgress,
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: GetBuilder<NutritionController>(
                builder: (nc) => _SummaryCard(
                  icon: Icons.water_drop_outlined,
                  label: 'Water',
                  value:
                      '${(nc.waterIntakeMl.value / 1000).toStringAsFixed(1)}L',
                  subtitle:
                      'of ${(nc.waterGoalMl / 1000).toStringAsFixed(1)}L',
                  progress: nc.waterProgress,
                  isDark: isDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: [
            Expanded(
              child: GetBuilder<WorkoutController>(
                builder: (wc) => _SummaryCard(
                  icon: Icons.fitness_center_outlined,
                  label: 'Streak',
                  value: '${wc.workoutStreak.value}',
                  subtitle: 'day streak',
                  progress: null,
                  isDark: isDark,
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: GetBuilder<WorkoutController>(
                builder: (wc) => _SummaryCard(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Workouts',
                  value: '${wc.workoutHistory.length}',
                  subtitle: 'completed',
                  progress: null,
                  isDark: isDark,
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate(delay: 100.ms).fadeIn();
  }

  Widget _buildQuickActions(bool isDark) {
    final actions = [
      {
        'icon': Icons.fitness_center_rounded,
        'label': 'Workout',
        'route': AppRoutes.workouts,
      },
      {
        'icon': Icons.restaurant_menu_rounded,
        'label': 'Nutrition',
        'route': AppRoutes.nutrition,
      },
      {
        'icon': Icons.auto_awesome_rounded,
        'label': 'AI Coach',
        'route': AppRoutes.aiCoach,
      },
      {
        'icon': Icons.show_chart_rounded,
        'label': 'Progress',
        'route': AppRoutes.progress,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTypography.titleMediumDark.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          children: actions.asMap().entries.map((entry) {
            final i = entry.key;
            final action = entry.value;
            return Expanded(
              child: GestureDetector(
                onTap: () => Get.toNamed(action['route'] as String),
                child: Container(
                  margin: EdgeInsets.only(
                      right: i < actions.length - 1
                          ? AppConstants.spacingSm
                          : 0),
                  padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingMd),
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
                    children: [
                      Icon(
                        action['icon'] as IconData,
                        size: 22,
                        color: isDark
                            ? AppColors.darkIcon
                            : AppColors.lightIcon,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        action['label'] as String,
                        style: AppTypography.labelSmallDark.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate(
                        delay: Duration(milliseconds: 200 + i * 50))
                    .fadeIn()
                    .scale(begin: const Offset(0.95, 0.95)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecommendedWorkouts(bool isDark) {
    return GetBuilder<WorkoutController>(
      builder: (wc) {
        if (wc.allWorkouts.isEmpty) return const SizedBox.shrink();

        final featured = wc.allWorkouts.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommended',
                  style: AppTypography.titleMediumDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.workouts),
                  child: Text(
                    'See all',
                    style: AppTypography.bodySmallDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMd),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: featured.length,
                itemBuilder: (context, index) {
                  final workout = featured[index];
                  return GestureDetector(
                    onTap: () {
                      wc.loadWorkoutDetail(workout.id);
                      Get.toNamed(AppRoutes.workoutDetail,
                          arguments: workout);
                    },
                    child: Container(
                      width: 200,
                      margin: const EdgeInsets.only(
                          right: AppConstants.spacingMd),
                      padding: const EdgeInsets.all(AppConstants.spacingMd),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusLg),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.gray700
                                  : AppColors.gray200,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusSm),
                            ),
                            child: Icon(
                              Icons.fitness_center_rounded,
                              size: 18,
                              color: isDark
                                  ? AppColors.gray400
                                  : AppColors.gray500,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingSm),
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
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                workout.difficulty,
                                style: AppTypography.labelSmallDark.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextTertiary
                                      : AppColors.lightTextTertiary,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${workout.durationMinutes}m',
                                style: AppTypography.labelSmallDark.copyWith(
                                  color: isDark
                                      ? AppColors.darkTextTertiary
                                      : AppColors.lightTextTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate(
                          delay: Duration(milliseconds: 300 + index * 80))
                      .fadeIn()
                      .slideX(begin: 0.1, end: 0);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAiCoachBanner(bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.aiCoach),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        decoration: BoxDecoration(
          color: isDark ? AppColors.white : AppColors.black,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Coach',
                    style: AppTypography.titleMediumDark.copyWith(
                      color: isDark ? AppColors.black : AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Get personalized meal plans and workout advice',
                    style: AppTypography.bodySmallDark.copyWith(
                      color: isDark ? AppColors.gray600 : AppColors.gray400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Icon(
              Icons.auto_awesome_rounded,
              color: isDark ? AppColors.black : AppColors.white,
              size: 28,
            ),
          ],
        ),
      ).animate(delay: 400.ms).fadeIn(),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final double? progress;
  final bool isDark;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.progress,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 16,
                  color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTypography.labelSmallDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
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
            subtitle,
            style: AppTypography.bodySmallDark.copyWith(
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.lightTextTertiary,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: AppConstants.spacingSm),
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppConstants.radiusFull),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor:
                    isDark ? AppColors.gray700 : AppColors.gray200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? AppColors.white : AppColors.black,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
