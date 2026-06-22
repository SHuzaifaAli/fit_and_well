import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

/// Forgot password screen
class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Form(
            key: controller.forgotPasswordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.gray800 : AppColors.gray100,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: 28,
                    color: isDark ? AppColors.gray300 : AppColors.gray600,
                  ),
                ).animate().fadeIn().scale(
                      begin: const Offset(0.8, 0.8),
                      duration: AppConstants.animNormal,
                    ),

                const SizedBox(height: AppConstants.spacingXl),

                Text(
                  'Reset password',
                  style: AppTypography.displaySmallDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ).animate(delay: 100.ms).fadeIn(),

                const SizedBox(height: AppConstants.spacingSm),

                Text(
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  style: AppTypography.bodyMediumDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ).animate(delay: 150.ms).fadeIn(),

                const SizedBox(height: AppConstants.spacingXxl),

                AppTextField(
                  label: 'Email',
                  hint: 'your@email.com',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: Validators.email,
                  prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                ).animate(delay: 200.ms).fadeIn(),

                const SizedBox(height: AppConstants.spacingXl),

                Obx(() => AppButton(
                      label: 'Send Reset Link',
                      onPressed: controller.sendPasswordResetEmail,
                      isLoading: controller.isLoading.value,
                    )).animate(delay: 250.ms).fadeIn(),

                const SizedBox(height: AppConstants.spacingMd),

                Obx(() {
                  if (controller.errorMessage.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    controller.errorMessage.value,
                    style: AppTypography.bodySmallDark.copyWith(
                      color: AppColors.errorLight,
                    ),
                    textAlign: TextAlign.center,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
