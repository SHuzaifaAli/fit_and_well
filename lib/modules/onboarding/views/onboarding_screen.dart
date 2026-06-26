import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../controllers/onboarding_controller.dart';

/// Multi-step onboarding screen — collects user profile, goals, and preferences
class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ── Progress bar ───────────────────────────────────────────────
            _ProgressHeader(isDark: isDark),

            // ── Page content ───────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => controller.currentPage.value = i,
                children: const [
                  _Step1Name(),
                  _Step2Body(),
                  _Step3Measurements(),
                  _Step4Goal(),
                  _Step5Activity(),
                ],
              ),
            ),

            // ── Navigation buttons ──────────────────────────────────────────
            _NavigationButtons(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

// ─── Progress Header ──────────────────────────────────────────────────────────

class _ProgressHeader extends GetView<OnboardingController> {
  final bool isDark;
  const _ProgressHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.spacingXl,
        AppConstants.spacingMd,
        AppConstants.spacingXl,
        AppConstants.spacingMd,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Obx(() => controller.currentPage.value > 0
                  ? GestureDetector(
                      onTap: controller.previousPage,
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 20,
                        color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
                      ),
                    )
                  : const SizedBox(width: 20)),
              const Spacer(),
              Obx(() => Text(
                    '${controller.currentPage.value + 1} / ${OnboardingController.totalPages}',
                    style: AppTypography.labelMediumDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  )),
              const Spacer(),
              GestureDetector(
                onTap: controller.skipOnboarding,
                child: Text(
                  'Skip',
                  style: AppTypography.labelMediumDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Progress dots
          Obx(() => Row(
                children: List.generate(
                  OnboardingController.totalPages,
                  (i) => Expanded(
                    child: AnimatedContainer(
                      duration: AppConstants.animNormal,
                      height: 3,
                      margin: EdgeInsets.only(
                        right: i < OnboardingController.totalPages - 1
                            ? AppConstants.spacingXs
                            : 0,
                      ),
                      decoration: BoxDecoration(
                        color: i <= controller.currentPage.value
                            ? (isDark ? AppColors.white : AppColors.black)
                            : (isDark ? AppColors.gray700 : AppColors.gray200),
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusFull),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ─── Navigation Buttons ───────────────────────────────────────────────────────

class _NavigationButtons extends GetView<OnboardingController> {
  final bool isDark;
  const _NavigationButtons({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Obx(() {
        final isLast = controller.currentPage.value ==
            OnboardingController.totalPages - 1;

        return Column(
          children: [
            if (controller.errorMessage.value.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                margin:
                    const EdgeInsets.only(bottom: AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border:
                      Border.all(color: AppColors.errorLight.withOpacity(0.3)),
                ),
                child: Text(
                  controller.errorMessage.value,
                  style: AppTypography.bodySmallDark
                      .copyWith(color: AppColors.errorLight),
                ),
              ),
            AppButton(
              label: isLast ? 'Complete Setup' : 'Continue',
              onPressed: isLast
                  ? controller.completeOnboarding
                  : (controller.canGoNext ? controller.nextPage : null),
              isLoading: controller.isLoading.value,
              isDisabled: !controller.canGoNext && !isLast,
            ),
          ],
        );
      }),
    );
  }
}

// ─── Step 1: Name ─────────────────────────────────────────────────────────────

class _Step1Name extends GetView<OnboardingController> {
  const _Step1Name();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            'What\'s your name?',
            style: AppTypography.displaySmallDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ).animate().fadeIn().slideX(begin: -0.1, end: 0),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'We\'ll personalize your experience based on who you are.',
            style: AppTypography.bodyMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ).animate(delay: 80.ms).fadeIn(),
          const SizedBox(height: AppConstants.spacingXxl),
          AppTextField(
            label: 'Full Name',
            hint: 'e.g. Alex Johnson',
            controller: controller.nameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            autofocus: true,
            validator: Validators.name,
            onChanged: (_) => controller.currentPage.refresh(),
            prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
          ).animate(delay: 160.ms).fadeIn().slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }
}

// ─── Step 2: Gender & Age ─────────────────────────────────────────────────────

class _Step2Body extends GetView<OnboardingController> {
  const _Step2Body();

  static const _genders = [
    ('male', 'Male', Icons.male_rounded),
    ('female', 'Female', Icons.female_rounded),
    ('other', 'Other', Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            'Tell us about yourself',
            style: AppTypography.displaySmallDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ).animate().fadeIn(),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'This helps us calculate your daily calorie needs accurately.',
            style: AppTypography.bodyMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ).animate(delay: 80.ms).fadeIn(),
          const SizedBox(height: AppConstants.spacingXxl),

          // Gender
          Text(
            'Gender',
            style: AppTypography.labelMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ).animate(delay: 120.ms).fadeIn(),
          const SizedBox(height: AppConstants.spacingMd),
          Obx(() => Row(
                children: _genders
                    .map((g) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: AppConstants.spacingSm),
                            child: _SelectionChip(
                              label: g.$2,
                              icon: g.$3,
                              isSelected:
                                  controller.selectedGender.value == g.$1,
                              onTap: () => controller.selectGender(g.$1),
                              isDark: isDark,
                            ),
                          ),
                        ))
                    .toList(),
              )).animate(delay: 160.ms).fadeIn(),

          const SizedBox(height: AppConstants.spacingXl),

          // Age
          AppTextField(
            label: 'Age',
            hint: 'e.g. 28',
            controller: controller.ageController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            validator: Validators.age,
            onChanged: (_) => controller.currentPage.refresh(),
            prefixIcon:
                const Icon(Icons.calendar_today_outlined, size: 20),
            suffixText: 'years',
          ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }
}

// ─── Step 3: Weight & Height ──────────────────────────────────────────────────

class _Step3Measurements extends GetView<OnboardingController> {
  const _Step3Measurements();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            'Your measurements',
            style: AppTypography.displaySmallDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ).animate().fadeIn(),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Used to calculate your BMI and ideal calorie targets.',
            style: AppTypography.bodyMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ).animate(delay: 80.ms).fadeIn(),
          const SizedBox(height: AppConstants.spacingXxl),
          AppTextField(
            label: 'Weight',
            hint: 'e.g. 75',
            controller: controller.weightController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            validator: Validators.weight,
            onChanged: (_) => controller.currentPage.refresh(),
            prefixIcon:
                const Icon(Icons.monitor_weight_outlined, size: 20),
            suffixText: 'kg',
          ).animate(delay: 120.ms).fadeIn().slideY(begin: 0.1, end: 0),
          const SizedBox(height: AppConstants.spacingMd),
          AppTextField(
            label: 'Height',
            hint: 'e.g. 175',
            controller: controller.heightController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            validator: Validators.height,
            onChanged: (_) => controller.currentPage.refresh(),
            prefixIcon: const Icon(Icons.height_rounded, size: 20),
            suffixText: 'cm',
          ).animate(delay: 180.ms).fadeIn().slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }
}

