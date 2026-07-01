import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_text_field.dart';
import '../controllers/profile_controller.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Edit Profile',
          style: AppTypography.titleLargeDark.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: Form(
        key: controller.editFormKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Personal Info ──────────────────────────────────────────
              _buildSectionLabel('Personal Info', isDark),
              const SizedBox(height: AppConstants.spacingMd),
              AppTextField(
                label: 'Full Name',
                controller: controller.nameController,
                validator: Validators.name,
              ),
              const SizedBox(height: AppConstants.spacingMd),
              AppTextField(
                label: 'Age',
                controller: controller.ageController,
                keyboardType: TextInputType.number,
                validator: Validators.age,
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // ── Body Measurements ──────────────────────────────────────
              _buildSectionLabel('Body Measurements', isDark),
              const SizedBox(height: AppConstants.spacingMd),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Weight (kg)',
                      controller: controller.weightController,
                      keyboardType: TextInputType.number,
                      validator: Validators.weight,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: AppTextField(
                      label: 'Height (cm)',
                      controller: controller.heightController,
                      keyboardType: TextInputType.number,
                      validator: Validators.height,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // ── Gender ──────────────────────────────────────────────────
              _buildSectionLabel('Gender', isDark),
              const SizedBox(height: AppConstants.spacingSm),
              Obx(() => _buildChips(['male', 'female', 'other'],
                  controller.selectedGender, isDark)),
              const SizedBox(height: AppConstants.spacingXl),

              // ── Goal ────────────────────────────────────────────────────
              _buildSectionLabel('Fitness Goal', isDark),
              const SizedBox(height: AppConstants.spacingSm),
              Obx(() => _buildChips(
                  ['weight_loss', 'muscle_gain', 'maintenance', 'general_fitness'],
                  controller.selectedGoal,
                  isDark)),
              const SizedBox(height: AppConstants.spacingXl),

              // ── Activity Level ─────────────────────────────────────────
              _buildSectionLabel('Activity Level', isDark),
              const SizedBox(height: AppConstants.spacingSm),
              Obx(() => _buildChips(
                  ['sedentary', 'lightly_active', 'moderately_active', 'very_active'],
                  controller.selectedActivityLevel,
                  isDark)),
              const SizedBox(height: AppConstants.spacingXl),

              // ── Stats ───────────────────────────────────────────────────
              Obx(() {
                if (controller.userBMI == null) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('Your Stats', isDark),
                    const SizedBox(height: AppConstants.spacingMd),
                    Row(
                      children: [
                        Expanded(
                          child: AppCard(
                            child: Column(
                              children: [
                                Text(
                                  'BMI',
                                  style: AppTypography.labelSmallDark.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                ),
                                Text(
                                  controller.userBMI!.toStringAsFixed(1),
                                  style: AppTypography.titleLargeDark.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                                Text(
                                  controller.userBMICategory ?? '',
                                  style: AppTypography.bodySmallDark.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextTertiary
                                        : AppColors.lightTextTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMd),
                        Expanded(
                          child: AppCard(
                            child: Column(
                              children: [
                                Text(
                                  'TDEE',
                                  style: AppTypography.labelSmallDark.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                  ),
                                ),
                                Text(
                                  '${controller.userTDEE?.toStringAsFixed(0) ?? '--'}',
                                  style: AppTypography.titleLargeDark.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.lightTextPrimary,
                                  ),
                                ),
                                Text(
                                  'kcal/day',
                                  style: AppTypography.bodySmallDark.copyWith(
                                    color: isDark
                                        ? AppColors.darkTextTertiary
                                        : AppColors.lightTextTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingXl),
                  ],
                );
              }),

              // ── Save Button ────────────────────────────────────────────
              Obx(() => AppButton(
                    label: 'Save Changes',
                    onPressed: controller.saveProfile,
                    isLoading: controller.isSaving.value,
                  )).animate(delay: 200.ms).fadeIn(),

              const SizedBox(height: AppConstants.spacingXl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label, bool isDark) {
    return Text(
      label.toUpperCase(),
      style: AppTypography.labelSmallDark.copyWith(
        color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildChips(List<String> options, RxString selected, bool isDark) {
    return Wrap(
      spacing: AppConstants.spacingSm,
      runSpacing: AppConstants.spacingSm,
      children: options.map((option) {
        return GestureDetector(
          onTap: () => selected.value = option,
          child: Obx(() {
            final isSelected = selected.value == option;
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingMd,
                vertical: AppConstants.spacingSm,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.white : AppColors.black)
                    : (isDark ? AppColors.darkCard : AppColors.lightCard),
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Text(
                option.replaceAll('_', ' ').toUpperCase(),
                style: AppTypography.labelSmallDark.copyWith(
                  color: isSelected
                      ? (isDark ? AppColors.black : AppColors.white)
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
                ),
              ),
            );
          }),
        );
      }).toList(),
    );
  }
}
