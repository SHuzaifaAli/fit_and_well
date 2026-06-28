import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_card.dart';
import '../../ai_coach/views/ai_coach_screen.dart';
import '../../nutrition/views/nutrition_screen.dart';
import '../../profile/views/profile_screen.dart';
import '../../progress/views/progress_screen.dart';
import '../../workouts/views/workout_list_screen.dart';
import '../controllers/dashboard_controller.dart';

/// Main dashboard with bottom navigation — Phase 1 shell.
/// Each tab will be fleshed out in later phases.
class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  static const _tabs = [
    (Icons.home_outlined, Icons.home_rounded, 'Home'),
    (Icons.fitness_center_outlined, Icons.fitness_center_rounded, 'Workout'),
    (Icons.restaurant_outlined, Icons.restaurant_rounded, 'Nutrition'),
    (Icons.auto_awesome_outlined, Icons.auto_awesome_rounded, 'AI Coach'),
    (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
  ];

  static final List<Widget> _screens = [
    const _HomeTab(),
    const WorkoutListScreen(),
    const NutritionScreen(),
    const AiCoachScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Obx(() => IndexedStack(
            index: controller.currentTabIndex.value,
            children: _screens,
          )),
      bottomNavigationBar: _BottomNav(isDark: isDark),
    );
  }
}

// ── Bottom Navigation ─────────────────────────────────────────────────────────

class _BottomNav extends GetView<DashboardController> {
  final bool isDark;
  const _BottomNav({required this.isDark});

  static const _tabs = DashboardScreen._tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: AppConstants.spacingSm,
          ),
          child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _tabs
                    .asMap()
                    .entries
                    .map((e) => _NavItem(
                          index: e.key,
                          selectedIcon: e.value.$2,
                          unselectedIcon: e.value.$1,
                          label: e.value.$3,
                          isSelected: controller.currentTabIndex.value == e.key,
                          isDark: isDark,
                          onTap: () =>
                              controller.currentTabIndex.value = e.key,
                        ))
                    .toList(),
              )),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppConstants.animFast,
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
                vertical: AppConstants.spacingXs,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.gray800 : AppColors.gray100)
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusFull),
              ),
              child: Icon(
                isSelected ? selectedIcon : unselectedIcon,
                size: 22,
                color: isSelected
                    ? (isDark ? AppColors.white : AppColors.black)
                    : (isDark ? AppColors.gray500 : AppColors.gray400),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.labelSmallDark.copyWith(
                color: isSelected
                    ? (isDark ? AppColors.white : AppColors.black)
                    : (isDark ? AppColors.gray500 : AppColors.gray400),
                fontWeight: isSelected
                    ? AppTypography.weightSemiBold
                    : AppTypography.weightRegular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Home Tab ──────────────────────────────────────────────────────────────────

class _HomeTab extends GetView<DashboardController> {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          backgroundColor:
              isDark ? AppColors.darkBackground : AppColors.lightBackground,
          floating: true,
          snap: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: AppConstants.spacingXl,
          title: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${controller.greeting},',
                    style: AppTypography.bodyMediumDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  Text(
                    controller.userName,
                    style: AppTypography.titleLargeDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              )),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.only(right: AppConstants.spacingXl),
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.subscription),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMd,
                    vertical: AppConstants.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.gray800 : AppColors.gray100,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusFull),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.workspace_premium_rounded,
                        size: 14,
                        color: isDark ? AppColors.gray300 : AppColors.gray600,
                      ),
                      const SizedBox(width: AppConstants.spacingXs),
                      Text(
                        'Free',
                        style: AppTypography.labelSmallDark.copyWith(
                          color: isDark
                              ? AppColors.gray300
                              : AppColors.gray600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Today's summary card
              _TodaySummaryCard(isDark: isDark)
                  .animate()
                  .fadeIn()
                  .slideY(begin: 0.05, end: 0, duration: AppConstants.animNormal),

              const SizedBox(height: AppConstants.spacingXl),

              // Quick Actions
              Text(
                'Quick Actions',
                style: AppTypography.titleMediumDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ).animate(delay: 80.ms).fadeIn(),

              const SizedBox(height: AppConstants.spacingMd),

              _QuickActionsRow(isDark: isDark)
                  .animate(delay: 120.ms)
                  .fadeIn()
                  .slideY(begin: 0.05, end: 0),

              const SizedBox(height: AppConstants.spacingXl),

              // AI Coach CTA
              _AICoachCard(isDark: isDark)
                  .animate(delay: 200.ms)
                  .fadeIn()
                  .slideY(begin: 0.05, end: 0),

              const SizedBox(height: AppConstants.spacingXxl),
            ]),
          ),
        ),
      ],
    );
  }
}

