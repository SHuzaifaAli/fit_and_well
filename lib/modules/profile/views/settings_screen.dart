import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_typography.dart';
import '../../../widgets/app_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = Get.find<StorageService>();
  late String _themeMode;
  bool _workoutReminders = true;
  bool _nutritionReminders = true;

  @override
  void initState() {
    super.initState();
    _themeMode = _storage.themeMode;
    _workoutReminders = _storage.getBool('notif_workout') ?? true;
    _nutritionReminders = _storage.getBool('notif_nutrition') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Settings',
          style: AppTypography.titleLargeDark.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        children: [
          // ── Theme ──────────────────────────────────────────────────────
          _buildSectionLabel('Appearance', isDark),
          const SizedBox(height: AppConstants.spacingMd),
          AppCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Theme',
                  style: AppTypography.bodyMediumDark.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                DropdownButton<String>(
                  value: _themeMode,
                  items: const [
                    DropdownMenuItem(value: 'system', child: Text('System')),
                    DropdownMenuItem(value: 'light', child: Text('Light')),
                    DropdownMenuItem(value: 'dark', child: Text('Dark')),
                  ],
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() => _themeMode = value);
                      await _storage.setThemeMode(value);
                      Get.changeThemeMode(value == 'dark'
                          ? ThemeMode.dark
                          : value == 'light'
                              ? ThemeMode.light
                              : ThemeMode.system);
                    }
                  },
                ),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms),

          const SizedBox(height: AppConstants.spacingXl),

          // ── Notifications ──────────────────────────────────────────────
          _buildSectionLabel('Notifications', isDark),
          const SizedBox(height: AppConstants.spacingMd),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMd,
                    vertical: AppConstants.spacingMd,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Workout Reminders',
                        style: AppTypography.bodyMediumDark.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Switch(
                        value: _workoutReminders,
                        onChanged: (value) async {
                          setState(() => _workoutReminders = value);
                          await _storage.setBool('notif_workout', value);
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  indent: AppConstants.spacingMd,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMd,
                    vertical: AppConstants.spacingMd,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nutrition Reminders',
                        style: AppTypography.bodyMediumDark.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Switch(
                        value: _nutritionReminders,
                        onChanged: (value) async {
                          setState(() => _nutritionReminders = value);
                          await _storage.setBool('notif_nutrition', value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate(delay: 150.ms).fadeIn(),

          const SizedBox(height: AppConstants.spacingXl),

          // ── About ───────────────────────────────────────────────────────
          _buildSectionLabel('About', isDark),
          const SizedBox(height: AppConstants.spacingMd),
          AppCard(
            child: Text(
              'Version ${AppConstants.appVersion} (Build ${AppConstants.appBuildNumber})',
              style: AppTypography.bodyMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ).animate(delay: 200.ms).fadeIn(),
        ],
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
}
