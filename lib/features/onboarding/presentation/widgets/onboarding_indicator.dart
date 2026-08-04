import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final Color? activeColor;
  final Color? inactiveColor;

  const OnboardingIndicator({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeColor ?? Theme.of(context).colorScheme.primary;
    final inactive = inactiveColor ?? Theme.of(context).colorScheme.outlineVariant;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 28 : 6,
          decoration: BoxDecoration(
            color: isActive ? active : inactive,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}