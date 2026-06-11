import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isLoggedIn;
  final bool hasCompletedOnboarding;

  const AuthState({
    required this.isLoggedIn,
    required this.hasCompletedOnboarding,
  });
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() =>
      const AuthState(isLoggedIn: false, hasCompletedOnboarding: false);

  void login() =>
      state = AuthState(isLoggedIn: true, hasCompletedOnboarding: state.hasCompletedOnboarding);

  void completeOnboarding() =>
      state = const AuthState(isLoggedIn: true, hasCompletedOnboarding: true);

  void logout() =>
      state = const AuthState(isLoggedIn: false, hasCompletedOnboarding: false);
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
