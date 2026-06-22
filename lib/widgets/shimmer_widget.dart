import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/themes/app_colors.dart';
import '../core/constants/app_constants.dart';

/// Shimmer loading placeholder widgets
class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final ShapeDecoration? shape;

  const ShimmerWidget.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppConstants.radiusSm,
  }) : shape = null;

  const ShimmerWidget.circular({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        borderRadius = size / 2,
        shape = null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkShimmerBase : AppColors.lightShimmerBase,
      highlightColor: isDark
          ? AppColors.darkShimmerHighlight
          : AppColors.lightShimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer for workout card
class WorkoutCardShimmer extends StatelessWidget {
  const WorkoutCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCard
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkBorderSubtle
              : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.rectangular(
            width: double.infinity,
            height: 140,
            borderRadius: AppConstants.radiusMd,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          ShimmerWidget.rectangular(width: 200, height: 18),
          const SizedBox(height: AppConstants.spacingSm),
          ShimmerWidget.rectangular(width: 140, height: 14),
          const SizedBox(height: AppConstants.spacingMd),
          Row(
            children: [
              ShimmerWidget.rectangular(width: 80, height: 28),
              const SizedBox(width: AppConstants.spacingSm),
              ShimmerWidget.rectangular(width: 80, height: 28),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shimmer for nutrition log item
class NutritionItemShimmer extends StatelessWidget {
  const NutritionItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingSm),
      child: Row(
        children: [
          ShimmerWidget.circular(size: 48),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget.rectangular(width: 160, height: 16),
                const SizedBox(height: AppConstants.spacingXs),
                ShimmerWidget.rectangular(width: 100, height: 12),
              ],
            ),
          ),
          ShimmerWidget.rectangular(width: 60, height: 16),
        ],
      ),
    );
  }
}

/// Shimmer for progress stat card
class StatCardShimmer extends StatelessWidget {
  const StatCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkCard
            : AppColors.lightCard,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkBorderSubtle
              : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget.rectangular(width: 80, height: 12),
          const SizedBox(height: AppConstants.spacingSm),
          ShimmerWidget.rectangular(width: 100, height: 28),
          const SizedBox(height: AppConstants.spacingXs),
          ShimmerWidget.rectangular(width: 60, height: 12),
        ],
      ),
    );
  }
}
