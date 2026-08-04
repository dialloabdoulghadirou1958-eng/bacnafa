import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/features/auth/providers/auth_provider.dart';

enum AuthViewStatus {
  loading,
  authenticated,
  unauthenticated,
}

final authStatusProvider = Provider<AuthViewStatus>((ref) {
  final auth = ref.watch(authProvider);
  return switch (auth) {
    AuthStatus.loading => AuthViewStatus.loading,
    AuthStatus.authenticated => AuthViewStatus.authenticated,
    AuthStatus.unauthenticated => AuthViewStatus.unauthenticated,
  };
});

final logoutActionProvider = NotifierProvider<LogoutCoordinator, void>(
  LogoutCoordinator.new,
);

class LogoutCoordinator extends Notifier<void> {
  @override
  void build() {}

  void call() {
    ref.read(authProvider.notifier).logout();
  }
}