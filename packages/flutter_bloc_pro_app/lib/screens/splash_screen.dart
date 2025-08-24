import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<AuthState>? _sub;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // Handle hydrated state immediately.
    _routeFor(context.read<AuthBloc>().state);

    // And react to any future changes (e.g., logout).
    _sub = context.read<AuthBloc>().stream.distinct().listen(_routeFor);
  }

  void _routeFor(AuthState state) {
    if (!mounted || _navigated) return;

    if (state is AuthAuthenticated) {
      _navigated = true;
      Future.microtask(
        () => Navigator.of(context).pushReplacementNamed('/home'),
      );
    } else if (state is AuthUnauthenticated) {
      _navigated = true;
      Future.microtask(
        () => Navigator.of(context).pushReplacementNamed('/login'),
      );
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
