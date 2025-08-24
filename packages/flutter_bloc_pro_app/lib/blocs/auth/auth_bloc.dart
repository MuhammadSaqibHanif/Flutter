import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import '../../models/user.dart';
import '../../repositories/auth_repository.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    // If hydration already restored a terminal state, don't override it.
    if (state is AuthAuthenticated || state is AuthUnauthenticated) return;

    emit(AuthLoading());
    try {
      final current = await authRepository.getCurrentUser();
      if (current != null) {
        emit(AuthAuthenticated(user: current));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(
        username: event.username,
        password: event.password,
      );
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      switch (json['type'] as String?) {
        case 'authenticated':
          final user = User.fromJson(json['user'] as Map<String, dynamic>);
          return AuthAuthenticated(user: user);
        case 'unauthenticated':
          return AuthUnauthenticated();
        default:
          return AuthUnauthenticated();
      }
    } catch (_) {
      return AuthUnauthenticated();
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is AuthAuthenticated) {
      return {'type': 'authenticated', 'user': state.user.toJson()};
    }
    // Persist unauthenticated so app routes to /login on next launch.
    return {'type': 'unauthenticated'};
  }
}
