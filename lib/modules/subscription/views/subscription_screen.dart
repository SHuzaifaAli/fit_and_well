import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../widgets/app_button.dart';
import '../controllers/subscription_controller.dart';

class SubscriptionScreen extends GetView<SubscriptionController> {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.close_rounded,
              color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            _buildHeader(isDark),
            const SizedBox(height: AppConstants.spacingXxl),

            // ── Features ─────────────────────────────────────────────────
            _buildFeaturesList(isDark),
            const SizedBox(height: AppConstants.spacingXxl),

            // ── Plan Selector ─────────────────────────────────────────────
            Text(
              'Choose Your Plan',
              style: AppTypography.titleMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),
            _buildPlanSelector(isDark),
            const SizedBox(height: AppConstants.spacingXxl),

            // ── CTA ───────────────────────────────────────────────────────
            Obx(() => AppButton(
                  label: 'Start Premium',
                  onPressed: controller.subscribe,
                  isLoading: controller.isLoading.value,
                  suffixIcon: Icons.arrow_forward_rounded,
                )).animate(delay: 400.ms).fadeIn(),

            const SizedBox(height: AppConstants.spacingMd),

            Center(
              child: TextButton(
                onPressed: controller.restorePurchases,
                child: Text(
                  'Restore Purchases',
                  style: AppTypography.bodySmallDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingMd),

            Center(
              child: Text(
                'Cancel anytime • Secure payment',
                style: AppTypography.bodySmallDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ),
            ),

            const SizedBox(height: AppConstants.spacingXl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: isDark ? AppColors.white : AppColors.black,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Icon(
            Icons.workspace_premium_rounded,
            color: isDark ? AppColors.black : AppColors.white,
            size: 28,
          ),
        ).animate().scale(duration: AppConstants.animMedium),
        const SizedBox(height: AppConstants.spacingMd),
        Text(
          'Unlock Premium',
          style: AppTypography.headlineMediumDark.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: AppConstants.spacingSm),
        Text(
          'Get unlimited access to AI coaching, personalized meal plans, and advanced analytics.',
          style: AppTypography.bodyMediumDark.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ).animate().fadeIn(delay: 150.ms),
      ],
    );
  }

  Widget _buildFeaturesList(bool isDark) {
    return Column(
      children: controller.premiumFeatures.asMap().entries.map((entry) {
        final i = entry.key;
        final feature = entry.value;
        return Padding(
          padding:
              const EdgeInsets.only(bottom: AppConstants.spacingMd),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.gray800 : AppColors.gray100,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Center(
                  child: Text(
                    feature['icon'] as String,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: AppTypography.titleSmallDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      feature['description'] as String,
                      style: AppTypography.bodySmallDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.check_circle_rounded,
                  size: 20,
                  color: isDark ? AppColors.white : AppColors.black),
            ],
          )
              .animate(delay: Duration(milliseconds: 200 + i * 60))
              .fadeIn()
              .slideX(begin: 0.05, end: 0),
        );
      }).toList(),
    );
  }

  Widget _buildPlanSelector(bool isDark) {
    return Obx(() => Column(
          children: controller.plans.asMap().entries.map((entry) {
            final i = entry.key;
            final plan = entry.value;
            final isSelected = controller.selectedPlan.value == plan['id'];

            return GestureDetector(
              onTap: () => controller.selectPlan(plan['id'] as String),
              child: AnimatedContainer(
                duration: AppConstants.animFast,
                margin: const EdgeInsets.only(
                    bottom: AppConstants.spacingMd),
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? AppColors.white : AppColors.black)
                      : (isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface),
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusLg),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                plan['label'] as String,
                                style:
                                    AppTypography.titleSmallDark.copyWith(
                                  color: isSelected
                                      ? (isDark
                                          ? AppColors.black
                                          : AppColors.white)
                                      : (isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary),
                                ),
                              ),
                              if (plan['savings'] != null) ...[
                                const SizedBox(
                                    width: AppConstants.spacingSm),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? (isDark
                                            ? AppColors.gray200
                                            : AppColors.gray700)
                                        : (isDark
                                            ? AppColors.gray700
                                            : AppColors.gray200),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusXs),
                                  ),
                                  child: Text(
                                    plan['savings'] as String,
                                    style: AppTypography.labelSmallDark
                                        .copyWith(
                                      color: isSelected
                                          ? (isDark
                                              ? AppColors.black
                                              : AppColors.white)
                                          : (isDark
                                              ? AppColors.gray300
                                              : AppColors.gray600),
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            plan['description'] as String,
                            style: AppTypography.bodySmallDark.copyWith(
                              color: isSelected
                                  ? (isDark
                                      ? AppColors.gray600
                                      : AppColors.gray400)
                                  : (isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: plan['price'] as String,
                            style: AppTypography.titleLargeDark.copyWith(
                              color: isSelected
                                  ? (isDark
                                      ? AppColors.black
                                      : AppColors.white)
                                  : (isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary),
                            ),
                          ),
                          if ((plan['period'] as String).isNotEmpty)
                            TextSpan(
                              text: plan['period'] as String,
                              style:
                                  AppTypography.bodySmallDark.copyWith(
                                color: isSelected
                                    ? (isDark
                                        ? AppColors.gray600
                                        : AppColors.gray400)
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  .animate(
                      delay: Duration(milliseconds: 300 + i * 80))
                  .fadeIn()
                  .slideY(begin: 0.05, end: 0),
            );
          }).toList(),
        ));
  }
}
