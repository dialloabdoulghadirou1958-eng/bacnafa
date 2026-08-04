import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/design/app_spacing.dart';
import '../../core/design/app_radius.dart';
import 'package:bac_nafa/core/widgets/app_card_premium.dart';

class AppSelectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const AppSelectionCard({
    super.key,
    required this.title,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primary;

    return AnimatedScale(
      scale: isSelected ? 1.02 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: GestureDetector(
        onTap: onTap,
        child: AppCardPremium(
          padding: EdgeInsets.zero,
          shadows: isSelected ? [
            BoxShadow(
              color: activeColor.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ] : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.large),
              border: Border.all(
                color: isSelected ? activeColor : AppColors.outline,
                width: isSelected ? 2 : 1,
              ),
            ),
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? activeColor.withValues(alpha: 0.1) : AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? activeColor : AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: isSelected ? AppColors.textPrimary : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: activeColor, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}