import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/onboarding/models/onboarding_data.dart';

class OnboardingNotifier extends Notifier<OnboardingData> {
  @override
  OnboardingData build() {
    return const OnboardingData();
  }

  void updateClass(String className) {
    state = state.copyWith(selectedClass: className);
  }

  void updateSeries(String seriesName) {
    state = state.copyWith(selectedSeries: seriesName);
  }

  void updateGoals(List<String> goals) {
    state = state.copyWith(selectedGoals: goals);
  }
}

final onboardingProvider = NotifierProvider<OnboardingNotifier, OnboardingData>(() {
  return OnboardingNotifier();
});

class AuthStateNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setAuthenticated(bool value) => state = value;
}

final authStateProvider = NotifierProvider<AuthStateNotifier, bool>(() {
  return AuthStateNotifier();
});

class FirstLaunchNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void setFirstLaunch(bool value) => state = value;
}

final isFirstLaunchProvider = NotifierProvider<FirstLaunchNotifier, bool>(() {
  return FirstLaunchNotifier();
});
