import 'package:flutter/material.dart';
import '../core/themes/app_colors.dart';
import '../core/constants/app_constants.dart';

/// Consistent card widget with monochromatic styling
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double? borderRadius;
  final Color? backgroundColor;
  final bool showBorder;
  final bool elevated;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius,
    this.backgroundColor,
    this.showBorder = true,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.darkCard : AppColors.lightCard);
    final borderColor =
        isDark ? AppColors.darkBorderSubtle : AppColors.lightBorder;
    final radius = borderRadius ?? AppConstants.radiusLg;

    final container = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: showBorder
            ? Border.all(color: borderColor, width: 1)
            : null,
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: AppColors.blackWithOpacity(isDark ? 0.3 : 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppConstants.spacingMd),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }

    return container;
  }
}

/// Gradient card for hero sections
class GradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final List<Color>? gradientColors;
  final VoidCallback? onTap;
  final double? borderRadius;

  const GradientCard({
    super.key,
    required this.child,
    this.padding,
    this.gradientColors,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = gradientColors ??
        (isDark
            ? [AppColors.gray800, AppColors.gray900]
            : [AppColors.gray100, AppColors.white]);

    final container = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius:
            BorderRadius.circular(borderRadius ?? AppConstants.radiusLg),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppConstants.spacingMd),
        child: child,
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: container);
    }

    return container;
  }
}
