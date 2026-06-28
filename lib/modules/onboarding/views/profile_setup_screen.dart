import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../controllers/onboarding_controller.dart';

/// Profile setup screen — name, age, gender, height, weight
class ProfileSetupScreen extends GetView<OnboardingController> {
  const ProfileSetupScreen({super.key});

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
          'Your Profile',
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
              'Tell us about yourself',
              style: AppTypography.headlineMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ).animate().fadeIn(),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'This helps us personalize your fitness journey.',
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
              prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
            ).animate(delay: 100.ms).fadeIn(),
            const SizedBox(height: AppConstants.spacingMd),

            AppTextField(
              label: 'Age',
              hint: 'e.g. 28',
              controller: controller.ageController,
              keyboardType: TextInputType.number,
              prefixIcon:
                  const Icon(Icons.calendar_today_outlined, size: 20),
              suffixText: 'years',
            ).animate(delay: 140.ms).fadeIn(),
            const SizedBox(height: AppConstants.spacingMd),

            AppTextField(
              label: 'Weight',
              hint: 'e.g. 75',
              controller: controller.weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              prefixIcon:
                  const Icon(Icons.monitor_weight_outlined, size: 20),
              suffixText: 'kg',
            ).animate(delay: 180.ms).fadeIn(),
            const SizedBox(height: AppConstants.spacingMd),

            AppTextField(
              label: 'Height',
              hint: 'e.g. 175',
              controller: controller.heightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: const Icon(Icons.height_rounded, size: 20),
              suffixText: 'cm',
            ).animate(delay: 220.ms).fadeIn(),

            const SizedBox(height: AppConstants.spacingMd),

            // Gender selector
            Text(
              'Gender',
              style: AppTypography.labelMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Obx(() => Row(
                  children: [
                    _GenderChip(
                        label: 'Male',
                        value: 'male',
                        selected: controller.selectedGender.value,
                        onTap: () => controller.selectGender('male'),
                        isDark: isDark),
                    const SizedBox(width: AppConstants.spacingSm),
                    _GenderChip(
                        label: 'Female',
                        value: 'female',
                        selected: controller.selectedGender.value,
                        onTap: () => controller.selectGender('female'),
                        isDark: isDark),
                    const SizedBox(width: AppConstants.spacingSm),
                    _GenderChip(
                        label: 'Other',
                        value: 'other',
                        selected: controller.selectedGender.value,
                        onTap: () => controller.selectGender('other'),
                        isDark: isDark),
                  ],
                )).animate(delay: 260.ms).fadeIn(),

            const SizedBox(height: AppConstants.spacingXxl),

            Obx(() => AppButton(
                  label: 'Continue',
                  onPressed: controller.nextPage,
                  isLoading: controller.isLoading.value,
                  suffixIcon: Icons.arrow_forward_rounded,
                )).animate(delay: 300.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final VoidCallback onTap;
  final bool isDark;

  const _GenderChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selected == value;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: AppConstants.animFast,
          padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingMd),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.white : AppColors.black)
                : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelMediumDark.copyWith(
                color: isSelected
                    ? (isDark ? AppColors.black : AppColors.white)
                    : (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