class _TodaySummaryCard extends StatelessWidget {
  final bool isDark;
  const _TodaySummaryCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Today',
                style: AppTypography.titleMediumDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                _formattedDate(),
                style: AppTypography.labelSmallDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingLg),
          Row(
            children: [
              _StatCell(
                  label: 'Calories',
                  value: '0',
                  unit: 'kcal',
                  isDark: isDark),
              _Divider(isDark: isDark),
              _StatCell(
                  label: 'Protein',
                  value: '0',
                  unit: 'g',
                  isDark: isDark),
              _Divider(isDark: isDark),
              _StatCell(
                  label: 'Water',
                  value: '0',
                  unit: 'ml',
                  isDark: isDark),
              _Divider(isDark: isDark),
              _StatCell(
                  label: 'Workouts',
                  value: '0',
                  unit: 'done',
                  isDark: isDark),
            ],
          ),
        ],
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[now.month - 1]} ${now.day}';
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final bool isDark;

  const _StatCell({
    required this.label,
    required this.value,
    required this.unit,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.headlineMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          Text(
            unit,
            style: AppTypography.labelSmallDark.copyWith(
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.lightTextTertiary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXs),
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
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 48,
      color: isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder,
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  final bool isDark;
  const _QuickActionsRow({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.fitness_center_rounded, 'Log\nWorkout', AppRoutes.workouts),
      (Icons.restaurant_rounded, 'Log\nMeal', AppRoutes.nutrition),
      (Icons.monitor_weight_outlined, 'Log\nWeight', AppRoutes.progress),
      (Icons.water_drop_outlined, 'Log\nWater', AppRoutes.nutrition),
    ];

    return Row(
      children: actions
          .map(
            (a) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: AppConstants.spacingSm),
                child: GestureDetector(
                  onTap: () => Get.toNamed(a.$3),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingMd,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusLg),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorderSubtle
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          a.$1,
                          size: 22,
                          color: isDark
                              ? AppColors.darkIcon
                              : AppColors.lightIcon,
                        ),
                        const SizedBox(height: AppConstants.spacingXs),
                        Text(
                          a.$2,
                          textAlign: TextAlign.center,
                          style: AppTypography.labelSmallDark.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AICoachCard extends StatelessWidget {
  final bool isDark;
  const _AICoachCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.aiCoach),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray900 : AppColors.gray950,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.gray700,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                size: 22,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Coach',
                    style: AppTypography.titleSmallDark.copyWith(
                      color: AppColors.white,
                      fontWeight: AppTypography.weightSemiBold,
                    ),
                  ),
                  Text(
                    'Ask anything about your fitness or nutrition',
                    style: AppTypography.bodySmallDark.copyWith(
                      color: AppColors.gray400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: AppColors.gray500,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stub Tabs (fleshed out in subsequent phases) ──────────────────────────────

class _WorkoutTab extends StatelessWidget {
  const _WorkoutTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: const Center(child: Text('Phase 3 — Workout Module')),
    );
  }
}

class _NutritionTab extends StatelessWidget {
  const _NutritionTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition')),
      body: const Center(child: Text('Phase 4 — Nutrition Module')),
    );
  }
}

class _AICoachTab extends StatelessWidget {
  const _AICoachTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Coach')),
      body: const Center(child: Text('Phase 5 — AI Coach Module')),
    );
  }
}

class _ProfileTab extends GetView<DashboardController> {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.find<AuthController>().signOut(),
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
