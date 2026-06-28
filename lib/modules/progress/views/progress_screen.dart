import 'package:fl_chart/fl_chart.dart';
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
import '../controllers/progress_controller.dart';

class ProgressScreen extends GetView<ProgressController> {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Progress',
          style: AppTypography.titleLargeDark.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_rounded,
                color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
            onPressed: () => _showAddWeightSheet(context, isDark),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.spacingXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Stats Overview ─────────────────────────────────────
                _buildStatsRow(isDark),
                const SizedBox(height: AppConstants.spacingXl),

                // ── Period Filter ──────────────────────────────────────
                _buildPeriodFilter(isDark),
                const SizedBox(height: AppConstants.spacingXl),

                // ── Weight Chart ───────────────────────────────────────
                _buildWeightChart(isDark),
                const SizedBox(height: AppConstants.spacingXl),

                // ── Weight History ─────────────────────────────────────
                _buildWeightHistory(isDark),
                const SizedBox(height: AppConstants.spacingXl),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Current',
                value: controller.latestLog != null
                    ? '${controller.latestLog!.weight}kg'
                    : '--',
                icon: Icons.monitor_weight_outlined,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _StatCard(
                label: 'Change',
                value: controller.weightChange != null
                    ? '${controller.weightChange! >= 0 ? '+' : ''}${controller.weightChange!.toStringAsFixed(1)}kg'
                    : '--',
                icon: Icons.trending_up_rounded,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: _StatCard(
                label: 'BMI',
                value: controller.currentBMI != null
                    ? controller.currentBMI!.toStringAsFixed(1)
                    : '--',
                icon: Icons.accessibility_new_rounded,
                isDark: isDark,
              ),
            ),
          ],
        ).animate().fadeIn());
  }

  Widget _buildPeriodFilter(bool isDark) {
    final periods = ['weekly', 'monthly', 'yearly'];
    return Row(
      children: periods.map((period) {
        return Obx(() {
          final isSelected = controller.selectedPeriod.value == period;
          return GestureDetector(
            onTap: () => controller.changePeriod(period),
            child: AnimatedContainer(
              duration: AppConstants.animFast,
              margin: const EdgeInsets.only(right: AppConstants.spacingSm),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.white : AppColors.black)
                    : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusFull),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Text(
                period[0].toUpperCase() + period.substring(1),
                style: AppTypography.labelSmallDark.copyWith(
                  color: isSelected
                      ? (isDark ? AppColors.black : AppColors.white)
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
                ),
              ),
            ),
          );
        });
      }).toList(),
    );
  }

  Widget _buildWeightChart(bool isDark) {
    return Obx(() {
      final logs = controller.filteredLogs;

      if (logs.isEmpty) {
        return AppCard(
          child: SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart_rounded,
                      size: 48,
                      color: isDark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary),
                  const SizedBox(height: AppConstants.spacingMd),
                  Text(
                    'No data yet\nLog your weight to see progress',
                    style: AppTypography.bodyMediumDark.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }

      final spots = logs.asMap().entries.map((entry) {
        return FlSpot(
            entry.key.toDouble(), entry.value.weight);
      }).toList();

      final minY = logs
              .map((l) => l.weight)
              .reduce((a, b) => a < b ? a : b) -
          2;
      final maxY = logs
              .map((l) => l.weight)
              .reduce((a, b) => a > b ? a : b) +
          2;

      return AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weight Progress',
              style: AppTypography.titleMediumDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingXl),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: isDark
                          ? AppColors.gray700
                          : AppColors.gray200,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}',
                          style: AppTypography.bodySmallDark.copyWith(
                            color: isDark
                                ? AppColors.darkTextTertiary
                                : AppColors.lightTextTertiary,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: logs.length <= 7,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= logs.length) {
                            return const SizedBox.shrink();
                          }
                          final date = logs[idx].date;
                          return Text(
                            '${date.day}/${date.month}',
                            style: AppTypography.bodySmallDark.copyWith(
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minY: minY,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: isDark ? AppColors.white : AppColors.black,
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                          radius: 3,
                          color: isDark
                              ? AppColors.white
                              : AppColors.black,
                          strokeWidth: 0,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            (isDark ? AppColors.white : AppColors.black)
                                .withOpacity(0.15),
                            (isDark ? AppColors.white : AppColors.black)
                                .withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).animate(delay: 100.ms).fadeIn();
    });
  }

  Widget _buildWeightHistory(bool isDark) {
    return Obx(() {
      if (controller.weightLogs.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'History',
            style: AppTypography.titleMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ...controller.weightLogs.take(10).map((log) {
            return Dismissible(
              key: Key(log.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => controller.deleteWeightLog(log.id),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(
                    right: AppConstants.spacingXl),
                color: AppColors.error,
                child: const Icon(Icons.delete_outline_rounded,
                    color: Colors.white),
              ),
              child: Container(
                margin: const EdgeInsets.only(
                    bottom: AppConstants.spacingSm),
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightSurface,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${log.date.day}/${log.date.month}/${log.date.year}',
                            style: AppTypography.bodySmallDark.copyWith(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                          if (log.notes != null)
                            Text(
                              log.notes!,
                              style: AppTypography.bodySmallDark.copyWith(
                                color: isDark
                                    ? AppColors.darkTextTertiary
                                    : AppColors.lightTextTertiary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${log.weight}kg',
                          style: AppTypography.titleSmallDark.copyWith(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        if (log.bmi != null)
                          Text(
                            'BMI ${log.bmi!.toStringAsFixed(1)}',
                            style: AppTypography.bodySmallDark.copyWith(
                              color: isDark
                                  ? AppColors.darkTextTertiary
                                  : AppColors.lightTextTertiary,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      );
    });
  }

  void _showAddWeightSheet(BuildContext context, bool isDark) {
    Get.bottomSheet(
      _AddWeightSheet(isDark: isDark),
      isScrollControlled: true,
      backgroundColor:
          isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusXl)),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Icon(icon,
              size: 20,
              color: isDark ? AppColors.darkIcon : AppColors.lightIcon),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            value,
            style: AppTypography.titleMediumDark.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          Text(
            label,
            style: AppTypography.bodySmallDark.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddWeightSheet extends GetView<ProgressController> {
  final bool isDark;

  const _AddWeightSheet({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppConstants.spacingXl,
        right: AppConstants.spacingXl,
        top: AppConstants.spacingXl,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            AppConstants.spacingXl,
      ),
      child: Form(
        key: controller.addWeightFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log Weight',
              style: AppTypography.titleLargeDark.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.spacingXl),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Weight (kg)',
                    hint: '70.0',
                    controller: controller.weightController,
                    keyboardType: TextInputType.number,
                    validator: Validators.positiveNumber,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: AppTextField(
                    label: 'Body Fat % (optional)',
                    hint: '15.0',
                    controller: controller.bodyFatController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMd),
            AppTextField(
              label: 'Notes (optional)',
              hint: 'e.g. After morning workout',
              controller: controller.notesController,
            ),
            const SizedBox(height: AppConstants.spacingXl),
            Obx(() => AppButton(
                  label: 'Save',
                  onPressed: controller.addWeightLog,
                  isLoading: controller.isSavingWeight.value,
                )),
          ],
        ),
      ),
    );
  }
}
