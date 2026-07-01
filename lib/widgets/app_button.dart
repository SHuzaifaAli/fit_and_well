import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/themes/app_colors.dart';
import '../core/themes/app_typography.dart';
import '../core/constants/app_constants.dart';

enum AppButtonVariant { filled, outline, ghost }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final AppButtonVariant variant;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.height = 52,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.variant = AppButtonVariant.filled,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isActive = !isLoading && !isDisabled && onPressed != null;

    Color bgColor;
    Color fgColor;
    BoxBorder? border;

    switch (variant) {
      case AppButtonVariant.filled:
        bgColor = backgroundColor ?? (isDark ? AppColors.white : AppColors.black);
        fgColor = textColor ?? (isDark ? AppColors.black : AppColors.white);
        border = null;
        break;
      case AppButtonVariant.outline:
        bgColor = Colors.transparent;
        fgColor = textColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);
        border = Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1.5,
        );
        break;
      case AppButtonVariant.ghost:
        bgColor = Colors.transparent;
        fgColor = textColor ?? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);
        border = null;
        break;
    }

    if (!isActive) {
      if (variant == AppButtonVariant.filled) {
        bgColor = isDark ? AppColors.gray700 : AppColors.gray200;
      }
      fgColor = isDark ? AppColors.gray500 : AppColors.gray400;
    }

    Widget buildChild() {
      if (isLoading) {
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(fgColor),
          ),
        );
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null) ...[
            Icon(prefixIcon, size: 18, color: fgColor),
            const SizedBox(width: AppConstants.spacingSm),
          ],
          if (icon != null) ...[
            icon!,
            const SizedBox(width: AppConstants.spacingSm),
          ],
          Text(
            label,
            style: AppTypography.labelLargeDark.copyWith(
              color: fgColor,
              fontWeight: AppTypography.weightSemiBold,
            ),
          ),
          if (suffixIcon != null) ...[
            const SizedBox(width: AppConstants.spacingSm),
            Icon(suffixIcon, size: 18, color: fgColor),
          ],
        ],
      );
    }

    return GestureDetector(
      onTap: isActive ? onPressed : null,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        width: width ?? double.infinity,
        height: height,
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLg,
          vertical: AppConstants.spacingMd,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius ?? AppConstants.radiusMd),
          border: border,
        ),
        child: Center(child: buildChild()),
      ),
    ).animate().fadeIn(duration: AppConstants.animFast);
  }
}

class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final double? width;
  final double height;
  final Color? borderColor;
  final Color? textColor;

  const AppOutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      width: width,
      height: height,
      textColor: textColor,
      variant: AppButtonVariant.outline,
    );
  }
}

class SocialSignInButton extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialSignInButton({
    super.key,
    required this.label,
    required this.iconPath,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
          foregroundColor: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
        ),
        child: isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(iconPath, width: 20, height: 20),
                  const SizedBox(width: AppConstants.spacingMd),
                  Text(
                    label,
                    style: AppTypography.labelLargeDark.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
