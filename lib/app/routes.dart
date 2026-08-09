class AppRoutes {
  AppRoutes._();

  static const home = '/home';
  static const subjects = '/subjects';
  static const profile = '/profile';
  static const login = '/login';
  static const register = '/register';
  static const onboarding = '/onboarding';

  static const splash = '/';

  static String exam(String id) => '/exam/$id';
  static String quiz(String id) => '/quiz/$id';
}