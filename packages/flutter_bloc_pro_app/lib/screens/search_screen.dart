import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/search/search_cubit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Search')),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Search...'),
                onChanged: (q) => context.read<SearchCubit>().setQuery(q),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      itemCount: state.results.length,
                      itemBuilder:
                          (context, index) =>
                              ListTile(title: Text(state.results[index])),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
