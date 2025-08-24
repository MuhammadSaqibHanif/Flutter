import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_router.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/theme/theme_cubit.dart';
import 'repositories/auth_repository.dart';
import 'repositories/posts_repository.dart';

class FlutterBlocProApp extends StatelessWidget {
  const FlutterBlocProApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final postsRepository = PostsRepository();

    final router = AppRouter();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<PostsRepository>.value(value: postsRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create:
                (_) =>
                    AuthBloc(authRepository: authRepository)..add(AppStarted()),
          ),
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: 'Flutter BLoC Pro App',
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeMode,
              onGenerateRoute: router.onGenerateRoute,
              navigatorKey: router.navigatorKey,
            );
          },
        ),
      ),
    );
  }
}
