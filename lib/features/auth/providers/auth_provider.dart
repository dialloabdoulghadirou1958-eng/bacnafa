import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
}

class AuthNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    return AuthStatus.unauthenticated;
  }

  Future<void> loginMock() async {
    state = AuthStatus.loading;
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    state = AuthStatus.authenticated;
  }

  Future<void> registerMock() async {
    state = AuthStatus.loading;
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    state = AuthStatus.authenticated;
  }

  void logout() {
    state = AuthStatus.unauthenticated;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthStatus>(AuthNotifier.new);