// ─── Step 4: Goal ─────────────────────────────────────────────────────────────

class _Step4Goal extends GetView<OnboardingController> {
  const _Step4Goal();

  static const _goals = [
    (
      AppConstants.goalWeightLoss,
      'Lose Weight',
      'Burn fat and get leaner',
      Icons.trending_down_rounded,
    ),
    (
      AppConstants.goalMuscleGain,
      'Build Muscle',
      'Gain strength and size',
      Icons.fitness_center_rounded,
    ),
    (
      AppConstants.goalMaintenance,
      'Maintain Weight',
      'Stay at your current weight',
      Icons.balance_rounded,
    ),
    (
      AppConstants.goalGeneralFitness,
      'General Fitness',
      'Improve overall health',
      Icons.directions_run_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            'What\'s your goal?',
            style: AppTypography.displaySmallDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ).animate().fadeIn(),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Your workouts and nutrition plan will be tailored to this.',
            style: AppTypography.bodyMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ).animate(delay: 80.ms).fadeIn(),
          const SizedBox(height: AppConstants.spacingXxl),
          Obx(() => Column(
                children: _goals
                    .asMap()
                    .entries
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppConstants.spacingMd),
                        child: _GoalCard(
                          id: e.value.$1,
                          label: e.value.$2,
                          subtitle: e.value.$3,
                          icon: e.value.$4,
                          isSelected:
                              controller.selectedGoal.value == e.value.$1,
                          onTap: () => controller.selectGoal(e.value.$1),
                          isDark: isDark,
                          delay: 120 + (e.key * 60),
                        ),
                      ),
                    )
                    .toList(),
              )),
        ],
      ),
    );
  }
}

