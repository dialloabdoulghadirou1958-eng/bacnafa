import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bac_nafa/features/auth/providers/auth_provider.dart';
import 'package:bac_nafa/features/library/data/mock_library_repositories.dart';
import 'package:bac_nafa/features/library/domain/models/library_models.dart';
import 'package:bac_nafa/features/library/providers/library_providers.dart';
import 'package:bac_nafa/features/onboarding/models/onboarding_data.dart';
import 'package:bac_nafa/features/onboarding/providers/onboarding_provider.dart';
import 'package:bac_nafa/features/quiz/providers/quiz_providers.dart';
import 'package:bac_nafa/features/subjects/data/repositories/mock_exam_repository.dart';
import 'package:bac_nafa/features/subjects/data/repositories/mock_subject_repository.dart';
import 'package:bac_nafa/features/subjects/domain/models/bac_series.dart';
import 'package:bac_nafa/features/subjects/domain/models/bac_year.dart';
import 'package:bac_nafa/features/subjects/domain/models/subject.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/repository_providers.dart';
import 'package:bac_nafa/features/subjects/presentation/providers/subjects_providers.dart';

void main() {
  group('auth provider', () {
    test('loginMock / logout change AuthStatus correctly', () async {
      final container = ProviderContainer();

      expect(container.read(authProvider), AuthStatus.unauthenticated);

      await container.read(authProvider.notifier).loginMock();
      expect(container.read(authProvider), AuthStatus.authenticated);

      container.read(authProvider.notifier).logout();
      expect(container.read(authProvider), AuthStatus.unauthenticated);

      container.dispose();
    });
  });

  group('onboarding provider', () {
    test('updates class and series and preserves the model structure', () {
      final container = ProviderContainer();

      final onboarding = container.read(onboardingProvider);
      expect(onboarding, const OnboardingData());

      container.read(onboardingProvider.notifier).updateClass('Terminale');
      container
          .read(onboardingProvider.notifier)
          .updateSeries('Sciences Expérimentales');
      container.read(onboardingProvider.notifier).updateGoals([
        'Réviser',
        'Travailler',
      ]);

      final updated = container.read(onboardingProvider);
      expect(updated.selectedClass, 'Terminale');
      expect(updated.selectedSeries, 'Sciences Expérimentales');
      expect(updated.selectedGoals, ['Réviser', 'Travailler']);

      container.dispose();
    });

    test('first launch provider can be toggled', () {
      final container = ProviderContainer();

      expect(container.read(isFirstLaunchProvider), true);

      container.read(isFirstLaunchProvider.notifier).setFirstLaunch(false);
      expect(container.read(isFirstLaunchProvider), false);

      container.dispose();
    });
  });

  group('quiz provider', () {
    test('loads quizzes and resolves them by id', () async {
      final container = ProviderContainer();

      final quizzes = await container.read(quizzesProvider.future);
      expect(quizzes, isNotEmpty);
      expect(quizzes.first.title, 'Math Quiz');

      final quiz = await container.read(quizByIdProvider('1').future);
      expect(quiz, isNotNull);
      expect(quiz!.id, '1');

      final missingQuiz = await container.read(
        quizByIdProvider('missing').future,
      );
      expect(missingQuiz, isNull);

      container.dispose();
    });
  });

  group('subjects filtering logic', () {
    test(
      'filters exams by subject, series, year and correction status',
      () async {
        final repository = MockExamRepository();

        final exams = await repository.getExams(
          subjectId: 'sub_1',
          seriesId: 'ser_1',
          yearId: 'y2025',
        );

        final filtered = exams.where((exam) {
          final matchesQuery = exam.title.toLowerCase().contains('rattrapage');
          final matchesCorrection = exam.hasCorrection == false;
          return matchesQuery && matchesCorrection;
        }).toList();

        expect(filtered.length, 1);
        expect(filtered.first.id, 'ex_2');
        expect(filtered.first.hasCorrection, false);
      },
    );
  });

  group('history repository', () {
    test(
      'keeps most recent exam at the top and respects the max size',
      () async {
        final repository = MockRecentExamRepository();

        for (int i = 0; i < 21; i++) {
          await repository.addToHistory(
            HistoryItem(
              itemId: 'exam_$i',
              title: 'Sujet $i',
              subjectName: 'Mathématiques',
              year: '2025',
              accessedAt: DateTime.now().add(Duration(minutes: i)),
            ),
          );
        }

        final history = await repository.getHistory();
        expect(history.length, 20);
        expect(history.first.itemId, 'exam_20');
        expect(history.last.itemId, 'exam_1');
      },
    );
  });

  group('favorite repository', () {
    test('adds and removes favorites in memory', () async {
      final repository = MockFavoriteRepository();
      final item = FavoriteItem(
        id: 'fav_1',
        type: FavoriteType.subject,
        itemId: 'exam_1',
        title: 'Sujet 1',
        createdAt: DateTime.now(),
      );

      await repository.addFavorite(item);
      expect(
        await repository.isFavorite('exam_1', FavoriteType.subject),
        isTrue,
      );

      await repository.removeFavorite('fav_1');
      expect(
        await repository.isFavorite('exam_1', FavoriteType.subject),
        isFalse,
      );
    });
  });
}
