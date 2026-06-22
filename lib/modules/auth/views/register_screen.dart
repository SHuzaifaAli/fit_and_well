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

/// Registration screen for new users
class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Form(
            key: controller.registerFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  'Create account',
                  style: AppTypography.displaySmallDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ).animate().fadeIn().slideX(begin: -0.1, end: 0),

                const SizedBox(height: AppConstants.spacingXs),

                Text(
                  'Start your fitness transformation today',
                  style: AppTypography.bodyMediumDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ).animate(delay: 50.ms).fadeIn(),

                const SizedBox(height: AppConstants.spacingXxl),

                // Name Field
                AppTextField(
                  label: 'Full Name',
                  hint: 'John Doe',
                  controller: controller.nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  validator: Validators.name,
                  prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppConstants.spacingMd),

                // Email Field
                AppTextField(
                  label: 'Email',
                  hint: 'your@email.com',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                  prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppConstants.spacingMd),

                // Password Field
                AppTextField(
                  label: 'Password',
                  hint: 'Min. 8 characters with uppercase & number',
                  controller: controller.passwordController,
                  obscureText: true,
                  textInputAction: TextInputAction.next,
                  validator: Validators.password,
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppConstants.spacingMd),

                // Confirm Password Field
                AppTextField(
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  controller: controller.confirmPasswordController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    controller.passwordController.text,
                  ),
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppConstants.spacingXl),

                // Error Message
                Obx(() {
                  if (controller.errorMessage.value.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    margin:
                        const EdgeInsets.only(bottom: AppConstants.spacingMd),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusMd),
                      border: Border.all(
                          color: AppColors.errorLight.withOpacity(0.3)),
                    ),
                    child: Text(
                      controller.errorMessage.value,
                      style: AppTypography.bodySmallDark.copyWith(
                        color: AppColors.errorLight,
                      ),
                    ),
                  );
                }),

                // Sign Up Button
                Obx(() => AppButton(
                      label: 'Create Account',
                      onPressed: controller.signUpWithEmail,
                      isLoading: controller.isLoading.value,
                    )).animate(delay: 300.ms).fadeIn(),

                const SizedBox(height: AppConstants.spacingXl),

                // Terms
                Center(
                  child: Text(
                    'By creating an account, you agree to our\nTerms of Service and Privacy Policy',
                    style: AppTypography.bodySmallDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ).animate(delay: 350.ms).fadeIn(),

                const SizedBox(height: AppConstants.spacingXl),

                // Sign In Link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTypography.bodyMediumDark.copyWith(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Text(
                          'Sign In',
                          style: AppTypography.labelLargeDark.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate(delay: 400.ms).fadeIn(),

                const SizedBox(height: AppConstants.spacingMd),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
