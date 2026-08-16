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

    return AppCardPremium(
      onTap: onTap,
      padding: EdgeInsets.zero,
      border: BorderSide(
        color: isSelected ? activeColor : AppColors.outlineVariant,
        width: isSelected ? 1.8 : 1,
      ),
      shadows: isSelected
          ? [
              BoxShadow(
                color: activeColor.withValues(alpha: 0.20),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -5,
              ),
            ]
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.045) : null,
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      activeColor.withValues(alpha: isSelected ? 0.18 : 0.11),
                      activeColor.withValues(alpha: isSelected ? 0.09 : 0.05),
                    ],
                  ),
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
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
            AnimatedScale(
              scale: isSelected ? 1 : 0.7,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                opacity: isSelected ? 1 : 0,
                duration: const Duration(milliseconds: 120),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: activeColor,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
