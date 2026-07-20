import 'package:flutter/material.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';


class IllustrationCircle extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const IllustrationCircle({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.08),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, size: 45, color: color),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w800,
            fontSize: 10,
            letterSpacing: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

}
