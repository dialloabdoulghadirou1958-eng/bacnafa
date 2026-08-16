import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/design/app_radius.dart';

class AppProgressIndicator extends StatelessWidget {
  final double progress;
  final String label;
  final Color? color;
  final Color? trackColor;

  const AppProgressIndicator({
    super.key,
    required this.progress,
    required this.label,
    this.color,
    this.trackColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primary;
    final effectiveTrackColor = trackColor ?? AppColors.surfaceContainerHighest;
    final safeProgress = progress.clamp(0.0, 1.0).toDouble();
    final gradientEnd = Color.lerp(effectiveColor, AppColors.tertiary, 0.18) ??
        effectiveColor;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: safeProgress),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Semantics(
        label: '$label ${(value * 100).round()}%',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: AppTextStyles.titleMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: effectiveColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                  ),
                  child: Text(
                    '${(value * 100).round()}%',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: effectiveColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 10,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: effectiveTrackColor,
                borderRadius: BorderRadius.circular(AppRadius.circular),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: value,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [effectiveColor, gradientEnd],
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.circular),
                      boxShadow: [
                        BoxShadow(
                          color: effectiveColor.withValues(alpha: 0.34),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
