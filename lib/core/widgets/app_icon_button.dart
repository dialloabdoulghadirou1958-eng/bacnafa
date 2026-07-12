import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/design/app_radius.dart';
import '../../core/design/app_dimensions.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double? size;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.backgroundColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size ?? AppDimensions.iconLarge * 2,
      height: size ?? AppDimensions.iconLarge * 2,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        color: color ?? AppColors.textPrimary,
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.surfaceVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
        ),
      ),
    );
  }
}
