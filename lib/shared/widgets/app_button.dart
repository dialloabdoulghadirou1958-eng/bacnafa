import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return isPrimary
        ? ElevatedButton.icon(
            onPressed: onPressed,
            icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
            label: Text(text),
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: icon != null ? Icon(icon, size: 18) : const SizedBox.shrink(),
            label: Text(text),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
  }
}
