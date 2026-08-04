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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.titleMedium,
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: effectiveColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                  ),
                  child: Text(
                    '${(value * 100).toInt()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: effectiveColor,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.circular),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 10,
                backgroundColor: effectiveTrackColor,
                valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
                semanticsLabel: '$label ${(progress * 100).toInt()}%',
              );
            },
          ),
        ),
      ],
    );
  }
}