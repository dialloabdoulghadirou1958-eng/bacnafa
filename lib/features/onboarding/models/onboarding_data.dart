import 'package:flutter/material.dart';

class OnboardingData {
  final String selectedClass;
  final String selectedSeries;
  final List<String> selectedGoals;

  const OnboardingData({
    this.selectedClass = '',
    this.selectedSeries = '',
    this.selectedGoals = const [],
  });

  OnboardingData copyWith({
    String? selectedClass,
    String? selectedSeries,
    List<String>? selectedGoals,
  }) {
    return OnboardingData(
      selectedClass: selectedClass ?? this.selectedClass,
      selectedSeries: selectedSeries ?? this.selectedSeries,
      selectedGoals: selectedGoals ?? this.selectedGoals,
    );
  }
}
