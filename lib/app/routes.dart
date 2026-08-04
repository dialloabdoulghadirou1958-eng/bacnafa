class AppRoutes {
  AppRoutes._();

  static const home = '/home';
  static const subjects = '/subjects';
  static const ai = '/ai';
  static const profile = '/profile';
  static const login = '/login';
  static const register = '/register';
  static const onboarding = '/onboarding';

  static const splash = '/';

  static String exam(String id) => '/exam/$id';
  static String quiz(String id) => '/quiz/$id';
  static String aiWithExam({required String examId, required String title, required String subject}) {
    return '/ai?examId=$examId&title=${Uri.encodeComponent(title)}&subject=${Uri.encodeComponent(subject)}';
  }
}