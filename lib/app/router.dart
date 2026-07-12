import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:bac_nafa/app/main_scaffold.dart';
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
import 'package:bac_nafa/features/onboarding/presentation/pages/splash_page.dart';
import 'package:bac_nafa/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:bac_nafa/features/auth/presentation/pages/login_page.dart';
import 'package:bac_nafa/features/auth/presentation/pages/register_page.dart';

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
