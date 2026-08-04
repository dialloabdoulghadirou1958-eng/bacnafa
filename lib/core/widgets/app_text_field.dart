import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/design/app_spacing.dart';
import '../../core/design/app_radius.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final ValueChanged<String>? onSubmitted;

  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = _hasFocus ? AppColors.primary : AppColors.outlineVariant;
    final fillColor = _hasFocus ? AppColors.primaryContainer.withValues(alpha: 0.2) : AppColors.surfaceContainerHighest;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppTextStyles.labelLarge.copyWith(color: _hasFocus ? AppColors.primary : AppColors.textSecondary),
        ),
        SizedBox(height: AppSpacing.xs),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.button),
            border: Border.all(color: borderColor, width: _hasFocus ? 1.5 : 1),
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.isPassword,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                fontSize: 15,
                color: AppColors.textTertiary,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        widget.prefixIcon,
                        color: _hasFocus ? AppColors.primary : AppColors.textTertiary,
                        size: 20,
                      ),
                    )
                  : null,
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: fillColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              isDense: false,
            ),
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}