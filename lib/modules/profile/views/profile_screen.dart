import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../core/utils/fitness_calculator.dart';
import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authController = Get.find<AuthController>();

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
            icon: Icon(Icons.settings_outlined,
                color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: Obx(() {
        final user = authController.currentUser.value;
        if (user == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingXl),
          child: Column(
            children: [
              // ── Avatar & Name ──────────────────────────────────────────
              _buildAvatarSection(isDark, user, authController),
              const SizedBox(height: AppConstants.spacingXl),

              // ── Subscription Badge ─────────────────────────────────────
              if (!user.isPremium)
                _buildUpgradeBanner(isDark)
                    .animate()
                    .fadeIn(delay: 100.ms),

              const SizedBox(height: AppConstants.spacingXl),

              // ── Body Stats ─────────────────────────────────────────────
              _buildStatsGrid(isDark, user),
              const SizedBox(height: AppConstants.spacingXl),

              // ── BMR / TDEE Card ────────────────────────────────────────
              if (user.isProfileComplete)
                _buildMetabolismCard(isDark, user),

              const SizedBox(height: AppConstants.spacingXl),

              // ── Menu Items ─────────────────────────────────────────────
              _buildMenuSection(isDark),
              const SizedBox(height: AppConstants.spacingXl),

              // ── Sign Out ───────────────────────────────────────────────
              AppButton(
                label: 'Sign Out',
                onPressed: () => _confirmSignOut(authController),
                variant: AppButtonVariant.outline,
              ),
              const SizedBox(height: AppConstants.spacingMd),

              Text(
                '${AppConstants.appName} v${AppConstants.appVersion}',
                style: AppTypography.bodySmallDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingXl),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAvatarSection(isDark, user, authController) {
    return Column(
      children: [
        GestureDetector(
          onTap: controller.pickAndUploadAvatar,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor:
                    isDark ? AppColors.gray700 : AppColors.gray200,
                backgroundImage: user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl!)
                    : null,
                child: user.avatarUrl == null
                    ? Text(
                        user.name.isNotEmpty
                            ? user.name[0].toUpperCase()
                            : 'U',
                        style: AppTypography.headlineMediumDark.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.white : AppColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: isDark ? AppColors.black : AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8)),
        const SizedBox(height: AppConstants.spacingMd),
        Text(
          user.name,
          style: AppTypography.headlineSmallDark.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ).animate(delay: 50.ms).fadeIn(),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: AppTypography.bodyMediumDark.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ).animate(delay: 100.ms).fadeIn(),
        const SizedBox(height: AppConstants.spacingMd),
        OutlinedButton(
          onPressed: () => Get.toNamed(AppRoutes.editProfile),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.radiusMd),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingXl,
                vertical: AppConstants.spacingSm),
          ),
          child: Text(
            'Edit Profile',
            style: AppTypography.labelMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ).animate(delay: 150.ms).fadeIn(),
      ],
    );
  }

  Widget _buildUpgradeBanner(bool isDark) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.subscription),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray800 : AppColors.gray100,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: isDark ? AppColors.gray600 : AppColors.gray300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              color: isDark ? AppColors.gray300 : AppColors.gray600,
              size: 20,
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upgrade to Premium',
                    style: AppTypography.labelLargeDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    'Unlock AI Coach, advanced analytics & more',
                    style: AppTypography.bodySmallDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(bool isDark, user) {
    final stats = [
      if (user.age != null) _StatItem('Age', '${user.age}', 'yrs'),
      if (user.weight != null)
        _StatItem('Weight', '${user.weight!.toStringAsFixed(1)}', 'kg'),
      if (user.height != null)
        _StatItem('Height', '${user.height!.toStringAsFixed(0)}', 'cm'),
      if (user.weight != null && user.height != null)
        _StatItem(
          'BMI',
          FitnessCalculator.calculateBMI(
                  weight: user.weight!, height: user.height!)
              .toStringAsFixed(1),
          FitnessCalculator.getBMICategory(
              FitnessCalculator.calculateBMI(
                  weight: user.weight!, height: user.height!)),
        ),
    ];

    if (stats.isEmpty) {
      return AppCard(
        child: Center(
          child: Column(
            children: [
              Icon(Icons.person_outline_rounded,
                  size: 40,
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                'Complete your profile to see stats',
                style: AppTypography.bodyMediumDark.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),
              TextButton(
                onPressed: () => Get.toNamed(AppRoutes.editProfile),
                child: const Text('Complete Profile'),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppConstants.spacingMd,
      mainAxisSpacing: AppConstants.spacingMd,
      childAspectRatio: 1.6,
      children: stats
          .map((s) => AppCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s.value,
                      style: AppTypography.headlineSmallDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      s.unit,
                      style: AppTypography.bodySmallDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.label,
                      style: AppTypography.labelSmallDark.copyWith(
                        color: isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.lightTextTertiary,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    ).animate(delay: 200.ms).fadeIn();
  }

  Widget _buildMetabolismCard(bool isDark, user) {
    final bmr = FitnessCalculator.calculateBMR(
      weight: user.weight!,
      height: user.height!,
      age: user.age!,
      gender: user.gender ?? 'male',
    );
    final tdee = FitnessCalculator.calculateTDEE(
      bmr: bmr,
      activityLevel: user.activityLevel ?? 'moderate',
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metabolism',
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
                child: _MetricTile(
                  label: 'BMR',
                  value: '${bmr.toStringAsFixed(0)} kcal',
                  subtitle: 'Base metabolic rate',
                  isDark: isDark,
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              ),
              Expanded(
                child: _MetricTile(
                  label: 'TDEE',
                  value: '${tdee.toStringAsFixed(0)} kcal',
                  subtitle: 'Daily calories needed',
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: 300.ms).fadeIn();
  }

  Widget _buildMenuSection(bool isDark) {
    final items = [
      _MenuItem(
        icon: Icons.edit_outlined,
        label: 'Edit Profile',
        route: AppRoutes.editProfile,
      ),
      _MenuItem(
        icon: Icons.flag_outlined,
        label: 'My Goals',
        route: AppRoutes.goalSetup,
      ),
      _MenuItem(
        icon: Icons.workspace_premium_outlined,
        label: 'Subscription',
        route: AppRoutes.subscription,
      ),
      _MenuItem(
        icon: Icons.notifications_outlined,
        label: 'Notifications',
        route: AppRoutes.settings,
      ),
      _MenuItem(
        icon: Icons.help_outline_rounded,
        label: 'Help & Support',
        route: AppRoutes.settings,
      ),
      _MenuItem(
        icon: Icons.privacy_tip_outlined,
        label: 'Privacy Policy',
        route: AppRoutes.settings,
      ),
    ];

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                leading: Icon(
                  item.icon,
                  size: 20,
                  color: isDark ? AppColors.darkIcon : AppColors.lightIcon,
                ),
                title: Text(
                  item.label,
                  style: AppTypography.bodyMediumDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
                onTap: () => Get.toNamed(item.route),
              ),
              if (i < items.length - 1)
                Divider(
                  height: 1,
                  indent: 56,
                  color: isDark
                      ? AppColors.darkDivider
                      : AppColors.lightDivider,
                ),
            ],
          );
        }).toList(),
      ),
    ).animate(delay: 400.ms).fadeIn();
  }

  void _confirmSignOut(AuthController authController) {
    Get.dialog(
      AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              authController.signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final String unit;
  _StatItem(this.label, this.value, this.unit);
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String route;
  _MenuItem({required this.icon, required this.label, required this.route});
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final bool isDark;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.labelSmallDark.copyWith(
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.lightTextTertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.titleMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          Text(
            subtitle,
            style: AppTypography.bodySmallDark.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