// ─── Step 5: Activity Level ───────────────────────────────────────────────────

class _Step5Activity extends GetView<OnboardingController> {
  const _Step5Activity();

  static const _levels = [
    (
      AppConstants.activitySedentary,
      'Sedentary',
      'Little or no exercise',
    ),
    (
      AppConstants.activityLightlyActive,
      'Lightly Active',
      'Exercise 1–3 days/week',
    ),
    (
      AppConstants.activityModeratelyActive,
      'Moderately Active',
      'Exercise 3–5 days/week',
    ),
    (
      AppConstants.activityVeryActive,
      'Very Active',
      'Exercise 6–7 days/week',
    ),
    (
      AppConstants.activityExtraActive,
      'Extra Active',
      'Very intense daily exercise',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppConstants.spacingLg),
          Text(
            'How active are you?',
            style: AppTypography.displaySmallDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ).animate().fadeIn(),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Your activity level helps us set the right calorie targets.',
            style: AppTypography.bodyMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ).animate(delay: 80.ms).fadeIn(),
          const SizedBox(height: AppConstants.spacingXxl),
          Obx(() => Column(
                children: _levels
                    .asMap()
                    .entries
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppConstants.spacingMd),
                        child: _ActivityCard(
                          id: e.value.$1,
                          label: e.value.$2,
                          subtitle: e.value.$3,
                          isSelected: controller.selectedActivityLevel.value ==
                              e.value.$1,
                          onTap: () =>
                              controller.selectActivityLevel(e.value.$1),
                          isDark: isDark,
                          delay: 100 + (e.key * 50),
                        ),
                      ),
                    )
                    .toList(),
              )),
        ],
      ),
    );
  }
}

// ─── Reusable Sub-Widgets ─────────────────────────────────────────────────────

class _SelectionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _SelectionChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingMd,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.white : AppColors.black)
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.white : AppColors.black)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? (isDark ? AppColors.black : AppColors.white)
                  : (isDark ? AppColors.darkIcon : AppColors.lightIcon),
            ),
            const SizedBox(height: AppConstants.spacingXs),
            Text(
              label,
              style: AppTypography.labelSmallDark.copyWith(
                color: isSelected
                    ? (isDark ? AppColors.black : AppColors.white)
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
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

class _GoalCard extends StatelessWidget {
  final String id;
  final String label;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;
  final int delay;

  const _GoalCard({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.white : AppColors.black)
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.white : AppColors.black)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark
                        ? AppColors.black.withOpacity(0.15)
                        : AppColors.white.withOpacity(0.2))
                    : (isDark ? AppColors.gray800 : AppColors.gray100),
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isSelected
                    ? (isDark ? AppColors.black : AppColors.white)
                    : (isDark ? AppColors.darkIcon : AppColors.lightIcon),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.titleSmallDark.copyWith(
                      color: isSelected
                          ? (isDark ? AppColors.black : AppColors.white)
                          : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary),
                      fontWeight: AppTypography.weightSemiBold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmallDark.copyWith(
                      color: isSelected
                          ? (isDark
                              ? AppColors.black.withOpacity(0.65)
                              : AppColors.white.withOpacity(0.75))
                          : (isDark
                              ? AppColors.darkTextTertiary
                              : AppColors.lightTextTertiary),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: isDark ? AppColors.black : AppColors.white,
              ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn().slideY(
          begin: 0.08,
          end: 0,
          duration: AppConstants.animNormal,
        );
  }
}

class _ActivityCard extends StatelessWidget {
  final String id;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;
  final int delay;

  const _ActivityCard({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingMd,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.white : AppColors.black)
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.white : AppColors.black)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.titleSmallDark.copyWith(
                    color: isSelected
                        ? (isDark ? AppColors.black : AppColors.white)
                        : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary),
                    fontWeight: AppTypography.weightSemiBold,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTypography.bodySmallDark.copyWith(
                    color: isSelected
                        ? (isDark
                            ? AppColors.black.withOpacity(0.6)
                            : AppColors.white.withOpacity(0.75))
                        : (isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary),
                  ),
                ),
              ],
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: isDark ? AppColors.black : AppColors.white,
              ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn().slideY(
          begin: 0.06,
          end: 0,
          duration: AppConstants.animNormal,
        );
  }
}
