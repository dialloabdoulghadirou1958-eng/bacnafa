import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:bac_nafa/app/main_scaffold.dart';
import 'package:bac_nafa/app/splash/splash_page.dart';
import 'package:bac_nafa/features/home/presentation/pages/home_page.dart';
import 'package:bac_nafa/features/subjects/presentation/pages/subjects_page.dart';
import 'package:bac_nafa/features/subjects/presentation/pages/series_page.dart';
import 'package:bac_nafa/features/subjects/presentation/pages/years_page.dart';
import 'package:bac_nafa/features/subjects/presentation/pages/exam_papers_page.dart';
import 'package:bac_nafa/features/exam_viewer/presentation/pages/exam_viewer_page.dart';
import 'package:bac_nafa/features/library/presentation/pages/library_page.dart';
import 'package:bac_nafa/features/ai_assistant/presentation/pages/ai_chat_page.dart';
import 'package:bac_nafa/features/ai_assistant/presentation/pages/ai_history_page.dart';
import 'package:bac_nafa/features/profile/presentation/pages/profile_screen.dart';
import 'package:bac_nafa/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:bac_nafa/features/auth/presentation/pages/login_page.dart';
import 'package:bac_nafa/features/auth/presentation/pages/register_page.dart';
import 'package:bac_nafa/features/quiz/presentation/pages/quiz_page.dart';
import 'package:bac_nafa/features/quiz/providers/quiz_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/subjects',
          builder: (context, state) => const SubjectsPage(),
        ),
        GoRoute(
          path: '/subjects/:subjectId/series',
          builder: (context, state) => const SeriesPage(),
        ),
        GoRoute(
          path: '/subjects/:subjectId/series/:seriesId/years',
          builder: (context, state) => const YearsPage(),
        ),
        GoRoute(
          path: '/exams',
          builder: (context, state) => const ExamPapersPage(),
        ),
        GoRoute(
          path: '/exam/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return ExamViewerPage(examId: id);
          },
        ),
        GoRoute(
          path: '/library',
          builder: (context, state) => const LibraryPage(),
        ),
        GoRoute(
          path: '/ai',
          builder: (context, state) => const AIChatPage(),
        ),
        GoRoute(
          path: '/assistant/history',
          builder: (context, state) => const AIHistoryPage(),
        ),
        GoRoute(
          path: '/quiz/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '1';
            return ProviderScope(
              child: _QuizPageWrapper(quizId: id),
            );
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
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