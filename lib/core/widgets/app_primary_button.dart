import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/design/app_spacing.dart';
import '../../core/design/app_radius.dart';
import '../../core/design/app_dimensions.dart';

class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool outlined;
  final double? width;

  const AppPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.outlined = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? AppColors.primary;
    final effectiveFgColor = foregroundColor ?? AppColors.onPrimary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      width: width ?? double.infinity,
      height: AppDimensions.buttonHeight,
      child: outlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: effectiveBgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                side: BorderSide(color: effectiveBgColor, width: 1.5),
              ),
              child: _buildChild(effectiveBgColor),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: effectiveBgColor,
                foregroundColor: effectiveFgColor,
                disabledBackgroundColor: AppColors.surfaceContainerHigh,
                disabledForegroundColor: AppColors.textTertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
                elevation: 0,
              ),
              child: _buildChild(effectiveFgColor),
            ),
    );
  }

  Widget _buildChild(Color spinnerColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: spinnerColor,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: AppDimensions.iconMedium),
          SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.buttonText.copyWith(
              color: outlined ? spinnerColor : AppTextStyles.buttonText.color,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}