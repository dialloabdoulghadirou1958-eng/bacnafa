import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../core/design/app_radius.dart';
import '../../core/design/app_shadows.dart';
import '../../core/design/app_spacing.dart';

/// A tactile surface used throughout the application.
///
/// Interactive cards lift very slightly on hover and compress on touch so every
/// navigation action has a clear, short feedback without making the layout move.
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
  bool _isHovered = false;

  bool get _isInteractive => widget.onTap != null;

  void _setPressed(bool value) {
    if (_isInteractive && mounted) {
      setState(() => _isPressed = value);
    }
  }

  void _setHovered(bool value) {
    if (_isInteractive && mounted) {
      setState(() => _isHovered = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppRadius.card);
    final baseShadows = widget.shadows ?? AppShadows.soft;
    final isLifted = _isInteractive && _isHovered && !_isPressed;
    final shadows = _isPressed
        ? AppShadows.subtle
        : isLifted
        ? [
            ...baseShadows,
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.10),
              blurRadius: 18,
              offset: const Offset(0, 8),
              spreadRadius: -7,
            ),
          ]
        : baseShadows;
    final border = widget.border ??
        const BorderSide(color: AppColors.borderSubtle, width: 1);
    final overlayColor = _isPressed
        ? Colors.black.withValues(alpha: 0.045)
        : _isHovered
        ? Colors.white.withValues(alpha: 0.055)
        : Colors.transparent;

    return Semantics(
      button: _isInteractive,
      child: MouseRegion(
        cursor: _isInteractive
            ? SystemMouseCursors.click
            : MouseCursor.defer,
        onEnter: _isInteractive ? (_) => _setHovered(true) : null,
        onExit: _isInteractive ? (_) => _setHovered(false) : null,
        child: AnimatedSlide(
          offset: isLifted ? const Offset(0, -0.012) : Offset.zero,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedScale(
            scale: _isPressed ? 0.985 : 1,
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: borderRadius,
                boxShadow: shadows,
                border: Border.fromBorderSide(border),
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: widget.onTap,
                    onTapDown: _isInteractive ? (_) => _setPressed(true) : null,
                    onTapUp: _isInteractive ? (_) => _setPressed(false) : null,
                    onTapCancel: _isInteractive ? () => _setPressed(false) : null,
                    splashColor: AppColors.primary.withValues(alpha: 0.08),
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    borderRadius: borderRadius,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      curve: Curves.easeOutCubic,
                      padding: widget.padding ?? EdgeInsets.all(AppSpacing.md),
                      foregroundDecoration: BoxDecoration(color: overlayColor),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
