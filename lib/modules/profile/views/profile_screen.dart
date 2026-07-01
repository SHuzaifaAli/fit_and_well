import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_button.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Profile',
          style: AppTypography.titleLargeDark.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_rounded,
                color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Header ─────────────────────────────────────────
            Obx(() {
              final user = auth.currentUser.value;
              if (user == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return AppCard(
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.gray700 : AppColors.gray200,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusFull),
                      ),
                      child: Icon(Icons.person_rounded,
                          size: 32,
                          color: isDark
                              ? AppColors.gray400
                              : AppColors.gray500),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: AppTypography.titleSmallDark.copyWith(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            user.email,
                            style: AppTypography.bodySmallDark.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).animate().fadeIn().slideY(begin: 0.05, end: 0),

            const SizedBox(height: AppConstants.spacingXl),

            // ── Actions ────────────────────────────────────────────────
            Text(
              'Account',
              style: AppTypography.titleMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMd),

            AppButton(
              label: 'Edit Profile',
              onPressed: () => Get.toNamed(AppRoutes.editProfile),
              suffixIcon: Icons.edit_rounded,
            ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.05, end: 0),

            const SizedBox(height: AppConstants.spacingMd),

            AppButton(
              label: 'View Subscription',
              onPressed: () => Get.toNamed(AppRoutes.subscription),
              variant: AppButtonVariant.outline,
            ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.05, end: 0),

            const SizedBox(height: AppConstants.spacingXl),

            // ── Sign Out ───────────────────────────────────────────────
            AppButton(
              label: 'Sign Out',
              onPressed: () => auth.signOut(),
              variant: AppButtonVariant.outline,
            ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.05, end: 0),

            const SizedBox(height: AppConstants.spacingXl),
          ],
        ),
      ),
    );
  }
}
