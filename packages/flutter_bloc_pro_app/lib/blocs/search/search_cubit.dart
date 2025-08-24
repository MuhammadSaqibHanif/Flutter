import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchState {
  final String query;
  final bool loading;
  final List<String> results;
  SearchState({
    required this.query,
    this.loading = false,
    this.results = const [],
  });
}

class SearchCubit extends Cubit<SearchState> {
  Timer? _debounce;
  SearchCubit() : super(SearchState(query: ''));

  void setQuery(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      emit(SearchState(query: q, loading: true));
      // simulate search
      await Future.delayed(const Duration(milliseconds: 400));
      final results = List.generate(5, (i) => '$q result $i');
      emit(SearchState(query: q, loading: false, results: results));
    });
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
