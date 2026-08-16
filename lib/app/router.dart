import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:bac_nafa/app/main_scaffold.dart';
import 'package:bac_nafa/app/splash/splash_page.dart';
import 'package:bac_nafa/core/design/page_transitions.dart';
import 'package:bac_nafa/features/home/presentation/pages/home_page.dart';
import 'package:bac_nafa/features/subjects/presentation/pages/subjects_page.dart';
import 'package:bac_nafa/features/subjects/presentation/pages/series_page.dart';
import 'package:bac_nafa/features/subjects/presentation/pages/years_page.dart';
import 'package:bac_nafa/features/subjects/presentation/pages/exam_papers_page.dart';
import 'package:bac_nafa/features/exam_viewer/presentation/pages/exam_viewer_page.dart';
import 'package:bac_nafa/features/library/presentation/pages/library_page.dart';
import 'package:bac_nafa/features/profile/presentation/pages/profile_screen.dart';
import 'package:bac_nafa/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:bac_nafa/features/auth/presentation/pages/login_page.dart';

import 'package:bac_nafa/features/quiz/presentation/pages/quiz_page.dart';
import 'package:bac_nafa/features/quiz/providers/quiz_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) =>
          AppPageTransitions.scaleFade(child: const SplashPage(), state: state),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) =>
          AppPageTransitions.fadeThrough(child: const OnboardingPage(), state: state),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) =>
          AppPageTransitions.fadeThrough(child: const LoginPage(), state: state),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) =>
          AppPageTransitions.slideUp(child: const LoginPage(), state: state),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) =>
                  AppPageTransitions.scaleFade(child: const HomePage(), state: state),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/subjects',
              pageBuilder: (context, state) =>
                  AppPageTransitions.fadeThrough(child: const YearsPageAsYears(), state: state),
            ),
            GoRoute(
              path: '/subjects/:yearId/series',
              pageBuilder: (context, state) {
                final yearId = state.pathParameters['yearId'] ?? '';
                return AppPageTransitions.slideFromRight(
                    child: SeriesPageAsSeries(yearId: yearId), state: state);
              },
            ),
            GoRoute(
              path: '/subjects/:yearId/series/:seriesId/subjects',
              pageBuilder: (context, state) =>
                  AppPageTransitions.slideFromRight(child: const SubjectsPageAsSubjects(), state: state),
            ),
            GoRoute(
              path: '/exams',
              pageBuilder: (context, state) =>
                  AppPageTransitions.slideFromRight(child: const ExamPapersPage(), state: state),
            ),
            GoRoute(
              path: '/exam/:id',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id'] ?? '';
                return AppPageTransitions.slideFromRight(
                  child: ExamViewerPage(examId: id),
                  state: state,
                );
              },
            ),
            GoRoute(
              path: '/library',
              pageBuilder: (context, state) =>
                  AppPageTransitions.fadeThrough(child: const LibraryPage(), state: state),
            ),
          ],
        ),
        StatefulShellBranch(
          initialLocation: '/quiz/1',
          routes: [
            GoRoute(
              path: '/quiz/:id',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id'] ?? '1';
                return AppPageTransitions.slideUp(
                  child: ProviderScope(child: _QuizPageWrapper(quizId: id)),
                  state: state,
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) =>
                  AppPageTransitions.fadeThrough(child: const ProfileScreen(), state: state),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.error}')),
  ),
);

class _QuizPageWrapper extends ConsumerWidget {
  final String quizId;
  const _QuizPageWrapper({required this.quizId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizAsync = ref.watch(quizByIdProvider(quizId));
    return quizAsync.when(
      data: (quiz) {
        if (quiz == null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_off_rounded, color: Colors.grey, size: 48),
                  const SizedBox(height: 12),
                  const Text('Quiz non trouvé'),
                ],
              ),
            ),
          );
        }
        return QuizPage(quiz: quiz);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Erreur: $e')),
      ),
    );
  }
}