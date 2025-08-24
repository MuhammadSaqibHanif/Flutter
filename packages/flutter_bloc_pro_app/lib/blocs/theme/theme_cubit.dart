import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void toggleTheme() =>
      emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final mode = json['mode'] as String?;
    if (mode == 'light') return ThemeMode.light;
    if (mode == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {
      'mode':
          state == ThemeMode.light
              ? 'light'
              : state == ThemeMode.dark
              ? 'dark'
              : 'system',
    };
  }
}
