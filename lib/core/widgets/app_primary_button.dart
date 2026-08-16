import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/design/app_dimensions.dart';
import '../../core/design/app_radius.dart';
import '../../core/design/app_spacing.dart';

/// A high-emphasis action with a soft gradient and immediate press feedback.
class AppPrimaryButton extends StatefulWidget {
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
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  bool get _isEnabled => !widget.isLoading && widget.onPressed != null;

  void _setPressed(bool value) {
    if (_isEnabled && mounted) setState(() => _isPressed = value);
  }

  void _setHovered(bool value) {
    if (_isEnabled && mounted) setState(() => _isHovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = widget.backgroundColor ?? AppColors.primary;
    final effectiveFgColor = widget.foregroundColor ?? AppColors.onPrimary;
    final borderRadius = BorderRadius.circular(AppRadius.button);
    final enabled = _isEnabled;
    final foreground = widget.outlined ? effectiveBgColor : effectiveFgColor;
    final endColor = Color.lerp(effectiveBgColor, Colors.white, 0.12) ??
        effectiveBgColor;
    final shadow = !enabled || widget.outlined
        ? <BoxShadow>[]
        : [
            BoxShadow(
              color: effectiveBgColor.withValues(
                alpha: _isPressed ? 0.12 : _isHovered ? 0.30 : 0.22,
              ),
              blurRadius: _isPressed ? 8 : _isHovered ? 20 : 15,
              offset: Offset(0, _isPressed ? 3 : _isHovered ? 9 : 6),
              spreadRadius: -5,
            ),
          ];

    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.text,
      child: MouseRegion(
        cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: enabled ? (_) => _setHovered(true) : null,
        onExit: enabled ? (_) => _setHovered(false) : null,
        child: AnimatedScale(
          scale: _isPressed ? 0.985 : 1,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            width: widget.width ?? double.infinity,
            height: AppDimensions.buttonHeight,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: widget.outlined
                    ? (enabled ? AppColors.surface : AppColors.surfaceContainerHigh)
                    : (!enabled ? AppColors.surfaceContainerHigh : null),
                gradient: widget.outlined || !enabled
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [endColor, effectiveBgColor],
                      ),
                borderRadius: borderRadius,
                border: Border.all(
                  color: widget.outlined
                      ? (enabled ? effectiveBgColor : AppColors.borderMedium)
                      : Colors.transparent,
                  width: widget.outlined ? 1.5 : 0,
                ),
                boxShadow: shadow,
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: borderRadius,
                child: InkWell(
                  onTap: enabled ? widget.onPressed : null,
                  onTapDown: enabled ? (_) => _setPressed(true) : null,
                  onTapUp: enabled ? (_) => _setPressed(false) : null,
                  onTapCancel: enabled ? () => _setPressed(false) : null,
                  borderRadius: borderRadius,
                  splashColor: Colors.white.withValues(alpha: 0.16),
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.white.withValues(alpha: 0.05),
                  child: Center(child: _buildChild(foreground)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(Color foreground) {
    if (widget.isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2.5, color: foreground),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: AppDimensions.iconMedium, color: foreground),
          SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            widget.text,
            style: AppTextStyles.buttonText.copyWith(color: foreground),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
