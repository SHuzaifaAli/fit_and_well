import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../controllers/auth_controller.dart';

/// Login screen with email/password and social sign-in options
class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height - 100),
            child: IntrinsicHeight(
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppConstants.spacingXl),

                    // Logo
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.white : AppColors.black,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusMd),
                      ),
                      child: Icon(
                        Icons.fitness_center_rounded,
                        size: 26,
                        color: isDark ? AppColors.black : AppColors.white,
                      ),
                    ).animate().fadeIn().scale(
                          begin: const Offset(0.8, 0.8),
                          duration: AppConstants.animNormal,
                        ),

                    const SizedBox(height: AppConstants.spacingXl),

                    // Title
                    Text(
                      'Welcome back',
                      style: AppTypography.displaySmallDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    )
                        .animate(delay: 100.ms)
                        .fadeIn()
                        .slideX(begin: -0.1, end: 0),

                    const SizedBox(height: AppConstants.spacingXs),

                    Text(
                      'Sign in to continue your fitness journey',
                      style: AppTypography.bodyMediumDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ).animate(delay: 150.ms).fadeIn(),

                    const SizedBox(height: AppConstants.spacingXxl),

                    // Email Field
                    AppTextField(
                      label: 'Email',
                      hint: 'your@email.com',
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validators.email,
                      prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20),
                    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),

                    const SizedBox(height: AppConstants.spacingMd),

                    // Password Field
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: controller.passwordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                    ).animate(delay: 250.ms).fadeIn().slideY(begin: 0.1, end: 0),

                    const SizedBox(height: AppConstants.spacingSm),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            Get.toNamed(AppRoutes.forgotPassword),
                        child: Text(
                          'Forgot password?',
                          style: AppTypography.labelMediumDark.copyWith(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ).animate(delay: 300.ms).fadeIn(),

                    const SizedBox(height: AppConstants.spacingMd),

                    // Error Message
                    Obx(() {
                      if (controller.errorMessage.value.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        padding: const EdgeInsets.all(AppConstants.spacingMd),
                        margin: const EdgeInsets.only(
                            bottom: AppConstants.spacingMd),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusMd),
                          border: Border.all(
                              color: AppColors.errorLight.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              size: 16,
                              color: AppColors.errorLight,
                            ),
                            const SizedBox(width: AppConstants.spacingSm),
                            Expanded(
                              child: Text(
                                controller.errorMessage.value,
                                style: AppTypography.bodySmallDark.copyWith(
                                  color: AppColors.errorLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    // Sign In Button
                    Obx(() => AppButton(
                          label: 'Sign In',
                          onPressed: controller.signInWithEmail,
                          isLoading: controller.isLoading.value,
                        )).animate(delay: 350.ms).fadeIn(),

                    const SizedBox(height: AppConstants.spacingXl),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.spacingMd),
                          child: Text(
                            'or continue with',
                            style: AppTypography.labelSmallDark.copyWith(
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: isDark
                                ? AppColors.darkDivider
                                : AppColors.lightDivider,
                          ),
                        ),
                      ],
                    ).animate(delay: 400.ms).fadeIn(),

                    const SizedBox(height: AppConstants.spacingXl),

                    // Google Sign In
                    Obx(() => SocialSignInButton(
                          label: 'Continue with Google',
                          iconPath: 'assets/icons/google.png',
                          onPressed: controller.signInWithGoogle,
                          isLoading: controller.isLoading.value,
                        )).animate(delay: 450.ms).fadeIn(),

                    // Apple Sign In (iOS only)
                    if (Platform.isIOS) ...[
                      const SizedBox(height: AppConstants.spacingMd),
                      Obx(() => SocialSignInButton(
                            label: 'Continue with Apple',
                            iconPath: 'assets/icons/apple.png',
                            onPressed: controller.signInWithApple,
                            isLoading: controller.isLoading.value,
                          )).animate(delay: 500.ms).fadeIn(),
                    ],

                    const Spacer(),

                    // Register Link
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: AppTypography.bodyMediumDark.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.register),
                            child: Text(
                              'Sign Up',
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
                    ).animate(delay: 550.ms).fadeIn(),

                    const SizedBox(height: AppConstants.spacingMd),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
