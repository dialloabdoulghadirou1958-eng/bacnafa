import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/design/app_spacing.dart';
import '../../core/design/app_radius.dart';
import '../../core/design/app_shadows.dart';

class AppCardPremium extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadows;
  final BorderSide? border;

  const AppCardPremium({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.shadows,
    this.border,
  });

  @override
  State<AppCardPremium> createState() => _AppCardPremiumState();
}

class _AppCardPremiumState extends State<AppCardPremium> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onTap != null ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.onTap != null ? () => setState(() => _isPressed = false) : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.padding ?? EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            boxShadow: widget.shadows ?? AppShadows.soft,
            border: Border.all(
              color: widget.border?.color ?? AppColors.borderSubtle,
              width: widget.border?.width ?? 1.0,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}